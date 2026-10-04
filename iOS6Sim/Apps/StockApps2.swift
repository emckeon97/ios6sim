import SwiftUI
import Combine

// MARK: - Calendar (real iOS 6 look: white, red accents)

struct SimCalEvent: Identifiable, Codable {
    var id = UUID()
    var title: String
    var date: Date
}

struct CalendarApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var events: [SimCalEvent] = []
    @State private var mode = 2 // 0 List, 1 Day, 2 Month
    @State private var selectedDay = 4
    @State private var showingNew = false
    @State private var newTitle = ""
    @State private var newHour = 9

    private let storeKey = "ios6sim.calEvents"
    private let todayDay = 4 // October 2026; Oct 4 2026 is a Sunday
    private let weekdays = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    private var cells: [Int?] {
        Array(repeating: nil, count: 4) + (1...31).map { Optional($0) } // Oct 1 2026 = Thursday
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: true)
                iOS6NavBar(
                    title: "October 2026",
                    right: AnyView(
                        Button {
                            newTitle = ""
                            newHour = 9
                            showingNew = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .padding(8)
                        }
                        .buttonStyle(.plain)
                    )
                )
                // Segmented scope bar like the real app.
                HStack {
                    iOS6Segmented(options: [(0, "List"), (1, "Day"), (2, "Month")], selection: $mode)
                }
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.95, green: 0.95, blue: 0.96))

                ZStack {
                    Color.white.ignoresSafeArea()
                    if mode == 2 { monthView }
                    else if mode == 1 { dayView }
                    else { listView }
                }
            }
            .onAppear(perform: load)

            if showingNew {
                newEventForm
                    .transition(.move(edge: .trailing))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: showingNew)
    }

    // MARK: Month

    private var monthView: some View {
        VStack(spacing: 0) {
            // Weekday header.
            HStack(spacing: 0) {
                ForEach(weekdays, id: \.self) { d in
                    Text(d)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                }
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.97))
            .overlay(Rectangle().fill(Color.black.opacity(0.12)).frame(height: 1), alignment: .bottom)

            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(cells.indices, id: \.self) { i in
                    if let day = cells[i] {
                        Button { selectedDay = day } label: {
                            VStack(spacing: 1) {
                                ZStack {
                                    if day == todayDay {
                                        Circle().fill(Color.red)
                                            .frame(width: 26, height: 26)
                                    } else if day == selectedDay {
                                        Circle().fill(Color.gray.opacity(0.45))
                                            .frame(width: 26, height: 26)
                                    }
                                    Text("\(day)")
                                        .font(.system(size: 14))
                                        .foregroundColor(day == todayDay ? .white : .black)
                                }
                                .frame(height: 30)
                                Circle()
                                    .fill(events(on: day).isEmpty ? Color.clear : Color.red)
                                    .frame(width: 5, height: 5)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 3)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Color.clear.frame(height: 44)
                    }
                }
            }

            // Selected day's events.
            VStack(alignment: .leading, spacing: 0) {
                Text(dayTitle(selectedDay))
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.55))
                    .padding(.horizontal, 12)
                    .padding(.top, 8)
                let evs = events(on: selectedDay)
                if evs.isEmpty {
                    Text("No Events")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .padding(12)
                } else {
                    ForEach(evs) { e in
                        HStack {
                            Circle().fill(Color.red).frame(width: 8, height: 8)
                            Text(e.title).font(.system(size: 14))
                            Spacer()
                            Text(timeString(e.date))
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 7)
                        Divider().padding(.leading, 12)
                    }
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
            .overlay(Rectangle().fill(Color.black.opacity(0.12)).frame(height: 1), alignment: .top)
        }
    }

    // MARK: Day

    private var dayView: some View {
        VStack(spacing: 0) {
            HStack {
                Button { if selectedDay > 1 { selectedDay -= 1 } } label: {
                    Image(systemName: "chevron.left").font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.85))
                        .padding(10)
                }
                .buttonStyle(.plain)
                Spacer()
                Text(dayTitle(selectedDay))
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color.red)
                Spacer()
                Button { if selectedDay < 31 { selectedDay += 1 } } label: {
                    Image(systemName: "chevron.right").font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.85))
                        .padding(10)
                }
                .buttonStyle(.plain)
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.97))
            let evs = events(on: selectedDay)
            if evs.isEmpty {
                Spacer()
                Text("No Events")
                    .font(.system(size: 15)).foregroundColor(.gray)
                Spacer()
            } else {
                ForEach(evs) { e in
                    HStack {
                        RoundedRectangle(cornerRadius: 3).fill(Color.red).frame(width: 4)
                        VStack(alignment: .leading) {
                            Text(e.title).font(.system(size: 15, weight: .medium))
                            Text(timeString(e.date)).font(.system(size: 12)).foregroundColor(.gray)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    Divider()
                }
                Spacer()
            }
        }
    }

    // MARK: List

    private var listView: some View {
        let sorted = events.sorted { $0.date < $1.date }
        return Group {
            if sorted.isEmpty {
                VStack {
                    Spacer()
                    Text("No Events").font(.system(size: 15)).foregroundColor(.gray)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(sorted) { e in
                            HStack {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(e.title).font(.system(size: 15, weight: .medium))
                                    Text(fullDateString(e.date))
                                        .font(.system(size: 12))
                                        .foregroundColor(Color.red)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.gray.opacity(0.5))
                            }
                            .padding(.horizontal, 14)
                            .padding(.vertical, 9)
                            Divider().padding(.leading, 14)
                        }
                    }
                }
            }
        }
    }

    // MARK: New event

    private var newEventForm: some View {
        VStack(spacing: 0) {
            iOS6NavBar(
                title: "New Event",
                left: AnyView(iOS6BackButton(label: "Cancel", action: { showingNew = false })),
                right: AnyView(
                    Button("Save") {
                        let comps = DateComponents(year: 2026, month: 10, day: selectedDay,
                                                   hour: newHour, minute: 0)
                        let date = Calendar.current.date(from: comps) ?? Date()
                        let title = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
                        events.append(SimCalEvent(title: title.isEmpty ? "New Event" : title, date: date))
                        save()
                        showingNew = false
                    }
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                )
            )
            ZStack {
                Color(red: 0.94, green: 0.94, blue: 0.96).ignoresSafeArea()
                VStack(spacing: 16) {
                    iOS6Section {
                        VStack(spacing: 0) {
                            iOS6Row {
                                TextField("Title", text: $newTitle)
                                    .font(.system(size: 15))
                            }
                            Divider().padding(.leading, 14)
                            iOS6Row {
                                HStack {
                                    Text("Starts")
                                        .font(.system(size: 15))
                                    Spacer()
                                    Stepper("\(hourString(newHour))", value: $newHour, in: 0...23)
                                        .font(.system(size: 15))
                                }
                            }
                            Divider().padding(.leading, 14)
                            iOS6Row {
                                HStack {
                                    Text("Day").font(.system(size: 15))
                                    Spacer()
                                    Text(dayTitle(selectedDay))
                                        .font(.system(size: 15))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    Spacer()
                }
                .padding(.top, 14)
            }
        }
        .background(Color.white)
    }

    // MARK: Helpers

    private func events(on day: Int) -> [SimCalEvent] {
        let cal = Calendar.current
        return events.filter {
            let c = cal.dateComponents([.year, .month, .day], from: $0.date)
            return c.year == 2026 && c.month == 10 && c.day == day
        }.sorted { $0.date < $1.date }
    }

    private func dayTitle(_ day: Int) -> String {
        // Oct 1 2026 = Thursday; weekday index cycles from there.
        let wd = (3 + day) % 7 // 0=Sunday
        let dayNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return "\(dayNames[wd]), October \(day)"
    }

    private func timeString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f.string(from: d)
    }

    private func fullDateString(_ d: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d, h:mm a"
        return f.string(from: d)
    }

    private func hourString(_ h: Int) -> String {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        let comps = DateComponents(year: 2026, month: 10, day: 4, hour: h, minute: 0)
        return f.string(from: Calendar.current.date(from: comps) ?? Date())
    }

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storeKey),
           let decoded = try? JSONDecoder().decode([SimCalEvent].self, from: data) {
            events = decoded
        } else {
            // Seed sample events on first run.
            let cal = Calendar.current
            func d(_ day: Int, _ hour: Int, _ min: Int) -> Date {
                cal.date(from: DateComponents(year: 2026, month: 10, day: day, hour: hour, minute: min)) ?? Date()
            }
            events = [
                SimCalEvent(title: "Amazon pre-hire appointment", date: d(7, 9, 30)),
                SimCalEvent(title: "Dentist appointment", date: d(13, 14, 0)),
                SimCalEvent(title: "Dinner with Mom", date: d(18, 18, 30)),
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(events) {
            UserDefaults.standard.set(data, forKey: storeKey)
        }
    }
}

// MARK: - Camera (full-bleed black, night viewfinder)

struct CameraApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var flashMode = 0 // 0 Auto, 1 On, 2 Off
    @State private var cameraMode = 1 // 0 Video, 1 Photo, 2 Pano
    @State private var panoCapturing = false
    @State private var panoProgress: Double = 0
    @State private var hdrOn = false
    @State private var frontCamera = false
    @State private var focusPoint: CGPoint? = nil
    @State private var focusVisible = false
    @State private var flash = false
    @State private var shutterScale: CGFloat = 1.0

    private let flashNames = ["Auto", "On", "Off"]
    private let stars: [(CGFloat, CGFloat, CGFloat)] = [
        (0.12, 0.15, 2), (0.28, 0.08, 1.5), (0.45, 0.20, 2), (0.60, 0.10, 1.5),
        (0.74, 0.22, 2), (0.88, 0.12, 1.5), (0.20, 0.32, 1.5), (0.52, 0.35, 2),
        (0.82, 0.34, 1.5), (0.36, 0.28, 1), (0.66, 0.30, 1), (0.08, 0.42, 1.5),
    ]

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar()
            // Top controls.
            HStack(spacing: 18) {
                Button { flashMode = (flashMode + 1) % 3 } label: {
                    Text("Flash \(flashNames[flashMode])")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                Button { hdrOn.toggle() } label: {
                    Text(hdrOn ? "HDR On" : "HDR Off")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                Spacer()
                Button { frontCamera.toggle() } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .frame(height: 40)
            .background(Color.black)

            // Viewfinder.
            GeometryReader { geo in
                ZStack {
                    nightScene
                        .scaleEffect(x: frontCamera ? -1 : 1, y: 1)
                    // Tap-to-focus square.
                    if let p = focusPoint, focusVisible {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.yellow, lineWidth: 1.5)
                            .frame(width: 64, height: 64)
                            .position(p)
                            .transition(.opacity)
                    }
                    // Shutter flash.
                    Color.white.opacity(flash ? 1 : 0)
                    // Panorama guide (iOS 6 signature feature).
                    if cameraMode == 2 {
                        VStack {
                            Spacer()
                            Text(panoCapturing ? "Capturing panorama…" : "Move iPhone continuously when taking a Panorama")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                                .padding(.horizontal, 12).padding(.vertical, 6)
                                .background(RoundedRectangle(cornerRadius: 6).fill(Color.black.opacity(0.6)))
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.right")
                                    .foregroundColor(.yellow)
                                GeometryReader { bar in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.white.opacity(0.3))
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(Color.yellow)
                                            .frame(width: bar.size.width * panoProgress)
                                    }
                                }
                                .frame(height: 6)
                            }
                            .padding(.horizontal, 30)
                            .padding(.bottom, 14)
                        }
                    }
                }
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onEnded { v in
                            focusPoint = v.location
                            withAnimation(.easeIn(duration: 0.15)) { focusVisible = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                                withAnimation(.easeOut(duration: 0.4)) { focusVisible = false }
                            }
                        }
                )
            }

            // iOS 6 mode selector: VIDEO • PHOTO • PANO.
            HStack(spacing: 0) {
                ForEach([("VIDEO", 0), ("PHOTO", 1), ("PANO", 2)], id: \.1) { m in
                    Button { cameraMode = m.1 } label: {
                        Text(m.0)
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(cameraMode == m.1 ? .yellow : .white.opacity(0.6))
                            .padding(.horizontal, 14).padding(.vertical, 6)
                    }.buttonStyle(.plain)
                }
            }
            .padding(.bottom, 4)
            // Bottom control bar.
            HStack {
                // Camera roll thumbnail.
                RoundedRectangle(cornerRadius: 4)
                    .fill(LinearGradient(colors: [Color(red: 0.15, green: 0.25, blue: 0.45),
                                                  Color(red: 0.05, green: 0.08, blue: 0.18)],
                                         startPoint: .top, endPoint: .bottom))
                    .frame(width: 44, height: 44)
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color.white.opacity(0.6), lineWidth: 1))
                Spacer()
                // Shutter button.
                Button(action: takePhoto) {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.25))
                            .frame(width: 70, height: 70)
                        Circle()
                            .fill(LinearGradient(colors: [.white, Color(white: 0.85)],
                                                 startPoint: .top, endPoint: .bottom))
                            .frame(width: 58, height: 58)
                            .overlay(Circle().stroke(Color.black.opacity(0.4), lineWidth: 1))
                    }
                    .scaleEffect(shutterScale)
                }
                .buttonStyle(.plain)
                Spacer()
                Button { frontCamera.toggle() } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.camera.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
                .buttonStyle(.plain)
                .frame(width: 44)
            }
            .padding(.horizontal, 20)
            .frame(height: 108)
            .background(Color.black)
        }
        .background(Color.black)
    }

    private var nightScene: some View {
        GeometryReader { geo in
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.01, green: 0.02, blue: 0.07),
                             Color(red: 0.04, green: 0.07, blue: 0.16)],
                    startPoint: .top, endPoint: .bottom)
                // Stars.
                ForEach(stars.indices, id: \.self) { i in
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: stars[i].2, height: stars[i].2)
                        .position(x: stars[i].0 * geo.size.width,
                                  y: stars[i].1 * geo.size.height * 0.7)
                }
                // Moon.
                Circle()
                    .fill(Color(red: 0.92, green: 0.93, blue: 0.88))
                    .frame(width: 34, height: 34)
                    .position(x: geo.size.width * 0.78, y: geo.size.height * 0.18)
                    .shadow(color: .white.opacity(0.4), radius: 12)
                // Hill silhouettes.
                Path { p in
                    p.move(to: CGPoint(x: 0, y: geo.size.height * 0.72))
                    p.addQuadCurve(to: CGPoint(x: geo.size.width * 0.5, y: geo.size.height * 0.62),
                                   control: CGPoint(x: geo.size.width * 0.25, y: geo.size.height * 0.55))
                    p.addQuadCurve(to: CGPoint(x: geo.size.width, y: geo.size.height * 0.70),
                                   control: CGPoint(x: geo.size.width * 0.75, y: geo.size.height * 0.60))
                    p.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height))
                    p.addLine(to: CGPoint(x: 0, y: geo.size.height))
                    p.closeSubpath()
                }
                .fill(Color(red: 0.02, green: 0.04, blue: 0.09))
                // Vignette.
                RadialGradient(colors: [Color.clear, Color.black.opacity(0.55)],
                               center: .center, startRadius: 60, endRadius: 260)
            }
        }
    }

    private func takePhoto() {
        if cameraMode == 2 {
            // Panorama: start/stop capture.
            if panoCapturing {
                panoCapturing = false
                withAnimation(.default) { panoProgress = 0 }
                return
            }
            panoCapturing = true
            panoProgress = 0
            withAnimation(.linear(duration: 6.0)) { panoProgress = 1.0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6.1) {
                guard panoCapturing else { return }
                panoCapturing = false
                withAnimation(.easeOut(duration: 0.08)) { flash = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    flash = false
                    panoProgress = 0
                }
            }
            return
        }
        withAnimation(.easeOut(duration: 0.08)) {
            flash = true
            shutterScale = 0.9
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            withAnimation(.easeOut(duration: 0.35)) { flash = false }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) { shutterScale = 1.0 }
        }
    }
}

