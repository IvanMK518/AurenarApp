//
//  dynIsland.swift
//  dynIsland
//
//  Created by Ivan Martinez-Kay on 6/30/25.
//

import WidgetKit
import SwiftUI
import ActivityKit

struct dynIsland: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeTrackingAttributes.self) {
            context in TimeTrackingWidgetView(context: context) } dynamicIsland: { context in
                DynamicIsland{
                    DynamicIslandExpandedRegion(.leading) {
                        Text("Main")
                    }
                    DynamicIslandExpandedRegion(.trailing) {
                        Text("trail")
                    }
                    DynamicIslandExpandedRegion(.center) {
                        Text("Center")
                    }
                    DynamicIslandExpandedRegion(.bottom) {
                        Text("Bottom")
                    }
                
                } compactLeading: {
                    Text("test1")
                } compactTrailing: {
                    Text("test2")
                } minimal: {
                    Text("test3")
                }
                    }
                }
            }

struct TimeTrackingWidgetView: View {
    let context: ActivityViewContext<TimeTrackingAttributes>
    
    var body: some View {
        Text(context.state.startTime, style: .relative)
    }
}
