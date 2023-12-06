//
//  TableViewTag.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/05.
//

enum TableViewTag: CustomStringConvertible {
    case todo
    case doing
    case done
    
    var tag: Int {
        switch self {
        case .todo:
            return 1
        case .doing:
            return 2
        case .done:
            return 3
        }
    }
    
    var description: String {
        switch self {
        case .todo:
            return "todoTableView"
        case .doing:
            return "doingTableView"
        case .done:
            return "doneTableView"
        }
    }
}
