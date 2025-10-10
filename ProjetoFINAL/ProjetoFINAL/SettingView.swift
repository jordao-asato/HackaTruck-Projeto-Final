//
//  SettingView.swift
//  ProjetoFINAL
//
//  Created by Turma02-8 on 01/10/25.
//

import SwiftUI

struct SettingView: View {
   
    @State private var isDarkModeEnabled = false
    
    var body: some View {

        NavigationStack {
            
            List {
        
                HStack {
                    NavigationLink(destination: Profile()) {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                        Spacer()
                    }
                }
                    
                HStack {
                    NavigationLink(destination: Notifications()) {
                        Image(systemName:"bell.fill")
                        Text("Notifications")
                        Spacer()
                    }
                }
                    
                    HStack {
                        Image(systemName: isDarkModeEnabled ? "moon.fill" : "sun.max.fill")
                        
                        Toggle("Dark Mode", isOn: $isDarkModeEnabled)
                    }
                    
                    HStack {
                        NavigationLink(destination: Audio()) {
                            Image(systemName: "megaphone.fill")
                            Text("Audio")
                        }
                    }
                    
                .navigationTitle("Settings")}
        }
        .preferredColorScheme(isDarkModeEnabled ? .dark : .light)
    }
}

#Preview {
    SettingView()
}
