//
//  CalendarView.swift
//  Aurenar Swift
//
//  Created by Ivan Martinez-Kay on 8/4/25.
//

import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var therapyCounter: TherapyCounter
    @State private var color: Color = Color(red: 3.0/255.0, green: 160.0/255.0, blue: 211.0/255.0)
    @State private var date = Date.now
    let daysOfWeek = Date.firstLetterOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    var body: some View {
        VStack {
            LabeledContent("Therapy Log") {
                    DatePicker("", selection: $date)
            }
            .padding(.bottom, 30)
            .font(.custom("Conthrax-Semibold", size: 18))
            .foregroundStyle(color)
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                   Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .foregroundStyle(color)
                        .frame(maxWidth: .infinity)
                }
            }
            .font(.custom("Conthrax-Semibold", size: 16))
            
            LazyVGrid (columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        VStack {
                            Text(day.formatted(.dateTime.day()))
                                .font(.custom("ClashGrotesk-SemiBold", size: 20))
                                .foregroundStyle(color)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Circle().foregroundStyle(Date.now.startOfDay == day.startOfDay ? color.opacity(0.3) : Color(.label).opacity(0.2))
                                )
                            
                            HStack(spacing: 3) {
                                let completions = therapyCounter.getCompletion(for: day)
                                Image(systemName: "checkmark.circle")
                                    .font(completions == 1 ? .system(size: 12) : .system(size: 8))
                                    .foregroundStyle(completions == 1 ? Color(.yellow) : completions >= 2 ? color : Color(.gray))
                                Image(systemName: "checkmark.circle")
                                    .font(completions >= 2 ? .system(size: 12) : .system(size: 8))
                                    .foregroundStyle(completions >= 2 ? color : Color(.gray))
                            }
                            .padding(.top, 1)
                            .padding(.bottom, 3)
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
        }
    }
}

extension Date {
    static var firstLetterOfWeekdays: [String] {
        let calendar = Calendar.current
        let weekdays = calendar.shortWeekdaySymbols
        
        return weekdays.map { weekday in
            guard let firstLetter = weekday.first else {
                return ""
            }
            return String(firstLetter).capitalized
        }
    }
    
    static var monthNames: [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        
        return (1...12).compactMap { month in
            dateFormatter.setLocalizedDateFormatFromTemplate("MMMM")
            let date = Calendar.current.date(from: DateComponents(year: 2000, month: month, day: 1))
            return date.map { dateFormatter.string(from: $0) }
        }
    }
    
    var startOfMonth: Date {
        Calendar.current.dateInterval(of: .month, for: self)!.start
    }
    
    var endOfMonth: Date {
       let lastDay = Calendar.current.dateInterval(of: .month, for: self)!.end
        return Calendar.current.date(byAdding: .day, value: -1, to: lastDay)!
    }
    
    var startOfPreviousMonth: Date {
        let dayInPreviousMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return dayInPreviousMonth.startOfMonth
    }
    
    var numberOfDaysInMonth: Int {
        Calendar.current.component(.day, from: endOfMonth)
    }
    
    var sundayBeforeStart: Date {
        let startOfMonthWeekday = Calendar.current.component(.weekday, from: startOfMonth)
        let numberFromPreviousMonth = startOfMonthWeekday - 1
        return Calendar.current.date(byAdding: .day, value: -numberFromPreviousMonth, to: startOfMonth)!
    }
    
    var calendarDisplayDays: [Date] {
        var days: [Date] = []
        for dayOffset in 0..<numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfMonth)
            days.append(newDay!)
        }
        
        for dayOffset in 0..<startOfPreviousMonth.numberOfDaysInMonth {
            let newDay = Calendar.current.date(byAdding: .day, value: dayOffset, to: startOfPreviousMonth)
            days.append(newDay!)
        }
        
        return days.filter {
            $0 >= sundayBeforeStart && $0 <= endOfMonth
        }.sorted(by: <)
        
    }
    
    var monthInt: Int {
        Calendar.current.component(.month, from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

struct Calendarview_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
            .environmentObject(TherapyCounter())
    }
}
