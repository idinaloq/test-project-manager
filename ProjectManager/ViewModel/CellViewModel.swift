//
//  CellViewModel.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/20.
//

import UIKit

class CellViewModel {
    private var textDataViewModel: TextDataViewModel = TextDataViewModel()
    
    func getNumberOfData(in tableView: UITableView) -> Int {
        switch tableView.tag {
        case TableViewTag.todo.tag:
            return textDataViewModel.todoData.count
        case TableViewTag.doing.tag:
            return textDataViewModel.doingData.count
        case TableViewTag.done.tag:
            return textDataViewModel.doneData.count
        default:
            return 0
        }
    }
 
    func getNumberOfData(tag: TableViewTag) -> Int {
        switch tag {
        case .todo:
            return textDataViewModel.todoData.count
        case .doing:
            return textDataViewModel.doingData.count
        case .done:
            return textDataViewModel.doneData.count
        }
    }
    
    func getTextData(for tableView: UITableView, at index: Int) -> TextDataModel? {
        var textData: TextDataModel?
        switch tableView.tag {
        case TableViewTag.todo.tag:
            textData = textDataViewModel.todoData[safe: index]
        case TableViewTag.doing.tag:
            textData = textDataViewModel.doingData[safe: index]
        case TableViewTag.done.tag:
            textData = textDataViewModel.doneData[safe: index]
        default:
            print("get data error")
            return textData
        }
        
        return textData
    }
    
    func removeData(tableView: UITableView, index: Int) {
        switch tableView.tag {
        case TableViewTag.todo.tag:
            textDataViewModel.todoData.remove(at: index)
        case TableViewTag.doing.tag:
            textDataViewModel.doingData.remove(at: index)
        case TableViewTag.done.tag:
            textDataViewModel.doneData.remove(at: index)
        default:
            print("data remove error")
        }
    }
    
    func appendData(tableView: UITableView, data: TextDataModel) {
        switch tableView.tag {
        case TableViewTag.todo.tag:
            textDataViewModel.todoData.append(data)
        case TableViewTag.doing.tag:
            textDataViewModel.doingData.append(data)
        case TableViewTag.done.tag:
            textDataViewModel.doneData.append(data)
        default:
            print("data append error")
        }
    }
    
    func appendData(data: TextDataModel, tag: TableViewTag) {
        switch tag {
        case .todo:
            textDataViewModel.todoData.append(data)
        case .doing:
            textDataViewModel.doingData.append(data)
        case .done:
            textDataViewModel.doneData.append(data)
        }
    }
    
    func changeData(tableView: UITableView, index: Int, data: TextDataModel) {
        switch tableView.tag {
        case TableViewTag.todo.tag:
            textDataViewModel.todoData[index] = data
        case TableViewTag.doing.tag:
            textDataViewModel.doingData[index] = data
        case TableViewTag.done.tag:
            textDataViewModel.doneData[index] = data
        default:
            print("data change error")
        }
    }
}

