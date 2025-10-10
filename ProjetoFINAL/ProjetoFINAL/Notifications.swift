//
//  Notifications.swift
//  ProjetoFINAL
//
//  Created by Turma02-15 on 02/10/25.
//

import Foundation
import SwiftUI

struct Notifications : View {
    
    @State private var isTaken = false
    @State private var notTaken = false
    @State private var notificationStock = false
    
    var body: some View {
        
        NavigationStack {
            
            List {
                
                HStack {
                    Image(systemName: "bell")
                    Toggle("Taken medicine notifications: ", isOn: $isTaken)
                }
                
                HStack {
                    Image(systemName: "bell.fill")
                    Toggle("Not taken notifications: ", isOn: $notTaken)
                }
                
                HStack {
                    Image(systemName: "tray")
                    Toggle("Stock notifications: ", isOn: $notificationStock)
                }
            
            }
            .navigationTitle("Notifications")
        }
        
    }
}

#Preview {
    Notifications()
}
