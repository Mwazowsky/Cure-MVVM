//
//  Date.swift
//  Cure
//
//  Created by MacBook Air MII  on 16/5/25.
//

import Foundation

// MARK: - Int Extension
extension Int {
    
    func secondsToMinutes() -> Int { return self / 60 }
    func secondsToHours() -> Int{ return self / 3600 }
    func secondsToDays() -> Int{ return self / 86400 }
    func secondsToWeeks() -> Int{ return self / 604800 }
    func secondsToMonths() -> Int{ return self / 2629743 }
    func secondsToYears() -> Int{ return self / 31556926 }
    
    func minutesToSeconds() -> Int { return self * 60 }
    func hoursToSeconds() -> Int { return self * 3600 }
    func daysToSeconds() -> Int { return self * 86400 }
    func weeksToSeconds() -> Int { return self * 604800 }
    func monthsToSeconds() -> Int { return self * 2629743 }
    func yearsToSeconds() -> Int { return self * 31556926 }
}


// MARK: - Date Extension
extension Date {
    private static func standardFormat() -> String { return "EEEE, MMMM dd, yyyy " }
    
    // MARK: - Time Ago
    func timeAgo() -> String {
        
        let now = Date()
        let delta = Int(now.timeIntervalSince(self as Date))
        
        if delta < 30 {
            return "Just now"
        }
        
        else if delta < 1.minutesToSeconds() {
            return "\(delta) seconds ago"
        }
        
        else if delta < 2.minutesToSeconds() {
            return "a minute ago"
        }
        
        else if delta < 1.hoursToSeconds() {
            return "\(delta.secondsToMinutes()) minutes ago"
        }
        
        else if delta < 2.hoursToSeconds() {
            return "an hour ago"
        }
        
        else if delta < 1.daysToSeconds() {
            return "\(delta.secondsToHours()) hours ago"
        }
        
        else if delta < 2.daysToSeconds() {
            return "yesterday"
        }
        
        else if delta < 1.weeksToSeconds() {
            return "\(delta.secondsToDays()) days ago"
        }
        
        else if delta < 2.weeksToSeconds() {
            return "last week"
        }
        
        else if delta < 1.monthsToSeconds() {
            return "\(delta.secondsToWeeks()) weeks ago"
        }
        
        else if delta < 2.monthsToSeconds() {
            return "Last month"
        }
        
        else if delta < 1.yearsToSeconds() {
            return "\(delta.secondsToMonths()) months ago"
        }
        
        else if delta < 2.yearsToSeconds() {
            return "last year"
        }
        
        else {
            return "\(delta.secondsToYears()) years ago"
        }
        
    }
    
    // MARK: Time Until
    
    func timeUntil() -> String {
        
        let now = Date()
        let delta = Int(self.timeIntervalSince(now))
        
        if delta < 0 {
            return "Now"
        }
        
        else if delta < 2 {
            return "\(delta) second"
        }
        
        else if delta < 1.minutesToSeconds() {
            return "\(delta) seconds"
        }
        
        else if delta < 2.minutesToSeconds() {
            return "\(delta.secondsToMinutes()) minute"
        }
        
        else if delta < 1.hoursToSeconds() {
            return "\(delta.secondsToMinutes()) minutes"
        }
        
        else if delta < 2.hoursToSeconds() {
            return "\(delta.secondsToHours()) hour"
        }
        
        else if delta < 1.daysToSeconds() {
            return "\(delta.secondsToHours()) hours"
        }
        
        else if delta < 2.daysToSeconds()  {
            return "\(delta.secondsToDays()) day"
        }
        
        else if delta < 1.weeksToSeconds() {
            return "\(delta.secondsToDays()) days"
        }
        
        else if delta < 2.weeksToSeconds() {
            return "\(delta.secondsToWeeks()) week"
        }
        
        else if delta < 1.monthsToSeconds() {
            return "\(delta.secondsToWeeks()) weeks"
        }
        
        else if delta < 2.monthsToSeconds() {
            return "\(delta.secondsToMonths()) month"
        }
        
        else if delta < 1.yearsToSeconds() {
            return "\(delta.secondsToMonths()) months"
        }
        
        else if delta < 2.yearsToSeconds() {
            return "\(delta.secondsToYears()) year"
        }
        
        else {
            return "\(delta.secondsToYears()) years"
        }
        
    }
    
    // MARK: From String
    
    init(fromString string: String) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = Date.standardFormat()
        
        if let date = formatter.date(from: string) {
            self.init(timeInterval:0, since:date)
        } else {
            self.init()
        }
        
    }
    
    // MARK: To String
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = Date.standardFormat()
        return formatter.string(from: self as Date)
    }
    
    func toUnix() -> Double {
        return self.timeIntervalSince1970
    }
    
    // MARK: Adjusting Dates
    
    /// Returns a new date by adding N number of days
    func dateByAddingDays(days: Int) -> Date {
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate + Double(1.daysToSeconds()) * Double(days)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    /// Returns a new date by subtracting N number of days
    func dateBySubtractingDays(days: Int) -> Date {
        let interval: TimeInterval = self.timeIntervalSinceReferenceDate - Double(1.daysToSeconds()) * Double(days)
        return Date(timeIntervalSinceReferenceDate: interval)
    }
    
    
    
}

private extension Date {
    static func components(from date: Date) -> DateComponents {
        Calendar.current.dateComponents([.year, .month, .day], from: date)
    }
}

// MARK: - Comparing Dates
extension Date {
    func isToday() -> Bool {
        let comp1 = Date.components(from: self)
        let comp2 = Date.components(from: Date())
        return comp1.year == comp2.year &&
        comp1.month == comp2.month &&
        comp1.day == comp2.day
    }
    
    func isThisWeek() -> Bool {
        let calendar = Calendar(identifier: .gregorian)
        let comp1 = calendar.dateComponents([.weekOfYear], from: self)
        let comp2 = calendar.dateComponents([.weekOfYear], from: Date())
        return comp1.weekOfYear == comp2.weekOfYear
    }
    
    func isLaterThanToday() -> Bool {
        return self > Date()
    }
    
    func isEarlierThanToday() -> Bool {
        return self < Date()
    }
}

// MARK: - Date to readable String
extension Date {
    /// Returns the hour and minute in 24-hour format (e.g., "14:30")
        func stringHour24() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.string(from: self)
        }

        /// Returns the day of the week (e.g., "Monday")
        func stringDay() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.string(from: self)
        }

        /// Returns a date string in DD/MM/YYYY format (e.g., "14/05/2025")
        func stringDateDMY() -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy"
            formatter.locale = Locale(identifier: "en_US_POSIX")
            return formatter.string(from: self)
        }
}