// MARK: - Maps (iOS 6 beige Apple Maps)

struct MapsApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var query = ""
    @State private var mapType = 0 // 0 Map, 1 Satellite, 2 Hybrid
    @State private var baseOffset = CGSize.zero
    @State private var mapOffset = CGSize.zero
    @State private var showOptions = false
    @State private var pulse = false

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar(darkText: true)
                // Search bar.
                HStack(spacing: 8) {
                    TextField("Search", text: $query)
                        .font(.system(size: 14))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 7)
                        .background(Color.white)
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.black.opacity(0.25), lineWidth: 1))
                    Button("Search") { query = "" }
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color(red: 0.2, green: 0.4, blue: 0.85))
                        .buttonStyle(.plain)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    LinearGradient(colors: [Color(red: 0.88, green: 0.89, blue: 0.91),
                                            Color(red: 0.78, green: 0.80, blue: 0.83)],
                                   startPoint: .top, endPoint: .bottom)
                )

                // Map canvas.
                GeometryReader { geo in
                    ZStack {
                        mapCanvas(size: geo.size)
                            .offset(mapOffset)
                        // Red pin.
                        VStack(spacing: 0) {
                            Image(systemName: "mappin")
                                .font(.system(size: 30))
                                .foregroundColor(Color(red: 0.85, green: 0.15, blue: 0.15))
                                .shadow(color: .black.opacity(0.4), radius: 2, y: 2)
                        }
                        .position(x: geo.size.width * 0.62 + mapOffset.width,
                                  y: geo.size.height * 0.38 + mapOffset.height)
                        // Blue location dot.
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.25))
                                .frame(width: 44, height: 44)
                                .scaleEffect(pulse ? 1.4 : 0.8)
                                .opacity(pulse ? 0.4 : 0.9)
                            Circle().fill(Color(red: 0.2, green: 0.5, blue: 1.0))
                                .frame(width: 18, height: 18)
                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                .shadow(color: .black.opacity(0.4), radius: 2, y: 1)
                        }
                        .position(x: geo.size.width * 0.42 + mapOffset.width,
                                  y: geo.size.height * 0.55 + mapOffset.height)
                        .onAppear {
                            withAnimation(.easeInOut(duration: 1.6).repeatForever(autoreverses: true)) {
                                pulse = true
                            }
                        }
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .gesture(
                        DragGesture()
                            .onChanged { v in
                                mapOffset = CGSize(width: baseOffset.width + v.translation.width,
                                                   height: baseOffset.height + v.translation.height)
                            }
                            .onEnded { _ in baseOffset = mapOffset }
                    )
                }

                // Bottom toolbar.
                HStack {
                    Button {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            mapOffset = .zero
                            baseOffset = .zero
                        }
                    } label: {
                        Image(systemName: "location.fill")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.25, green: 0.35, blue: 0.55))
                    }
                    .buttonStyle(.plain)
                    Spacer()
                    Button { withAnimation { showOptions.toggle() } } label: {
                        ZStack {
                            Circle()
                                .fill(LinearGradient(colors: [.white, Color(white: 0.8)],
                                                     startPoint: .top, endPoint: .bottom))
                                .frame(width: 30, height: 30)
                                .overlay(Circle().stroke(Color.black.opacity(0.3), lineWidth: 1))
                                .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                            Text("i")
                                .font(.system(size: 16, weight: .bold, design: .serif))
                                .italic()
                                .foregroundColor(Color(red: 0.3, green: 0.3, blue: 0.35))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 16)
                .frame(height: 44)
                .background(
                    LinearGradient(colors: [Color(red: 0.88, green: 0.89, blue: 0.91),
                                            Color(red: 0.72, green: 0.74, blue: 0.78)],
                                   startPoint: .top, endPoint: .bottom)
                )
                .overlay(Rectangle().fill(Color.black.opacity(0.3)).frame(height: 1), alignment: .top)
            }

            // Map type popover.
            if showOptions {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        VStack(spacing: 10) {
                            iOS6Segmented(options: [(0, "Map"), (1, "Satellite"), (2, "Hybrid")],
                                          selection: $mapType)
                        }
                        .padding(12)
                        .background(Color(white: 0.12).opacity(0.92))
                        .cornerRadius(10)
                        .padding(.trailing, 10)
                        .padding(.bottom, 52)
                    }
                }
                .transition(.opacity)
            }
        }
    }

    private func mapCanvas(size: CGSize) -> some View {
        let w = size.width * 2.2
        let h = size.height * 2.2
        return ZStack {
            if mapType == 0 {
                Color(red: 0.93, green: 0.90, blue: 0.78)
            } else {
                Color(red: 0.09, green: 0.13, blue: 0.09)
            }
            // Satellite texture blobs.
            if mapType != 0 {
                Ellipse().fill(Color(red: 0.13, green: 0.18, blue: 0.12))
                    .frame(width: w * 0.5, height: h * 0.4).offset(x: -w * 0.2, y: -h * 0.2)
                Ellipse().fill(Color(red: 0.07, green: 0.10, blue: 0.08))
                    .frame(width: w * 0.6, height: h * 0.5).offset(x: w * 0.25, y: h * 0.2)
                Ellipse().fill(Color(red: 0.16, green: 0.17, blue: 0.13))
                    .frame(width: w * 0.4, height: h * 0.3).offset(x: w * 0.1, y: -h * 0.3)
            }
            // Water.
            Ellipse()
                .fill(mapType == 0 ? Color(red: 0.68, green: 0.82, blue: 0.90) : Color(red: 0.10, green: 0.16, blue: 0.24))
                .frame(width: w * 0.55, height: h * 0.45)
                .offset(x: w * 0.28, y: -h * 0.28)
                .rotationEffect(.degrees(-18))
            // Parks.
            if mapType == 0 {
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(red: 0.72, green: 0.84, blue: 0.62))
                    .frame(width: w * 0.28, height: h * 0.20)
                    .offset(x: -w * 0.28, y: h * 0.22)
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(red: 0.72, green: 0.84, blue: 0.62))
                    .frame(width: w * 0.18, height: h * 0.14)
                    .offset(x: w * 0.05, y: -h * 0.05)
            }
            // Roads.
            if mapType != 1 {
                road(w: w * 1.1, h: 10, angle: 12, dx: 0, dy: -h * 0.1)
                road(w: w * 1.1, h: 7, angle: -8, dx: 0, dy: h * 0.15)
                road(w: h * 1.1, h: 8, angle: 90, dx: -w * 0.15, dy: 0, vertical: true)
                road(w: h * 1.1, h: 6, angle: 90, dx: w * 0.18, dy: 0, vertical: true)
                road(w: w * 0.9, h: 12, angle: 32, dx: w * 0.05, dy: h * 0.05, highway: true)
            }
        }
        .frame(width: w, height: h)
    }

    private func road(w: CGFloat, h: CGFloat, angle: Double, dx: CGFloat, dy: CGFloat,
                      vertical: Bool = false, highway: Bool = false) -> some View {
        let color: Color = highway ? Color(red: 0.98, green: 0.80, blue: 0.45)
                                   : (mapType == 0 ? .white : Color.white.opacity(0.85))
        return Rectangle()
            .fill(color)
            .frame(width: vertical ? h : w, height: vertical ? w : h)
            .rotationEffect(.degrees(angle))
            .offset(x: dx, y: dy)
            .shadow(color: .black.opacity(0.15), radius: 1, y: 1)
    }
}

