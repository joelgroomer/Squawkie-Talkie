//
//  PlaybackController.swift
//  Squawkie-Talkie
//
//  Created by Joel Groomer on 1/17/21.
//

import CoreData

enum DayOfWeek: Int {
    case sun = 0
    case mon = 1
    case tue = 2
    case wed = 3
    case thu = 4
    case fri = 5
    case sat = 6
}

class PlaybackController {
    static let shared = PlaybackController()
    
    private (set) var activeDays = [false, true, true, true, true, true, false]   // defaults to true for weekdays and false for weekends
    private (set) var startTime: Date?
    private (set) var endTime: Date?
    private let dateFormatter: DateFormatter
    private var timer = Timer()
    
    var paused = false
    
    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if UserDefaults.standard.bool(forKey: "Initialized") {
            activeDays[DayOfWeek.sun.rawValue] = UserDefaults.standard.bool(forKey: "Sun")
            activeDays[DayOfWeek.mon.rawValue] = UserDefaults.standard.bool(forKey: "Mon")
            activeDays[DayOfWeek.tue.rawValue] = UserDefaults.standard.bool(forKey: "Tue")
            activeDays[DayOfWeek.wed.rawValue] = UserDefaults.standard.bool(forKey: "Wed")
            activeDays[DayOfWeek.thu.rawValue] = UserDefaults.standard.bool(forKey: "Thu")
            activeDays[DayOfWeek.fri.rawValue] = UserDefaults.standard.bool(forKey: "Fri")
            activeDays[DayOfWeek.sat.rawValue] = UserDefaults.standard.bool(forKey: "Sat")
            startTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: "startTime") ?? "8:00")
            endTime = dateFormatter.date(from: UserDefaults.standard.string(forKey: "endTime") ?? "17:00")
        } else {
            startTime = dateFormatter.date(from: "8:00")
            startTime = dateFormatter.date(from: "17:00")
            saveDefaults()
        }
        
        timer = Timer(timeInterval: 60, target: self, selector: #selector(playSomePhrases), userInfo: nil, repeats: true)
    }
    
    @objc func playSomePhrases() {
        if !paused {
            let today = Date()
            let cal = Calendar.current
            let day = cal.component(.weekday, from: today)  // sun = 1, sat = 7 (1 higher than our array)
            if activeDays[day - 1] {
                if let startTime = startTime, let endTime = endTime {
                    let now = dateFormatter.date(from: dateFormatter.string(from: today))
                    if let now = now, startTime < now && now < endTime {
                        print("A phrase should play now")
                    }
                }
            }
        }
    }
    
    private func saveDefaults() {
        UserDefaults.standard.setValue(true, forKey: "Initialized")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.sun.rawValue], forKey: "Sun")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.mon.rawValue], forKey: "Mon")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.tue.rawValue], forKey: "Tue")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.wed.rawValue], forKey: "Wed")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.thu.rawValue], forKey: "Thu")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.fri.rawValue], forKey: "Fri")
        UserDefaults.standard.setValue(activeDays[DayOfWeek.sat.rawValue], forKey: "Sat")
        if let startTime = startTime {
            UserDefaults.standard.setValue(dateFormatter.string(from: startTime), forKey: "startTime")
        } else {
            UserDefaults.standard.setValue("8:00", forKey: "startTime")
        }
        if let endTime = endTime {
            UserDefaults.standard.setValue(dateFormatter.string(from: endTime), forKey: "endTime")
        } else {
            UserDefaults.standard.setValue("17:00", forKey: "endTime")
        }
    }
    
    func toggleActiveDays(day: DayOfWeek) {
        activeDays[day.rawValue].toggle()
        saveDefaults()
    }
    
    func updateStartTime(to time: Date) {
        startTime = time
        saveDefaults()
    }
    
    func updateEndTime(to time: Date) {
        endTime = time
        saveDefaults()
    }
}
