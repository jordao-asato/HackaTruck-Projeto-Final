import SwiftUI

struct BasicCalendarView: View {
    @State private var mostrarSheet = false
    @State private var displayDate: Date = Date()
    @State private var selectedDate: Date? = nil
    @State private var sla = false

    private let calendar = Calendar.current
    private let weekDaySymbols = Calendar.current.shortStandaloneWeekdaySymbols

    var body: some View {
        VStack(spacing: 12) {
            
            header
            Spacer().frame(height: 30)
            
            weekdayHeader
            calendarGrid
            Spacer()
        }
        .padding()
        
        .sheet(isPresented: $mostrarSheet) {
            
            RemediosDayView(mostrandoSheet: $mostrarSheet,date: $selectedDate)
        }
    }
    
    

    // MARK: - Header (Month / navigation)
    private var header: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .padding(8)
            }

            Spacer()

            Text(monthYearString(for: displayDate))
                .font(.headline)

            Spacer()

            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.title2)
                    .padding(8)
            }
        }
        .padding(.horizontal)
    }

    private var weekdayHeader: some View {
        let symbols = weekDaySymbols
        return HStack(spacing: 0) {
            ForEach(0..<7) { idx in
                Text(symbols[(idx + calendar.firstWeekday - 1) % 7])
                    .frame(maxWidth: .infinity)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 8)
    }

    // MARK: - Calendar grid
    private var calendarGrid: some View {
        let days = makeDays()
        let columns = Array(repeating: GridItem(.flexible()), count: 7)

        return LazyVGrid(columns: columns, spacing: 10) {
            ForEach(days.indices, id: \ .self) { idx in
                if let day = days[idx] {
                    dayCell(for: day)
                } else {
                    // Empty cell for leading/trailing blanks
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(height: 40)
                }
            }
        }
        .padding(.horizontal, 4)
    }

    private func dayCell(for day: Date) -> some View {
        let dayNumber = calendar.component(.day, from: day)
        let isSelected = selectedDate != nil && calendar.isDate(selectedDate!, inSameDayAs: day)
        let isToday = calendar.isDateInToday(day)

        return Button(action: { selectedDate = day }) {
            Text("\(dayNumber)")
                .frame(maxWidth: .infinity, minHeight: 40)
                .background(
                    ZStack {
                        if isSelected {
                            Circle()
                                .fill(Color.accentColor.opacity(0.2))
                                .padding(4)
                                .onTapGesture {
                                    mostrarSheet = true
                                }
                        }
                        if isToday {
                            Circle()
                                .stroke(Color.accentColor, lineWidth: 1)
                                .padding(6)
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Helpers
    private func changeMonth(by value: Int) {
        if let newDate = calendar.date(byAdding: .month, value: value, to: displayDate) {
            displayDate = newDate
        }
    }

    private func monthYearString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: date).capitalized
    }

    private func makeDays() -> [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: displayDate),
              let firstDayOfMonth = monthInterval.start as Date?
        else { return [] }

        let range = calendar.range(of: .day, in: .month, for: displayDate)!
        let numberOfDays = range.count

        // weekday index (1 = Sunday in Calendar); convert to 0-based index respecting calendar.firstWeekday
        let firstWeekdayOfMonth = calendar.component(.weekday, from: firstDayOfMonth)
        // compute number of leading blanks
        let leadingBlanks = (firstWeekdayOfMonth - calendar.firstWeekday + 7) % 7

        var days: [Date?] = []
        // add leading blanks
        days.append(contentsOf: Array(repeating: nil, count: leadingBlanks))

        // add real day Date objects
        for day in 1...numberOfDays {
            var comps = calendar.dateComponents([.year, .month], from: displayDate)
            comps.day = day
            if let date = calendar.date(from: comps) {
                days.append(date)
            }
        }

        // pad to full weeks
        while days.count % 7 != 0 {
            days.append(nil)
        }

        return days
    }
}

 

// MARK: - Preview
struct BasicCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        BasicCalendarView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}



// --- Uso
// Basta colocar `BasicCalendarView()` onde você quiser na sua hierarquia SwiftUI.
// Você pode customizar cores, fonte e o comportamento de seleção conforme necessário.
// Exemplos de melhorias possíveis:
// - mostrar eventos por dia (array de eventos por Date)
// - permitir seleção de intervalo (start/end)
// - habilitar toques longos para ações rápidas
// - internacionalização para primeiros dias da semana distintos
