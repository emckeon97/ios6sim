# iOS 6 Simulator

A Mac app that runs iOS 6 inside — a faithful skeuomorphic recreation of the classic iPhone experience, built with SwiftUI for macOS.

## What it is

An interactive iPhone 5 running a loving recreation of iOS 6.1.4: slide-to-unlock lock screen, glossy home screen icons, and eight fully working mini-apps.

## The apps

| App | What it does |
|---|---|
| Notes | Yellow legal-pad notes, full CRUD, persisted |
| Calculator | Four-function with the dark iOS 6 look |
| Clock | Live analog + digital clock |
| Weather | Blue-linen forecast with city switcher (demo data) |
| Settings | Wallpaper picker, About |
| Photos | Gallery of the procedural wallpapers |
| Messages | **Your real iMessage/SMS threads**, read live from the Mac (read-only) |
| Reminders | Checklist, persisted |

## Messages setup

The Messages app reads `~/Library/Messages/chat.db` on your Mac at runtime — nothing is sent, copied, or logged. It needs **Full Disk Access** once:

1. Open System Settings → Privacy & Security → Full Disk Access
2. Add the **iOS 6** app
3. Reopen the Messages app inside the simulator

Your iPhone messages appear if iMessage syncing to the Mac is on.

## Build

Open `iOS6Sim.xcodeproj` in Xcode on a Mac, pick the iOS6Sim scheme, and run. macOS 14.0+.

`gen_pbxproj.py` regenerates the Xcode project file — the source of truth for the project structure.
