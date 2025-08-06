//
//  ringView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/27/25.
//

/*
 V-link led layout rendering.
 */

import Foundation
import SwiftUI
import WebKit
import UIKit

struct Segment1: Shape {
    func path (in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
                      path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.height / 2, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 270), clockwise: true)
        }
    }
}

struct Segment2: Shape {
    func path (in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
                      path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.height / 2 , startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
        }
    }
}

struct Segment3: Shape {
    func path (in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.midY))
                      path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.height / 2, startAngle: Angle(degrees: -180), endAngle: Angle(degrees: 90), clockwise: true)
        }
    }
}

struct Segment4: Shape {
    func path (in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX , y: rect.midY))
                      path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.height / 2, startAngle: Angle(degrees: -180), endAngle: Angle(degrees: -90), clockwise: false)
        }
    }
}

    
struct ringView: View {
    private let LineWidth: CGFloat = 22
    
        var body: some View{
        
            ZStack {
                    Segment1()
                        .trim(from: 0, to: 0.90)
                        .trim(from: 0.10, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    Segment2()
                        .trim(from: 0, to: 0.90)
                        .trim(from: 0.10, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    Segment3()
                        .trim(from: 0, to: 0.90)
                        .trim(from: 0.10, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    Segment4()
                        .trim(from: 0, to: 0.90)
                        .trim(from: 0.10, to: 1)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                
            }
            .frame( width: 230, height: 230)
        }
    }

struct ringView_Previews: PreviewProvider {
    static var previews: some View {
        ringView()
    }
}




