//
//  waveAnimation.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 7/1/25.
//

/*
 Supplementary animation in accordance with timer.
 */

import SwiftUI

struct WaveAnimation: View {
    var progress: CGFloat
    private let LineWidth: CGFloat = 18


    var body: some View {
            ZStack {
                ringView()
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).opacity(0.15)
                Segment1()
                    .trim(from: 1 - segmentAnimation(progress: progress, i: 0), to: 0.90 )
                    .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).glow()
                Segment2()
                    .trim(from: 0.10, to: segmentAnimation(progress: progress, i: 1))
                    .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).glow()
                Segment3()
                    .trim(from: 1 - segmentAnimation(progress: progress, i: 2), to: 0.90 )
                    .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).glow()
                Segment4()
                    .trim(from: 0.10, to: segmentAnimation(progress: progress, i: 3))
                    .stroke(style: StrokeStyle(lineWidth: LineWidth, lineCap: .round))
                    .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).glow()
                
            }
            .padding(50)
            .animation(.easeInOut(duration: 0.5), value: progress)
            
    }
    
    func segmentAnimation(progress: CGFloat, i: Int) -> CGFloat {
        let segStart: CGFloat = 0.10
        let segEnd: CGFloat = 0.90
        let segLen: CGFloat = segEnd - segStart
        let start = CGFloat(i) * 0.25
        let end = start + 0.25

        if progress >= end {
            return segEnd
        } else if progress >= start {
            let partial = (progress - start) / (end - start)
            return segStart + partial * segLen
        } else {
            return segStart
        }
    }
    

}
