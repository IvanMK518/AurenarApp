//
//  impLevelCheckView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 8/7/25.
//


import Foundation
import SwiftUI

struct impLevelCheckView: View {
    var lvl: CGFloat
    var imageName: String
    @State private var color: Color = Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)
    
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
                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 18, lineCap: .round))
                
                Path { path in
                    let midY = geo.size.height / 2
                    let width = geo.size.width * min(max(lvl / 100.0, 0), 1)
                    let start = CGPoint(x: 0, y: midY)
                    let end = CGPoint(x: width, y: midY)
                    path.move(to: start)
                    path.addLine(to: end)
                }
                .stroke(Color(lvl <= 5 || lvl >= 95 ? .red : lvl <= 15 || lvl >= 85 ? .yellow: color).opacity(lvl == 0 ? 0.0 : 0.7), style: StrokeStyle(lineWidth: 14, lineCap: .round))
                .animation(.easeInOut(duration: 1.0), value: lvl)
                
                Image(systemName: imageName)
                    .opacity(0.7)
                    .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

struct impLevelCheckView_Previews: PreviewProvider {
    static var previews: some View {
            impLevelCheckView(lvl: 85, imageName: "bolt.fill")
    }
}
