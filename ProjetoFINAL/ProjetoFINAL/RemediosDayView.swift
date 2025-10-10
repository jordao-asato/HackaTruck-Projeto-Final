import SwiftUI

struct RemediosDayView: View {
    
    @Binding var mostrandoSheet: Bool
    @Binding var date: Date?
    
    @StateObject private var apiGet = apiGET()
    
    private func diaSemana(from date: Date) -> DiaSemana {
        let weekday = Calendar.current.component(.weekday, from: date)
        switch weekday {
        case 2: return .segunda
        case 3: return .terca
        case 4: return .quarta
        case 5: return .quinta
        case 6: return .sexta
        case 7: return .sabado
        case 1: return .domingo
        default: return .segunda
        }
    }
    
    private var remediosDoDia: [Remedio] {
        guard let date = date else { return [] }
        let dia = diaSemana(from: date)
        return apiGet.remedios.filter { $0.dias.contains(dia) }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Remédios do Dia")
                .font(.title2)
            
            if remediosDoDia.isEmpty {
                Text("Nenhum remédio para este dia.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(remediosDoDia) { remedio in
                    VStack(alignment: .leading) {
                        Text(remedio.nome)
                            .font(.headline)
                        Text(remedio.descricao)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(remedio.horario, style: .time)
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .padding(.vertical, 5)
                }
            }
            
            Button("Fechar Sheet") {
                mostrandoSheet = false
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .onAppear {
            apiGet.fetch()
        }
    }
}

#Preview {
    RemediosDayView(mostrandoSheet: .constant(true), date: .constant(Date()))
}
