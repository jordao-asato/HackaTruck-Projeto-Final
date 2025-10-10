import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            WeekSliderView()
            Spacer()
        }
    }
}

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let time: String
    let color: Color
    let icon: String
}

enum StatusRemedio {
    case aSerTomado
    case tomado
    case esquecido
}

struct WeekSliderView: View {
    @State private var selectedDate = Date()
    @State private var weekOffset: Int = 0
    
    @StateObject private var apiGet = apiGET()
    
    let sampleEvents: [Date: [Event]] = [
        Date(): [
            Event(title: "Team Meeting", time: "9:00 AM", color: .blue, icon: "person.3.fill"),
            Event(title: "Lunch Break", time: "12:30 PM", color: .orange, icon: "fork.knife"),
            Event(title: "Gym Session", time: "6:00 PM", color: .green, icon: "figure.run")
        ]
    ]
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                
                VStack(spacing: 2) {
                    Text(monthYearString(from: getWeekDates(offset: weekOffset).first ?? Date()))
                        .font(.headline)
                        .fontWeight(.bold)
                    
                }
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.top, 8)
            
            HStack(spacing: 8) {
                ForEach(getWeekDayLabels(), id: \.self) { day in
                    Text(day)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .fontWeight(.medium)
                        .frame(width: 44)
                }
            }
            .padding(.horizontal, 8)
            
            TabView(selection: $weekOffset) {
                ForEach(-52...52, id: \.self) { offset in
                    WeekView(
                        weekDates: getWeekDates(offset: offset),
                        selectedDate: $selectedDate
                    )
                    .tag(offset)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 60)
            
            if weekOffset != 0 {
                Button(action: {
                    goToToday()
                }) {
                    Text("Today")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color.blue)
                        .cornerRadius(15)
                }
                .transition(.scale.combined(with: .opacity))
                .padding(.top, 4)
            }
            
            EventsListView(selectedDate: selectedDate, events: getEvents(for: selectedDate))
                .padding(.top, 8)
        }
        .padding(.bottom, 8)
        
        .onAppear {
            apiGet.fetch()
        }
    }
    
    func determinarStatus(do remedio: Remedio, for date: Date) -> StatusRemedio {
        let calendar = Calendar.current
        let agora = Date()
        
        let timeComponents = calendar.dateComponents([.hour, .minute], from: remedio.horario)
        
        guard let horarioNodia = calendar.date(bySettingHour: timeComponents.hour ?? 0,
                                               minute: timeComponents.minute ?? 0,
                                               second: 0,
                                               of: date) else {
            return .aSerTomado
        }
        
        let foiTomado = false
        
        if foiTomado {
            return .tomado
        }
        
        if horarioNodia < agora {
            return .esquecido
        } else {
            return .aSerTomado
        }
    }
    
    func getEventsForDate(_ date: Date) -> [Event] {
        let calendar = Calendar.current
        for (eventDate, events) in sampleEvents {
            if calendar.isDate(eventDate, inSameDayAs: date) {
                return events
            }
        }
        return []
    }
    
    func getEvents(for date: Date) -> [Event] {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        let diaSemanaFromDate: DiaSemana? = {
            switch weekday {
            case 1: return .domingo
            case 2: return .segunda
            case 3: return .terca
            case 4: return .quarta
            case 5: return .quinta
            case 6: return .sexta
            case 7: return .sabado
            default: return nil
            }
        }()
        
        guard let diaSemana = diaSemanaFromDate else { return [] }
        
        let remediosDoDia = apiGet.remedios.filter { remedio in
            remedio.dias.contains(diaSemana)
        }
        
        let remediosOrdenados = remediosDoDia.sorted { $0.horario < $1.horario }
        
        let events = remediosOrdenados.map { remedio -> Event in
            let status = determinarStatus(do: remedio, for: date)
            
            var cor: Color
            var icone: String
            
            switch status {
            case .tomado:
                cor = .green
                icone = "checkmark.circle.fill"
            case .aSerTomado:
                cor = .blue
                icone = "clock.fill"
            case .esquecido:
                cor = .red
                icone = "xmark.circle.fill"
            }
            
            return Event(
                title: remedio.nome,
                time: remedio.horario.formatted(date: .omitted, time: .shortened),
                color: cor,
                icon: icone
            )
        }
        
        return events
    }
    
    func getWeekDayLabels() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today)!
        
        return (0..<7).compactMap { day in
            if let date = calendar.date(byAdding: .day, value: day, to: startOfWeek) {
                return formatter.string(from: date)
            }
            return nil
        }
    }
    
    func goToToday() {
        withAnimation {
            weekOffset = 0
            selectedDate = Date()
        }
    }
    
    func getWeekDates(offset: Int) -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let startOfCurrentWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today)!
        let startOfTargetWeek = calendar.date(byAdding: .weekOfYear, value: offset, to: startOfCurrentWeek)!
        
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startOfTargetWeek)
        }
    }
    
    func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct EventsListView: View {
    let selectedDate: Date
    let events: [Event]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(selectedDate.formatted(date: .abbreviated, time: .omitted))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                
            }
            .padding(.horizontal, 16)
            
            if events.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "calendar.badge.exclamationmark")
                        .font(.system(size: 32))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No events scheduled")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.05))
                )
                .padding(.horizontal, 16)
            } else {
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(events) { event in
                            EventCard(event: event)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
    }
}

struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(event.color.opacity(0.15))
                    .frame(width: 44, height: 44)
                
                Image(systemName: event.icon)
                    .font(.system(size: 18))
                    .foregroundColor(event.color)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(event.time)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            if event.color == .red {
                Image(systemName: "bell.fill")
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.8))
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        )
    }
}

struct WeekView: View {
    let weekDates: [Date]
    @Binding var selectedDate: Date
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(weekDates, id: \.self) { date in
                DayCell(
                    date: date,
                    isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                    isToday: Calendar.current.isDateInToday(date)
                )
                .onTapGesture {
                    withAnimation(.spring(response: 0.3)) {
                        selectedDate = date
                    }
                }
            }
        }
        .padding(.horizontal, 8)
    }
}

struct DayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    
    var body: some View {
        Text(dayNumber)
            .font(.system(size: 16, weight: isSelected ? .bold : .medium))
            .foregroundColor(isSelected ? .white : .primary)
            .frame(width: 44, height: 44)
            .background(
                Circle()
                    .fill(backgroundColor)
            )
            .overlay(
                Circle()
                    .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
            )
            .scaleEffect(isSelected ? 1.05 : 1.0)
            .animation(.spring(response: 0.3), value: isSelected)
    }
    
    var backgroundColor: Color {
        if isSelected {
            return .blue
        }
        return Color.gray.opacity(0.1)
    }
    
    var dayNumber: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}

#Preview {
    ContentView()
}
