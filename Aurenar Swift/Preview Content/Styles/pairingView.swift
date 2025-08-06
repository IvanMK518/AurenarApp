//
//  pairingView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 7/3/25.
//

/*
 Supplemmentary view for homescreen that renders pairing btn, leds and alerts.
 */

import Foundation
import SwiftUI

struct pairingView: View {
    @ObservedObject var bt: bluetoothService
    @State private var isRunning = false
    @State private var isPairing = false
    @State private var time = 0
    @State private var showAlert = false
    
    var body: some View {
        ZStack {
            if isPairing {
                pulsingView()
            } else {
                ringView()
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).opacity(0.20)
            }
            
            Button(action: {
                isPairing = true
                showAlert = true
            }) {
                ZStack{
                    Image("bt")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 40, height:40)
                        .foregroundColor(Color(.label)).opacity(0.6)
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Color(.systemBackground).opacity(0.3))
                        .cornerRadius(100)
                        .shadow(color: .gray, radius: 1, x: 0, y: 2)
                     
                }
            }
            
            .padding(.horizontal)
        }
        
        .onChange(of: bt.peripheralStatus) {
            if bt.peripheralStatus == .disconnected {
                isPairing = false
                
            } else if bt.peripheralStatus == .connected {
                isPairing = false
                
            }
        }
        
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Pair Mode"),
                        message: Text("This is a pair mode message."),
                        primaryButton: .default(Text("Confirm")) {
                            bt.scan()
                        },
                        secondaryButton: .cancel(Text("Cancel")) {
                                isPairing = false
                        }
                    )
                }
    }
}

struct pairingView_Previews: PreviewProvider {
    static var previews: some View {
        pairingView(bt: bluetoothService())
    }
}

    


