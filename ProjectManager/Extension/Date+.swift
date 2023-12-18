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
}
