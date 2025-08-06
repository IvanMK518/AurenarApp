//
//  TimerView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/25/25.
//

/*
 Handles Stim timer updates being sent to device and start/stop functionality via phone.
*/

import Foundation
import SwiftUI
import ActivityKit

struct TimerView: View {
    enum TimerState {
        case paused
        case running
        case stopped
        case impFail
        case impCheck
        case batLow
        case therapyCP
        case impSuccess
    }
    
    @ObservedObject var bt: bluetoothService
    @State private var startTime: Date? = nil
    @State private var activity: Activity<TimeTrackingAttributes>? = nil
    @State private var time = 20 * 60
    @State private var timer: Timer? = nil
    @State private var overlayStatus = false
    @State private var message: String = ""
    @State private var message2: String = ""
    @State private var image: String = "ear.trianglebadge.exclamationmark"
    @State private var curColor: Color = .yellow
    @State private var errorDuration: Double = 10.0
    @EnvironmentObject var therapyCounter: TherapyCounter
    
    
    
    
    let totalTime: Double = 20 * 60
    
    var formattedTime: String {
        let min = (time % 3600) / 60
        let sec = time % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    var body: some View {
        let progress = 1.0 - Double(time) / totalTime
        
    ZStack {
        
        //battery percentage
        let batteryLVL = bt.batteryLvl
         
        
        //impedance lvl meter
        let impedanceLVL = bt.impedanceLvl
        
        VStack(spacing: 25) {
            
            VStack(spacing: 0) {
                HStack (spacing: 30) {
                    
                    levelCheckView(lvl: batteryLVL, imageName: "bolt.fill")
                        .frame(width: 100, height: 30)
                    levelCheckView(lvl: batteryLVL, imageName: "link")
                        .frame(width: 100, height: 30)
        
                }
                
                levelCheckView(lvl: impedanceLVL, imageName: "waveform.path.ecg")
                    .frame(width: 230, height: 70)
                
            }
            
            ZStack {
                if bt.devState == .impSuccess {
                    impCheckAnimation()
                } else if bt.devState == .running {
                    WaveAnimation(progress: CGFloat(progress))
                        .frame( width: 230, height: 230)
                } else {
                    if bt.devState == .paused {
                        WaveAnimation(progress: CGFloat(progress))
                            .frame( width: 230, height: 230)
                    } else {
                        ringView()
                            .foregroundColor(Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)).opacity(0.15)
                            .frame( width: 230, height: 230)
                    }
                }
                
                
                Text(formattedTime)
                    .font(.system(size: 45))
                    .padding()
                
                
            }
            .padding(.top, 0)
            
            
            Button(action: {
                switch bt.devState {
                case .paused:
                    bt.resumeStim()
                    
                case .running:
                    
                    bt.pauseStim()
                    
                case .impFail:
                    bt.resumeStim()
                    
                case .impCheck, .batLow, .therapyCP, .impSuccess:
                    break
                    
                case .stopped:
                    bt.startStim()
                    startTime = .now
                    
                    let attributes = TimeTrackingAttributes()
                    let state = TimeTrackingAttributes.ContentState(startTime: .now)
                    let content = ActivityContent(state: state, staleDate: nil)
                    
                    activity = try? Activity<TimeTrackingAttributes>.request(attributes: attributes, content: content, pushType: nil )
                }
            }) {
                Image(systemName: bt.devState == .running ? "pause.fill" : bt.devState == .paused ? "play.fill" : "play.fill")
                    .font(.system( size: 50 ))
                    .foregroundColor(Color(.label).opacity(0.7))
                    .cornerRadius(50)
                    .shadow(color: .gray, radius: 3, x: 0, y: 2)
            }
            .buttonStyle(.plain)
            .padding(.top, 30)
            
        }
        .padding(.horizontal)
        
        if overlayStatus {
            Color(.systemBackground)
                .opacity(1.0)
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)
                .zIndex(2)
            errorCheckView(
                bt: bt,
                imageName: image,
                color: curColor,
                msg: message,
                msg2: message2,
                duration: errorDuration
            )
            .transition(.scale.combined(with: .opacity))
            .zIndex(3)
        }
    }
        
        
        
            .onChange(of: bt.devState) {
                switch bt.devState {
                case .running, .impSuccess:
                    startTimer()
                case .paused, .impFail:
                    stopTimer()
                case .stopped, .batLow, .impCheck:
                    stopTimer()
                    time = Int(totalTime)
                case .therapyCP:
                    stopTimer()
                    time = Int(totalTime)
                    therapyCounter.countCompletion()
                }

                switch bt.devState {
                    case .impFail:
                    overlay(imageUsed: "ear.trianglebadge.exclamationmark", curColorUsed: .yellow, messageUsed: "Poor Ear Contact", message2Used: "Please Reapply Gel And Start Stimulation", durationSet: 10.0)
                    case .therapyCP:
                        overlay(imageUsed: "checkmark.circle", curColorUsed: Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0), messageUsed: "Therapy Complete!", message2Used: "", durationSet: 5.0)
                    case .batLow:
                    overlay(imageUsed: "battery.0percent", curColorUsed: .red, messageUsed: "Battery Low", message2Used: "Please Charge Device", durationSet: 5.0)
                    case .impCheck:
                    overlay(imageUsed: "x.circle", curColorUsed: .red, messageUsed: "Impedance Check Failed", message2Used: "Please Restart Device", durationSet: 5.0)
                    default:
                        break
                    }
                }
    }
    
    func overlay(imageUsed: String, curColorUsed: Color, messageUsed: String, message2Used: String, durationSet: Double) {
        image = imageUsed
        curColor = curColorUsed
        message = messageUsed
        message2 = message2Used
        errorDuration = durationSet
        overlayStatus = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + errorDuration) {
            if overlayStatus {
                overlayStatus = false
            }
        }
        
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if bt.devState == .running && time > 0 {
                time -= 1
            }
            
            if time == 0 {
                bt.devState = .stopped
                stopTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(bt: bluetoothService())
            .environmentObject(TherapyCounter())
    }
}
