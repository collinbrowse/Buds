//
//  TimeHelper.swift
//  Buds
//
//  Created by Collin Browse on 7/22/19.
//  Copyright © 2019 Collin Browse. All rights reserved.
//

import Foundation



class TimeHelper {
    
    // Helper Function to get the current Date/Time as a String
    static func getTodayString() -> String {
        
        // Current time
        let now = Date()
        
        // Let's set the format of date we will be using throughout the app
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Let's change our date object to that string with that format
        let formattedDateString = formatter.string(from: now)
        
        return formattedDateString
    }
    
    static func getDateFromString(dateString: String) -> Date {
        
        // Create a Date Formatter object so we have a set of rules that the Date Object can follow
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Use the Date Formatter object to create a date object from a string
        let formattedDate = formatter.date(from: dateString)
        
        return formattedDate!
    }
}


// Has to be called upon using a date object
// That date object will the past date
// It is represented using self
extension Date {
    func timeAgoString() -> String {
        
        let now = Date()
        let secondsAgo = Int(now.timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        
        if secondsAgo < minute {
            return "\(secondsAgo)s"
        }
        else if secondsAgo < hour {
            return "\(secondsAgo / minute)m"
        }
        else if secondsAgo < day {
            return "\(secondsAgo / hour)h"
        }
        else if secondsAgo < week {
            return "\(secondsAgo / day)d"
        }
        return "\(secondsAgo / week)w"
    }
}
