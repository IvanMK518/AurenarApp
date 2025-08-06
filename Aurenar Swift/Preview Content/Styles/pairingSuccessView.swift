//
//  pairingSuccessView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 7/2/25.
//

/*
 
 */

import SwiftUI
import Foundation

struct pairingSuccessView: View {
    @ObservedObject var bt: bluetoothService
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            TimerView(bt: bt)
        } else{
            VStack{
                VStack{
                    Image(systemName: "link.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .glow()
                    Text("Pairing Successful")
                        .frame(maxWidth:.infinity, alignment: .center)
                        .padding(30)
                        .font(.custom("ClashGrotesk-Medium", size: 28))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).glow()
                    
                        
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct pairingSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        pairingSuccessView(bt: bluetoothService())
    }
}
