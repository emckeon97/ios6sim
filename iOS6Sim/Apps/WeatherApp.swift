import SwiftUI

struct DayForecast: Identifiable {
    let id = UUID()
    let day: String
    let high: Int
    let low: Int
    let icon: String
}

/// iOS 6 Weather: blue linen, big temp, 5-day strip. Demo data.
struct WeatherApp: View {
    @State private var cityIndex = 0

    private let cities = ["Charlotte", "New York", "San Francisco", "Miami"]
    private let temps = [72, 58, 64, 84]
    private let conditions = ["Partly Cloudy", "Rain", "Sunny", "Sunny"]
    private let icons = ["cloud.sun.fill", "cloud.rain.fill", "sun.max.fill", "sun.max.fill"]

    private let week = [
        DayForecast(day: "Mon", high: 74, low: 58, icon: "cloud.sun.fill"),
        DayForecast(day: "Tue", high: 77, low: 60, icon: "sun.max.fill"),
        DayForecast(day: "Wed", high: 71, low: 57, icon: "cloud.rain.fill"),
        DayForecast(day: "Thu", high: 69, low: 55, icon: "cloud.fill"),
        DayForecast(day: "Fri", high: 75, low: 59, icon: "sun.max.fill"),
    ]

    var body: some View {
        VStack(spacing: 0) {
            iOS6StatusBar()
            iOS6NavBar(title: "Weather")
            ZStack {
                // Blue linen.
                Color(red: 0.16, green: 0.28, blue: 0.48)
                    .ignoresSafeArea()
                VStack(spacing: 6) {
                    // City pager.
                    TabView(selection: $cityIndex) {
                        ForEach(0..<cities.count, id: \.self) { i in
                            VStack(spacing: 4) {
                                Text(cities[i])
                                    .font(.system(size: 26, weight: .light))
                                    .foregroundColor(.white)
                                Text("\(temps[i])°")
                                    .font(.system(size: 92, weight: .ultraLight))
                                    .foregroundColor(.white)
                                Text(conditions[i])
                                    .font(.system(size: 17))
                                    .foregroundColor(.white.opacity(0.9))
                                Image(systemName: icons[i])
                                    .font(.system(size: 54))
                                    .foregroundColor(.white)
                                    .padding(.top, 8)
                                HStack(spacing: 24) {
                                    Label("H:\(temps[i] + 3)°", systemImage: "arrow.up")
                                    Label("L:\(temps[i] - 9)°", systemImage: "arrow.down")
                                }
                                .font(.system(size: 15))
                                .foregroundColor(.white.opacity(0.85))
                                .padding(.top, 6)
                            }
                            .tag(i)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(height: 330)

                    // Page dots.
                    HStack(spacing: 6) {
                        ForEach(0..<cities.count, id: \.self) { i in
                            Circle()
                                .fill(i == cityIndex ? Color.white : Color.white.opacity(0.4))
                                .frame(width: 6, height: 6)
                        }
                    }

                    // 5-day strip.
                    HStack {
                        ForEach(week) { d in
                            VStack(spacing: 4) {
                                Text(d.day)
                                    .font(.system(size: 12, weight: .semibold))
                                Image(systemName: d.icon)
                                    .font(.system(size: 20))
                                Text("\(d.high)°")
                                    .font(.system(size: 14, weight: .bold))
                                Text("\(d.low)°")
                                    .font(.system(size: 13))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.vertical, 12)
                    .background(Color.black.opacity(0.25))
                    .cornerRadius(8)
                    .padding(.horizontal, 12)

                    Spacer()
                    Text("Demo data")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.bottom, 8)
                }
            }
        }
    }
}