// MARK: - Stocks (black, Yahoo! Finance style)

struct SimStock: Identifiable {
    let id = UUID()
    let symbol: String
    var price: Double
    var prevClose: Double
    var change: Double { price - prevClose }
    var changePct: Double { prevClose == 0 ? 0 : change / prevClose * 100 }
}

struct StocksApp: View {
    @EnvironmentObject var sim: SimulatorState
    @State private var stocks: [SimStock] = [
        SimStock(symbol: "^DJI", price: 46250.30, prevClose: 46180.10),
        SimStock(symbol: "^GSPC", price: 6884.24, prevClose: 6862.90),
        SimStock(symbol: "AAPL", price: 278.42, prevClose: 276.10),
        SimStock(symbol: "GOOG", price: 312.55, prevClose: 315.20),
        SimStock(symbol: "YHOO", price: 58.24, prevClose: 57.80),
        SimStock(symbol: "MSFT", price: 545.10, prevClose: 542.36),
    ]
    @State private var selected = 2
    @State private var range = 0 // 0:1d 1:1w 2:1m 3:3m 4:6m 5:1y 6:2y

    private let ranges = ["1d", "1w", "1m", "3m", "6m", "1y", "2y"]
    private let upColor = Color(red: 0.25, green: 0.72, blue: 0.28)
    private let downColor = Color(red: 0.82, green: 0.25, blue: 0.22)
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar()
            // Chart header.
            VStack(spacing: 2) {
                Text(stocks[selected].symbol)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(String(format: "%.2f", stocks[selected].price))
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    let s = stocks[selected]
                    Text("\(s.change >= 0 ? "+" : "")\(String(format: "%.2f", s.change)) (\(String(format: "%.2f", s.changePct))%)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(s.change >= 0 ? upColor : downColor)
                }
            }
            .padding(.top, 8)

