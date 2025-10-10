import SwiftUI

struct Profile : View {
    
    var body: some View {
        
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 200, height: 200)
                .padding()

            Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10) {
                
                GridRow {
                    Text("Name:")
                    Text("Eric Yuhki Sato")
                        .foregroundStyle(.blue)
                }
                
                GridRow {
                    Text("Age:")
                    Text("23")
                        .foregroundStyle(.blue)
                }
                
                GridRow {
                    Text("Address:")
                    Text("Rua do Segredo, 1146")
                        .foregroundStyle(.blue)
                }
                
                GridRow {
                    Text("Phone:")
                    Text("43 99887-7665")
                        .foregroundStyle(.blue)
                }
            }
            .font(.system(size: 25))
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    Profile()
}
