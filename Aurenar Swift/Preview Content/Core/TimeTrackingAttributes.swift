//
//  TimeTrackingAttributes.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 6/30/25.
//

import Foundation
import ActivityKit

struct TimeTrackingAttributes: ActivityAttributes {
    public typealias TimeTrackingStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var startTime: Date
    }
}
