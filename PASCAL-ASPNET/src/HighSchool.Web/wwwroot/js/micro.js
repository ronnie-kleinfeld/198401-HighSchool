// MICRO page: renders the machine state the server keeps in the session and replays OUT events in real time.
(() => {
  const $ = (id) => document.getElementById(id);
  const hex = (v, n) => v.toString(16).toUpperCase().padStart(n, "0");
  const SEG_BITS = { d: 7, c: 6, b: 5, a: 4, dp: 3, g: 2, f: 1, e: 0 }; // active low

  const consoleEl = $("console");
  const command = $("command");
  const history = [];
  let historyPos = 0;
  let state = JSON.parse($("micro-state").textContent);
  let running = false;
  let breakRequested = false;
  let waitingPort = null;

  // ---- rendering ----

  function renderConsole(lines) {
    consoleEl.replaceChildren(...lines.map((l) => {
      const row = document.createElement("div");
      const kind = l.kind.startsWith("print:") ? "info" : l.kind;
      row.className = `row2 ${kind}`;
      const left = document.createElement("span");
      const right = document.createElement("span");
      left.textContent = l.left;
      right.textContent = l.right;
      row.append(left, right);
      return row;
    }));
    consoleEl.scrollTop = consoleEl.scrollHeight;
  }

  function setLeds(value) {
    document.querySelectorAll("#leds .led").forEach((led) =>
      led.classList.toggle("on", (value >> Number(led.dataset.bit)) & 1));
  }

  function setDigit(index, value) {
    const svg = document.querySelector(`.digit[data-digit="${index}"]`);
    svg?.querySelectorAll("[data-seg]").forEach((seg) =>
      seg.classList.toggle("on", ((value >> SEG_BITS[seg.dataset.seg]) & 1) === 0));
  }

  function setText(text) { $("text").textContent = `[${text}]`; }

  function setTextChar(index, code) {
    const current = $("text").textContent.slice(1, -1).split("");
    current[index] = String.fromCharCode(code);
    setText(current.join(""));
  }

  function renderRegisters(s) {
    const r = s.registers;
    for (const k of ["b", "c", "d", "e", "h", "l", "mbc", "mde", "mhl", "mpc"]) $(`r-${k}`).textContent = hex(r[k], 2);
    $("r-a").textContent = hex(r.a, 2);
    $("r-abin").textContent = r.a.toString(2).padStart(8, "0");
    $("r-adec").textContent = String(r.a).padStart(3, " ");
    $("r-sp").textContent = hex(r.sp, 4);
    $("r-pc").textContent = hex(r.pc, 4);
    $("r-psw").textContent = hex(r.psw, 4);
    const f = s.flags;
    $("flags").innerHTML = [["s", f.s], ["z", f.z], ["p", f.p], ["c", f.cy]]
      .map(([n, on]) => (on ? `<b>${n.toUpperCase()}</b>` : n)).join(" ");
  }

  function render(s, { panel = true } = {}) {
    state = s;
    renderConsole(s.console);
    renderRegisters(s);
    if (panel) {
      setLeds(s.panel.leds);
      s.panel.digits.forEach((v, i) => setDigit(i, v));
      setText(s.panel.text);
    }
    $("beep-state").textContent = s.beep ? "ON" : "OFF";
    $("next").textContent = s.mode === "none" ? "" : `PC ${hex(s.registers.pc, 4)}: ${s.next}`;
    if (document.activeElement !== command || command.value === "") command.value = s.prompt ?? "";
    const p = s.console.at(-1)?.kind ?? "";
    if (p.startsWith("print:") && !render.printed?.has(s.console.length + p)) {
      (render.printed ??= new Set()).add(s.console.length + p);
      window.open(`/Micro/Print?range=${encodeURIComponent(p.slice(6))}`, "_blank");
    }
  }

  function setMode(mode) {
    const el = $("mode");
    el.textContent = mode;
    el.className = `mode ${mode}`;
    $("break").hidden = !(mode === "running" || mode === "trace" || mode === "input");
    $("step").hidden = mode !== "trace";
  }

  function beep() {
    if (!state.beep) return;
    try {
      const ctx = new AudioContext();
      const osc = ctx.createOscillator();
      osc.frequency.value = 880;
      osc.connect(ctx.destination);
      osc.start();
      osc.stop(ctx.currentTime + 0.12);
    } catch { /* no audio available */ }
  }

  // ---- running programs ----

  function applyEvent(e) {
    if (e.kind === "led") setLeds(e.value);
    else if (e.kind === "digit") setDigit(e.index, e.value);
    else if (e.kind === "text") setTextChar(e.index, e.value);
  }

  // Plays a batch's panel events on the simulated timeline (milliseconds from the batch start).
  function play(events, durationMs) {
    if (!events.length && durationMs < 20) return Promise.resolve();
    return new Promise((resolve) => {
      const start = performance.now();
      let i = 0;
      const frame = () => {
        const elapsed = performance.now() - start;
        while (i < events.length && events[i].t <= elapsed) applyEvent(events[i++]);
        if (breakRequested || elapsed >= durationMs) {
          while (i < events.length) applyEvent(events[i++]);
          resolve();
        } else requestAnimationFrame(frame);
      };
      requestAnimationFrame(frame);
    });
  }

  async function run(input) {
    if (running) return;
    running = true;
    breakRequested = false;
    waitingPort = null;
    showInput(null);
    setMode(state.mode === "trace" ? "trace" : "running");
    try {
      const ips = Number($("ips").value);
      let res = await postJson("/Micro/Run", { ips, input });
      while (true) {
        // Ask for the next batch while this one plays, so long runs animate without gaps.
        const next = res.status === "running" ? postJson("/Micro/Run", { ips }) : null;
        await play(res.events ?? [], res.durationMs ?? 0);
        render(res.state, { panel: false });
        if (breakRequested) {
          if (next) await next;
          render((await postJson("/Micro/Break")).state);
          setMode("idle");
          beep();
          return;
        }
        if (res.status === "running") { res = await next; continue; }
        if (res.status === "input") { setMode("input"); showInput(res.inputPort); return; }
        if (res.status === "trace") { setMode("trace"); return; }
        render(res.state);
        setMode("idle");
        beep();
        return;
      }
    } catch (err) {
      setMode("idle");
      alert(err.message);
    } finally {
      running = false;
    }
  }

  async function requestBreak() {
    if (running) { breakRequested = true; return; }
    render((await postJson("/Micro/Break")).state);
    showInput(null);
    setMode("idle");
  }

  // IN #00 waits for the switches + Enter; IN #FF waits for one key, as in the original.
  function showInput(port) {
    waitingPort = port ?? null;
    $("input-prompt").hidden = waitingPort !== 0;
    $("switches").classList.toggle("waiting", waitingPort === 0);
    if (waitingPort === 0) $("input-text").textContent = "Enter number #00 -> set the switches, then Enter";
    if (waitingPort === 0xff) {
      $("input-prompt").hidden = false;
      $("input-text").textContent = "Enter key in #FF: press a key";
      $("input-enter").hidden = true;
    } else $("input-enter").hidden = false;
  }

  function switchesValue() {
    let v = 0;
    document.querySelectorAll("#switches .switch").forEach((s) => {
      if (s.getAttribute("aria-pressed") === "true") v |= 1 << (8 - Number(s.dataset.switch));
    });
    return v;
  }

  // ---- commands ----

  $("command-form").addEventListener("submit", async (e) => {
    e.preventDefault();
    if (running) return;
    const line = command.value;
    if (line.trim()) { history.push(line); historyPos = history.length; }
    command.value = "";
    try {
      const res = await postJson("/Micro/Command", { line });
      render(res.state);
      if (res.state.mode === "go" || res.state.mode === "trace") await run();
    } catch (err) { alert(err.message); }
    command.focus();
  });

  command.addEventListener("keydown", (e) => {
    if (e.key === "ArrowUp" && historyPos > 0) { command.value = history[--historyPos]; e.preventDefault(); }
    if (e.key === "ArrowDown" && historyPos < history.length) {
      command.value = history[++historyPos] ?? "";
      e.preventDefault();
    }
  });

  $("break").addEventListener("click", requestBreak);
  $("step").addEventListener("click", () => run());
  $("input-enter").addEventListener("click", () => run(switchesValue()));
  document.querySelectorAll("#switches .switch").forEach((s) =>
    s.addEventListener("click", () => s.setAttribute("aria-pressed", s.getAttribute("aria-pressed") === "true" ? "false" : "true")));

  document.addEventListener("keydown", (e) => {
    const active = !!document.querySelector("dialog[open]");
    if (/^F[1359]$/.test(e.key)) { e.preventDefault(); openDialog(e.key); return; }
    if (active) return;
    const busy = running || state.mode === "trace" || waitingPort !== null;
    if (!busy) return;
    if (waitingPort === 0xff && e.key.length === 1 && !/[bB]/.test(e.key)) {
      e.preventDefault();
      run(e.key.charCodeAt(0) & 0xff);
    } else if (e.key === "b" || e.key === "B" || e.key === "Escape") {
      e.preventDefault();
      requestBreak();
    } else if (state.mode === "trace" && !running && (e.key === " " || e.key === "Enter")) {
      e.preventDefault();
      run();
    } else if (waitingPort === 0 && /^[1-8]$/.test(e.key)) {
      document.querySelector(`#switches [data-switch="${e.key}"]`).click();
    } else if (waitingPort === 0 && e.key === "Enter") {
      e.preventDefault();
      run(switchesValue());
    }
  });

  // ---- F-key windows ----

  function openDialog(key) {
    const dlg = $(`dlg-${key}`);
    if (!dlg || dlg.open) return;
    if (key === "F9") loadPrograms();
    dlg.showModal();
  }
  document.querySelectorAll("[data-fkey]").forEach((b) => b.addEventListener("click", () => openDialog(b.dataset.fkey)));
  document.querySelectorAll("dialog").forEach((d) => d.addEventListener("close", () => command.focus()));

  document.querySelectorAll("[data-operate]").forEach((b) => b.addEventListener("click", async () => {
    render((await postJson("/Micro/Operate", { action: b.dataset.operate })).state);
    if (b.dataset.operate === "registers") setMode("idle");
  }));

  async function loadPrograms() {
    $("io-error").textContent = "";
    const list = await (await fetch("/Micro/Programs")).json();
    $("programs").replaceChildren(...list.map((p) => {
      const tr = document.createElement("tr");
      tr.innerHTML = `<td></td><td>${p.start}</td><td>${p.range}</td>
        <td class="text-end"><button class="btn btn-sm btn-primary" data-load>Load</button>
        <button class="btn btn-sm btn-outline-danger" data-erase>Erase</button></td>`;
      tr.firstElementChild.textContent = p.name;
      tr.querySelector("[data-load]").addEventListener("click", () => ioAction("/Micro/LoadProgram", { name: p.name }, true));
      tr.querySelector("[data-erase]").addEventListener("click", () => {
        if (confirm(`!!! Confirm erasing ${p.name} !!!`)) ioAction("/Micro/EraseProgram", { name: p.name });
      });
      return tr;
    }));
  }

  async function ioAction(url, body, close) {
    try {
      const res = await postJson(url, body);
      if (res.state) render(res.state);
      if (close) $("dlg-F9").close(); else loadPrograms();
    } catch (err) { $("io-error").textContent = err.message; }
  }

  $("save-form").addEventListener("submit", (e) => {
    e.preventDefault();
    const f = new FormData(e.target);
    ioAction("/Micro/SaveProgram", { name: f.get("name"), from: f.get("from"), to: f.get("to") });
  });

  // ---- start ----
  render(state);
  setMode(state.mode === "trace" ? "trace" : "idle");
  if (state.mode === "go") run();
  command.focus();
})();
