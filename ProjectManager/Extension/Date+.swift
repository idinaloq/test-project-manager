//
//  Date+.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/18.
//

import Foundation

extension Date {
    static var today: Date {
        let date: Date = Date()
        return date
    }
    
    func convertString(date: Date) -> String {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy. MM. dd."
        
        return dateformatter.string(from: date)
    }

    func checkDeadlineIsOver(at selectDate: Date) -> Bool {
        let currentDate = Date()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd"
        let selectDateString = dateformatter.string(from: selectDate)
        let currentDateString = dateformatter.string(from: currentDate)
        
        guard let selectDate = dateformatter.date(from: selectDateString),
              let today = dateformatter.date(from: currentDateString) else {
            return false
        }
        
        switch today.compare(selectDate) {
        case .orderedSame:
            return true
        case .orderedAscending:
            return false
        case .orderedDescending:
            return true
        }
    }
}
