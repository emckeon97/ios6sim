# iOS 6 Simulator — Windows Port (.NET MAUI)

A Windows port of the **iOS 6 Simulator**: an interactive iPhone 5 running
iOS 6.1.4, rendered as a centered device frame on your desktop. Slide to
unlock, tap icons, swipe home pages, double-click the home button for the
multitasking switcher.

## Tech

- **.NET 10 MAUI**, Windows-only target (`net10.0-windows10.0.19041.0`)
- Pure MAUI views — no extra packages
- Icon art loads from `Resources/Raw/icon-<id>.png` (the same 23 PNGs as the
  iOS project's `IconArt/` folder)

## Build it (on Windows)

You need the **.NET 10 SDK** and **Visual Studio 2026** with the
“.NET Multi-platform App UI development” workload.

```powershell
cd windows\iOS6Sim.Windows
dotnet restore
dotnet build -c Release
dotnet run -c Release -f net10.0-windows10.0.19041.0
```

Or open the `.csproj` in Visual Studio and press F5 (target: Windows Machine).

> MAUI Windows targets must be built on Windows (your Parallels VM works).

## Controls

- **Home button** (below the screen): single click = home, double-click = app switcher
- **Lock screen**: drag the slider to unlock
- **Home screen**: swipe left/right (mouse-drag) for page 2, tap icons to open
- **Switcher**: ✕ closes an app, tap reopens it

## Icon art (copy these in)

Binaries don't live in git. On your Mac:

```bash
cd ~/Documents/ios6sim/iOS6Sim/IconArt
for d in *.imageset; do cp "$d/$(basename $d .imageset).png" \
  /path/to/windows/iOS6Sim.Windows/Resources/Raw/; done
```

That flattens the 23 `icon-<id>.png` files into `Resources/Raw/`.
Without them, icons render as empty frames.

## What's working

| App | Status |
|-----|--------|
| Lock screen, Home screen (2 pages), Dock, Status bar | ✅ |
| Multitasking switcher (double-click home) | ✅ |
| Calculator | ✅ fully working |
| Notes (persisted) | ✅ |
| Clock (live) | ✅ |
| Settings (toggles + jailbreak switch, persisted) | ✅ |
| Weather (Charlotte demo) | ✅ |
| Reminders (persisted checklist) | ✅ |
| evasi0n (jailbreak ritual → installs Cydia) | ✅ |
| Cydia (package browser demo) | ✅ |
| Phone, Mail, Safari, Music, Messages, Calendar, Photos, Camera, Maps, Stocks, Newsstand, iTunes, App Store, Game Center, YouTube, Passbook, Compass | 🚧 placeholder card — open `Views/AppViewFactory.cs` to add |

## Project map

| File | What |
|------|------|
| `Simulator/SimState.cs` | Screen state, home-button double-click, recents, jailbreak flag |
| `Simulator/AppId.cs` | The 25 app IDs, titles, dock/page layout |
| `Views/SimulatorPage` | Device frame + screen host + home button + switcher tray |
| `Views/LockScreenView.cs` | Slide to unlock |
| `Views/HomeScreenView.cs` | Icon grid, 2 pages, dock |
| `Views/IOS6UI.cs` | iOS 6 chrome: nav bar, status bar, linen |
| `Views/AppViewFactory.cs` | Routes AppId → view; placeholder for unported apps |
| `Apps/` | Calculator, Notes, Clock, Settings, Weather, Reminders, evasi0n, Cydia |

## Notes

- Jailbreak state persists (`ios6sim.jailbroken`); Cydia joins page 2 when set.
  Unjailbreak from Settings.
- Notes, reminders, and all Settings toggles persist via MAUI Preferences
  (same keys as iOS).