            // Chart.
            GeometryReader { geo in
                ZStack(alignment: .topLeading) {
                    // Grid.
                    VStack(spacing: 0) {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle().fill(Color.white.opacity(0.12)).frame(height: 1)
                            Spacer()
                        }
                    }
                    chartPath(in: geo.size)
                        .stroke(Color.white, lineWidth: 1.5)
                    // High / low labels.
                    let pts = chartValues()
                    if let hi = pts.max(), let lo = pts.min() {
                        Text(String(format: "%.2f", stocks[selected].price * (1 + (hi - 0.5) * 0.1)))
                            .font(.system(size: 10)).foregroundColor(.gray)
                            .position(x: 34, y: 12)
                        Text(String(format: "%.2f", stocks[selected].price * (1 + (lo - 0.5) * 0.1)))
                            .font(.system(size: 10)).foregroundColor(.gray)
                            .position(x: 34, y: geo.size.height - 12)
                    }
                }
                .padding(.horizontal, 8)
            }
            .frame(height: 170)

            // Range selector.
            HStack(spacing: 0) {
                ForEach(ranges.indices, id: \.self) { i in
                    Button { range = i } label: {
                        Text(ranges[i])
                            .font(.system(size: 12, weight: range == i ? .bold : .regular))
                            .foregroundColor(range == i ? .white : .gray)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                    }
                    .buttonStyle(.plain)
                }
            }
            .background(Color(white: 0.12))

            // Stock list.
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(stocks.indices, id: \.self) { i in
                        let s = stocks[i]
                        Button { selected = i } label: {
                            HStack {
                                Text(s.symbol)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 70, alignment: .leading)
                                Spacer()
                                Text(String(format: "%.2f", s.price))
                                    .font(.system(size: 15))
                                    .foregroundColor(.white)
                                Text("\(s.change >= 0 ? "+" : "")\(String(format: "%.2f", s.change))")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(width: 86, height: 30)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .fill(s.change >= 0 ? upColor : downColor)
                                    )
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(selected == i ? Color.white.opacity(0.12) : Color.clear)
                        }
                        .buttonStyle(.plain)
                        Divider().background(Color.white.opacity(0.15)).padding(.leading, 12)
                    }
                }
            }

            Text("Yahoo! Finance")
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .padding(.vertical, 8)
        }
        .background(Color.black)
        .onReceive(timer) { _ in
            for i in stocks.indices {
                let drift = Double.random(in: -0.004...0.004)
                stocks[i].price = max(0.01, stocks[i].price * (1 + drift))
            }
        }
    }

    private func chartValues() -> [Double] {
        let s = stocks[selected]
        var h: UInt64 = 146959
        for c in (s.symbol + "\(range)").utf8 { h = (h ^ UInt64(c)) &* 1099511628211 }
        var x = h | 1
        var v = 0.5
        var pts: [Double] = []
        let count = [48, 42, 40, 38, 36, 34, 32][range]
        for _ in 0..<count {
            x = x &* 6364136222853695 &+ 1442695040888963407
            let r = Double(x >> 33) / Double(1 << 31)
            v += (r - 0.5) * 0.14
            v = min(0.95, max(0.05, v))
            pts.append(v)
        }
        return pts
    }

    private func chartPath(in size: CGSize) -> Path {
        let pts = chartValues()
        var path = Path()
        guard pts.count > 1 else { return path }
        let stepX = size.width / CGFloat(pts.count - 1)
        for (i, v) in pts.enumerated() {
            let p = CGPoint(x: CGFloat(i) * stepX, y: size.height - CGFloat(v) * size.height)
            if i == 0 { path.move(to: p) } else { path.addLine(to: p) }
        }
        return path
    }
}
