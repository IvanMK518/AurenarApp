//
//  loadScreenView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/24/25.
//

/*
 Load Screen animation during app launch.
 */

import SwiftUI
import Foundation

struct loadScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainView()
        } else{
            VStack{
                VStack{
                    Image("Logo_shadow")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .clipped()
                        .font(.system(size: 80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.5
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

struct loadScreenView_Previews: PreviewProvider {
    static var previews: some View {
        loadScreenView()
    }
}
