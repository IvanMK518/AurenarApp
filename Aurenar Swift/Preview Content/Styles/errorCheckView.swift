//
//  errorCheckView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/25/25.
//

//
//  pairingSuccessView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 7/2/25.
//

/*
 Animation rendered if user has successfully paired device and connected.
 */

import SwiftUI
import Foundation

struct errorCheckView: View {
    @ObservedObject var bt: bluetoothService
    var imageName: String
    var color: Color
    var msg: String
    var msg2: String
    var duration: Double = 2.0
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            TimerView(bt: bt)
        } else{
            VStack{
                VStack{
                    Image(systemName: imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .foregroundColor(color)
                        .glow()
                    Text(msg)
                        .frame(maxWidth:.infinity, alignment: .center)
                        .padding(30)
                        .font(.custom("ClashGrotesk-Medium", size: 28))
                        .foregroundColor(color).glow()
                    Text(msg2)
                        .frame(maxWidth:.infinity, alignment: .center)
                        .padding(30)
                        .font(.custom("ClashGrotesk-Medium", size: 28))
                        .foregroundColor(color)
                    
                        
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
                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct errorCheckView_Previews: PreviewProvider {
    static var previews: some View {
        errorCheckView(bt: bluetoothService(),imageName: "ear.trianglebadge.exclamationmark",color: .yellow, msg: "test", msg2: "", duration: 2.0)
    }
}
