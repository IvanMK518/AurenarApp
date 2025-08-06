//
//  TherapyCounter.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 8/5/25.
//

import SwiftUI

class TherapyCounter: ObservableObject {
    @Published var count: [String: Int] = [:] {
        didSet {
           saveCompletions()
        }
    }
    
    init() {
        loadCompletion()
    }
    

    private func saveCompletions() {
        UserDefaults.standard.set(count, forKey: "therapyComplete")
    }
    
    func countCompletion() {
        let today = dateKey(for: Date())
        let currCount = count[today] ?? 0
        if currCount < 2 {
            count[today] = currCount + 1
        }
    }
    
    private func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func getCompletion(for date: Date) -> Int {
        let key = dateKey(for: date)
        return min(count[key] ?? 0, 2)
    }
    
    private func loadCompletion() {
        if let saved = UserDefaults.standard.dictionary(forKey: "therapyComplete") as? [String: Int] {
            count = saved
        }
    }
}
