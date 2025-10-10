import SwiftUI

// MARK: - Enums e Structs

enum DiaSemana: Int, CustomStringConvertible, Codable, CaseIterable, Identifiable {
    case segunda = 0, terca, quarta, quinta, sexta, sabado, domingo
    
    var id: Int { self.rawValue }
    
    var description: String {
        switch self {
        case .segunda:
            return "Segunda"
        case .terca:
            return "Terça"
        case .quarta:
            return "Quarta"
        case .quinta:
            return "Quinta"
        case .sexta:
            return "Sexta"
        case .sabado:
            return "Sábado"
        case .domingo:
            return "Domingo"
        }
    }
}

struct Remedio: Codable, Identifiable {
    var _id: String
    var _rev: String?
    let nome: String
    let descricao: String
    var qtd: Int
    let dias: [DiaSemana]
    let horario: Date
    
    var id: String { _id }
    
    enum CodingKeys: String, CodingKey {
        case _id, _rev, nome, descricao, qtd, dias, horario
    }
}

// MARK: - StorageView

struct StorageView: View {
    
    @StateObject private var apiDelete = apiDELETE()
    @StateObject private var apiGet = apiGET()
    @StateObject private var apiPut = apiPUT()
    @State var count = 0
    @State var contador: Int = 0
    
    @State private var mostrandoSheet = false
    
    func deletarRemedio(remedio: Remedio) {
        
        guard let rev = remedio._rev else {
            print("Erro: Tentando deletar um item local sem _rev.")
            apiGet.remedios.removeAll { $0.id == remedio.id }
            return
        }
        
        apiDelete.delete(remedio)
    }
    
    var body: some View {
        
        ZStack{
            NavigationView {
                VStack(alignment: .leading){
                    VStack{
                        List{
                            ForEach($apiGet.remedios) { $remedio in
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(remedio.nome)
                                            .font(.headline)
                                        
                                        Group {
                                            Text(remedio.dias.map { $0.description }.joined(separator: ", "))
                                            Text(remedio.horario, style: .time)
                                        }
                                        .font(.caption)
                                        .foregroundColor(.orange)
                                        
                                        Text(remedio.descricao)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Image(systemName: "minus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(remedio.qtd > 0 ? .red : .gray)
                                        .onTapGesture {
                                            if remedio.qtd > 0 {
                                                remedio.qtd -= 1
                                                apiPut.put(remedio)
                                            }
                                        }
                                    
                                    Text("\(remedio.qtd)")
                                        .font(.subheadline)
                                        .frame(width: 40)
                                        .multilineTextAlignment(.center)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.green)
                                        .onTapGesture {
                                            remedio.qtd += 1
                                            apiPut.put(remedio)
                                        }
                                    
                                    Spacer()
                                    Button(action: {
                                        deletarRemedio(remedio: remedio)
                                        apiGet.fetch()
                                    }) {
                                        Image(systemName: "trash")
                                            .foregroundColor(.red)
                                            .font(.title2)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 5)
                            }
                            .onChange(of: contador) {
                                apiGet.fetch()
                            }
                        }
                        .navigationTitle("MedBox Storage")
                    }
                    .padding()
                    Spacer()
                }
            }
            .zIndex(0)
            
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        mostrandoSheet.toggle()
                        contador = apiGet.remedios.count
                        print(contador)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                            .padding()
                    }
                }
                .sheet(isPresented: $mostrandoSheet) {
                    CadastroRemedioView(mostrandoSheet: $mostrandoSheet, contador: $contador) { novoRemedio in
                        apiGet.remedios.append(novoRemedio)
                    }
                }
            }.zIndex(1)
        }
        .onAppear {
            apiGet.fetch()
        }
    }
}

// MARK: - CadastroRemedioView com Seletores

struct CadastroRemedioView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var nome = ""
    @State private var descricao = ""
    @State private var qtd = 0
    @State private var diasSelecionados: Set<DiaSemana> = []
    @State private var horarioSelecionado = Date()
    @Binding var mostrandoSheet: Bool
    @Binding var contador: Int
    
    var onSalvar: (Remedio) -> Void
    @StateObject var POSTapi = apiPOST()
    @StateObject private var apiGet = apiGET()
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informações Básicas")) {
                    TextField("Nome do remédio", text: $nome)
                    TextField("Descrição", text: $descricao)
                    Stepper("Quantidade: \(qtd)", value: $qtd, in: 0...100)
                }
                
                Section(header: Text("Horário e Frequência")) {
                    DatePicker("Horário", selection: $horarioSelecionado, displayedComponents: .hourAndMinute)
                    
                    VStack(alignment: .leading) {
                        Text("Dias da Semana")
                            .font(.subheadline)
                            .padding(.bottom, 2)
                        
                        ForEach(DiaSemana.allCases) { dia in
                            Toggle(dia.description, isOn: Binding(
                                get: { self.diasSelecionados.contains(dia) },
                                set: { isSelected in
                                    if isSelected {
                                        self.diasSelecionados.insert(dia)
                                    } else {
                                        self.diasSelecionados.remove(dia)
                                    }
                                }
                            ))
                            .tint(.blue)
                        }
                    }
                }
            }
            .navigationTitle("Novo Remédio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Salvar") {
                        let novo = Remedio(
                            _id: UUID().uuidString,
                            _rev: nil,
                            nome: nome,
                            descricao: descricao,
                            qtd: qtd,
                            dias: diasSelecionados.sorted(by: { $0.rawValue < $1.rawValue }),
                            horario: horarioSelecionado
                        )
                        POSTapi.post(novo)
                        mostrandoSheet.toggle()
                        contador += 1
                    }
                    .disabled(nome.isEmpty || diasSelecionados.isEmpty)
                }
            }
        }
    }
}

#Preview {
    StorageView()
}
