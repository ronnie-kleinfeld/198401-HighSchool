// POST JSON with the antiforgery token the layout renders; resolves to the parsed body or throws with the server's error.
window.postJson = async function (url, body) {
  const token = document.querySelector('input[name="__RequestVerificationToken"]')?.value ?? "";
  const response = await fetch(url, {
    method: "POST",
    headers: { "Content-Type": "application/json", "RequestVerificationToken": token },
    body: JSON.stringify(body ?? {}),
  });
  const data = await response.json().catch(() => ({}));
  if (!response.ok) throw new Error(data.error ?? `${response.status} ${response.statusText}`);
  return data;
};
