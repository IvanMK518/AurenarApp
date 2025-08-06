//
//  Aurenar_SwiftApp.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/10/25.
//

import SwiftUI

@main
struct Aurenar_SwiftApp: App {
    
@StateObject private var bt = bluetoothService()
@StateObject private var therapyCounter = TherapyCounter()

    
    var body: some Scene {
        WindowGroup {
            loadScreenView()
                .environmentObject(therapyCounter)
        }
    }
}

struct MainView: View {
    
    
    init() {
        let font = UIFont(name: "Conthrax-Semibold", size: 10)
        UITabBarItem.appearance().setTitleTextAttributes([.font: font!], for: .normal)
    }
    
    var body: some View {
        ZStack {
            TabView {
                HomeView()
                    .tabItem {
                        Image(systemName: "ear.badge.waveform")
                        Text("V-Link")
                    }
                
                CalendarView()
                    .tabItem {
                        Image(systemName: "calendar.and.person")
                        Text("Daily Activity")
                    }
                
                AccountView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Account")
                    }
            }
            .tint(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).opacity(1.0)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(TherapyCounter())
    }
}
