import SwiftUI

/// Photos: grid of the procedural wallpapers.
struct PhotosApp: View {
    @State private var selected: Int?
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 3)

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                iOS6StatusBar()
                iOS6NavBar(title: "Photos")
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(0..<Wallpapers.names.count, id: \.self) { i in
                            Button {
                                selected = i
                            } label: {
                                Wallpapers.view(index: i)
                                    .frame(height: 110)
                                    .clipped()
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .background(Color.black)
            }

            if let i = selected {
                ZStack(alignment: .topTrailing) {
                    Color.black.ignoresSafeArea()
                    Wallpapers.view(index: i)
                        .ignoresSafeArea()
                    Button {
                        selected = nil
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .padding(.top, 28)
                    .padding(.trailing, 12)
                    VStack {
                        Spacer()
                        Text(Wallpapers.names[i])
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.85))
                            .padding(.bottom, 16)
                    }
                }
                .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: selected)
    }
}
