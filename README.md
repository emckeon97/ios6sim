# iOS 6 Simulator

An iPhone app that runs iOS 6 inside — a faithful skeuomorphic recreation of the classic iPhone experience, built with SwiftUI for iOS.

## What it is

An interactive iPhone 5 running a loving recreation of iOS 6.1.4: slide-to-unlock lock screen, glossy home screen icons, circular home button, and eight fully working mini-apps. As close to stock iOS 6 as possible — wallpaper and all.

## The apps

| App | What it does |
|---|---|
| Notes | Yellow legal-pad notes, full CRUD, persisted |
| Calculator | Four-function with the dark iOS 6 look |
| Clock | Live analog + digital clock |
| Weather | Blue-linen forecast with swipeable city pages (demo data) |
| Settings | Wallpaper picker, About |
| Photos | Gallery of the procedural wallpapers |
| Messages | Shows a notice on iPhone (iOS sandbox blocks message access) |
| Reminders | Checklist, persisted |

## Build

Open `iOS6Sim.xcodeproj` in Xcode on a Mac, pick the iOS6Sim scheme, and run on your iPhone or the iOS Simulator. Requires iOS 17.0+.

`gen_pbxproj.py` regenerates the Xcode project file — the source of truth for the project structure.
