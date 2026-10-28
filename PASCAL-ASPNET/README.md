# PASCAL → ASP.NET Core 10 MVC

The Turbo Pascal 3 programs in [`../PASCAL`](../PASCAL) (1987–88), migrated to an ASP.NET Core 10 MVC site.

```
dotnet run --project src/HighSchool.Web      # http://localhost:5051
dotnet test                                  # 308 tests
```

On first start the app creates `src/HighSchool.Web/App_Data/highschool.db` (SQLite) and imports the original
`.DAT` files from `../PASCAL` (`Legacy:DataPath` in `appsettings.json`). Delete the file to re-import.

## What maps to what

| Original | Web | Notes |
|---|---|---|
| `MICRO/MICRO-A/B/C.PAS`, `MCRNAME.DAT` | `/Micro` | 8085 trainer: monitor commands A O L K P S M G T R CLS, F1/F3/F5/F9 windows, LEDs, switches, 7-segment display, text line. CPU runs on the server in batches; the browser replays port writes in real time. |
| `ROMI/ROMI.PAS`, `ROMISTOR.DAT` | `/Romi` | Store directory: entry, search, edit/delete, +/- paging, the five printed reports. |
| `IQ/*.PAS`, `YEDA.DAT` | `/Iq` | 10-question drill, question editor, arrow-key drawing pad. |
| `MSD_WORK/MSD.PAS` | `/Msd` | Courses/sections, blocked times, clash-free timetable search with a weekly grid. |
| `PROGRAMS/NIHUL.PAS`, `NIHUL.DAT` | `/Nihul` | 15 transaction types, running balance, filtered statement. |
| `THINK`, `MAZE`, `TT-NEW`, `CODE`, `HEZKA`, `MICRO/CUBIA` | `/Classics` | Peg solitaire, maze walk, Toto filler, Caesar shift, power by addition, canyon. |

Not ported: the include/helper files (`INKEY`, `GETB`, `COLOR`, `TURBO.INC`, `GRAPH.P`), which the web UI replaces;
the Turbo Pascal compiler itself; personal data files `ASAF.DAT` and `CONECTIO.DAT`.

## Data conversion

- Records are read with their Turbo Pascal layouts (`string[n]` = length byte + n chars, 2-byte `integer`, 6-byte `real`): see `Legacy/`.
- Text is CP862 in DOS *visual* order; it is converted to logical Unicode Hebrew (`Legacy/VisualHebrew.cs`).
- Erased records (`EXE`/`KOD`/`BOL` = false) are skipped.

## Behaviour that intentionally differs from 1988

- **MICRO:** the CPU is a correct 8085. The original wrote `PUSH B/D` to the wrong stack bytes, read `LHLD` from the wrong address, got carry wrong in `SUB`/`CMP`/`DAD`, and had no AC flag or `DAA`. Kept from the original: the non-Intel `HOLD nnnn` delay (opcode 08), `SP=38FE`/`PC=2000` on reset, and the port map. `RST n` returns to the monitor. Undefined op codes stop with error 8 instead of being skipped.
- **NIHUL:** `K` (credit card) is a debit. The original never set a sign for it and reused the previous transaction's. In `NIHUL.DAT` this left one 345 charge with sign 0, so imported balances are recomputed and from that entry on they are 345 lower than the stored ones.
- **HEZKA:** a negative base gives a negative result when the *exponent* is odd (the original tested the base).
- **MSD:** clashes are tested as overlapping time intervals; the original's minute grid skipped some minutes.
