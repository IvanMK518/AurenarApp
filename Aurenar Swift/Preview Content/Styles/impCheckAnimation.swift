//
//  impCheckAnimation.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 8/4/25.
//

import SwiftUI

struct impCheckAnimation: View {
    private let LineWidth: CGFloat = 18
    @State private var activeSegment = 1
    
    let timer = Timer.publish(every: 0.15, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ringView()
                .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).opacity(0.0)
            
            Group {
                if activeSegment == 1 {
                    Segment1()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .glow()
                } else {
                    Segment1()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).opacity(0.10)
                }
            }
            
            Group {
                if activeSegment == 2 {
                    Segment2()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .glow()
                } else {
                    Segment2()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .opacity(0.10)
                }
            }
            
            Group {
                if activeSegment == 3 {
                    Segment3()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .glow()
                } else {
                    Segment3()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .opacity(0.10)
                }
            }
            
            Group {
                if activeSegment == 4 {
                    Segment4()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .glow()
                } else {
                    Segment4()
                        .trim(from: 0.10, to: 0.90)
                        .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                        .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0))
                        .opacity(0.10)
                }
            }
        }
        .padding(50)
        .frame(width: 230, height: 230)
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.15)) {
                activeSegment = activeSegment % 4 + 1
            }
        }
    }
}

struct impCheckAnimation_Previews: PreviewProvider {
    static var previews: some View {
        impCheckAnimation()
    }
}
