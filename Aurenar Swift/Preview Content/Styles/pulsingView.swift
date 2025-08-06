//
//  pulsingView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/24/25.
//

/*
 Supplementary glowing animation for all led mimicking animations.
 */

import Foundation
import SwiftUI

struct pulsingView: View {

    
    var body: some View{
        ZStack {
            VStack(spacing: 20){
                ringView()
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                    .glow()
            }
            
        }
        
    }
}

struct Glow: ViewModifier {
    @State private var pulse = false
    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: pulse ? 6 : 2)
                .opacity(pulse ? 0.2: 1.0)
                .animation (.easeOut(duration: 0.55).repeatForever(autoreverses: true), value: pulse)
                .onAppear{
                    pulse.toggle()
                }
        }
    }
}

extension View {
    func glow() -> some View {
        modifier(Glow())
    }
}

struct pulsingView_Previews: PreviewProvider {
    static var previews: some View {
        pulsingView()
    }
}
