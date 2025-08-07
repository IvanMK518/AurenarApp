//
//  levelCheckView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 7/21/25.
//

import Foundation
import SwiftUI

struct lvlLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let midY = rect.height / 2
        let start = CGPoint(x: 0, y: midY)
        let end = CGPoint(x: rect.width, y: midY)
        
        path.move(to: start)
        path.addLine(to: end)
        
        return path
    }
}

struct levelCheckView: View {
    var lvl: CGFloat
    var imageName: String
    var color: Color
    

    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                lvlLine()
                    .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                
                lvlLine()
                    .trim(from: 0, to: min(max(lvl / 100.0, 0), 1))
                    .stroke((lvl <= 15 ? .red : (lvl <= 25 ? .yellow : color)).opacity(lvl == 0 ? 0.0 : 0.7), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                    .animation(.easeInOut(duration: 1.0), value: lvl)
                
                Image(systemName: imageName)
                    .opacity(0.7)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct LevelCheckView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            levelCheckView(lvl: 15, imageName: "bolt.fill", color: Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
        }
    }
}
