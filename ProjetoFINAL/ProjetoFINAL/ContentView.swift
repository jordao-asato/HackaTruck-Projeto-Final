//
//  ContentView.swift
//  ProjetoFINAL
//
// Sistema de lembrete de remédios com arduino
//
//  Created by Turma02-8 on 01/10/25.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        TabView{
            HomeView()
                .tabItem {
                    Label("Home",systemImage: "house.fill")
                }
            
            BasicCalendarView()
                .tabItem {
                    Label("Calendário", systemImage: "calendar")
                }
            StorageView()
                .tabItem {
                    Label("Estoque",systemImage:"square.stack.fill")
                }
            SettingView()
                .tabItem {
                    Label("Config", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}

