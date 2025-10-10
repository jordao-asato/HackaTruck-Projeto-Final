//
//  Audio.swift
//  ProjetoFINAL
//
//  Created by Turma02-15 on 02/10/25.
//

import Foundation
import SwiftUI

struct Audio : View {
    
    @State private var volume = 0.5
    @State private var isMuted: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            Form{
                
                Section(header: Text("Volume principal: ")) {
                    Text("Volume: \(Int(volume * 100))%")
                    
                    HStack {
                        Image(systemName: "speaker.wave.3.fill")
                        
                        Slider(value: $volume) {
                            Text("Volume control")
                        }
                    }
                    
                    Section(header: Text("General options")) {
                        Toggle("Silent mode", isOn: $isMuted)
                    }
                    
                    HStack {
                        Text("Ringtone:")
                        Text("Lady Gaga - JUDAS")
                            .foregroundStyle(.blue)
                    }
                }
                .navigationTitle("Audio")
            }
            
        }
        .navigationTitle("Audio")
    }
}

#Preview {
    Audio()
}
