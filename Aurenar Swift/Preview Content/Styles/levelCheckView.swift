//
//  levelCheckView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 7/21/25.
//

import Foundation
import SwiftUI

struct levelCheckView: View {
    var lvl: CGFloat
    var imageName: String
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Path { path in
                    let midY = geo.size.height / 2
                    let start = CGPoint(x: 0, y: midY)
                    let end = CGPoint(x: geo.size.width, y: midY)
                    path.move(to: start)
                    path.addLine(to: end)
                }
                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                
                Path { path in
                    let midY = geo.size.height / 2
                    let width = geo.size.width * min(max(lvl / 100.0, 0), 1)
                    let start = CGPoint(x: 0, y: midY)
                    let end = CGPoint(x: width, y: midY)
                    path.move(to: start)
                    path.addLine(to: end)
                }
                .stroke(Color.accentColor.opacity(0.7), style: StrokeStyle(lineWidth: 12, lineCap: .round))
                .animation(.easeInOut(duration: 0.5), value: lvl)
                
                Image(systemName: imageName)
                    .opacity(0.7)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct LevelCheckView_Previews: PreviewProvider {
    static var previews: some View {
            levelCheckView(lvl: 30, imageName: "bolt.fill")
    }
}
