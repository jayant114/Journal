import SwiftUI

struct ContentView: View {
    @State private var journalEntries: [JournalEntry] = []
    @State private var newEntryText: String = ""
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header with today's prompt
                VStack(spacing: 16) {
                    Text("What did you do today?")
                        .font(.title2)
                        .fontWeight(.medium)
                    
                    Text(Date().formatted(.custom("EEEE, dd MMMM, YYYY")))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    // Input box that transforms based on scroll
                    TextEditor(text: $newEntryText)
                        .frame(height: 100)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .strokeBorder(
                                    style: StrokeStyle(
                                        lineWidth: 1,
                                        dash: scrollOffset > 50 ? [5] : []
                                    )
                                )
                                .foregroundColor(.gray.opacity(0.3))
                        )
                }
                .padding(.top, 40)
                .opacity(max(1 - (scrollOffset / 100), 0.3))
                
                // Previous entries
                ForEach(getPastWeekDates(), id: \.self) { date in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(date.formatted(.custom("EEEE, dd MMMM, YYYY")))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemBackground))
                            .frame(height: 120)
                            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                    .padding(.horizontal)
                }
            }
            .padding()
            .background(GeometryReader { proxy in
                Color.clear.preference(
                    key: ScrollOffsetPreferenceKey.self,
                    value: proxy.frame(in: .named("scroll")).minY
                )
            })
        }
        .coordinateSpace(name: "scroll")
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = -value
        }
    }
    
    private func getPastWeekDates() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: -dayOffset, to: today)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

extension FormatStyle where Self == Date.FormatStyle {
    static func custom(_ format: String) -> Date.FormatStyle {
        Date.FormatStyle()
            .day(.twoDigits)
            .month(.wide)
            .year()
            .weekday(.wide)
    }
}

#Preview {
    ContentView()
} 