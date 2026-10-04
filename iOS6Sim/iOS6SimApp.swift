import SwiftUI

@main
struct iOS6SimApp: App {
    @StateObject private var sim = SimulatorState()

    var body: some Scene {
        WindowGroup {
            FullscreenSimView()
                .environmentObject(sim)
        }
    }
}
