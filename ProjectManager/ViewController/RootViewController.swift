//
//  RootViewController.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/04.
//

import UIKit

final class RootViewController: UIViewController {
    private var todoData: [TextDataModel] = []
    private var doingData: [TextDataModel] = []
    private var doneData: [TextDataModel] = []
    private let cellModelView: CellViewModel = CellViewModel()
    
    private let todoTitleView: UIView = {
        let titleView: TitleView = TitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = .systemBackground
        titleView.configureTitleLabel(text: "TODO")
        
        return titleView
    }()
    
    private let doingTitleView: UIView = {
        let titleView: TitleView = TitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = .systemBackground
        titleView.configureTitleLabel(text: "DOING")
        
        return titleView
    }()
    
    private let doneTitleView: UIView = {
        let titleView: TitleView = TitleView()
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.backgroundColor = .systemBackground
        titleView.configureTitleLabel(text: "DONE")
        
        return titleView
    }()
    
    private let todoTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewTag.todo.description)
        tableView.tag = TableViewTag.todo.tag
        
        return tableView
    }()
    
    private let doingTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewTag.doing.description)
        tableView.tag = TableViewTag.doing.tag
        
        return tableView
    }()
    
    private let doneTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewTag.done.description)
        tableView.tag = TableViewTag.done.tag
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNatigation()
        configureUI()
        configureLayout()
    }
    
    private func configureNatigation() {
        let plusButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(touchUpPlusButton))
        navigationItem.rightBarButtonItem = plusButton
        navigationItem.title = "Project Manager"
    }
    
    @objc private func touchUpPlusButton() {
        let editViewController: EditViewController = EditViewController(textData: TextDataModel(), writeMode: .new, tableViewTag: TableViewTag.todo.tag, indexPath: nil)
        editViewController.modalPresentationStyle = .formSheet
        editViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: editViewController)
        present(navigationController, animated: true, completion: nil)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        todoTableView.delegate = self
        todoTableView.dataSource = self
        doingTableView.delegate = self
        doingTableView.dataSource = self
        doneTableView.delegate = self
        doneTableView.dataSource = self
        
        view.addSubview(todoTitleView)
        view.addSubview(todoTableView)
        view.addSubview(doingTitleView)
        view.addSubview(doingTableView)
        view.addSubview(doneTitleView)
        view.addSubview(doneTableView)
    }
    
    private func configureLayout() {
        let viewWidth = view.safeAreaLayoutGuide.layoutFrame.width / 3.0
        
        NSLayoutConstraint.activate([
            todoTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            todoTitleView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todoTitleView.widthAnchor.constraint(equalToConstant: viewWidth),
            todoTitleView.bottomAnchor.constraint(equalTo: todoTableView.topAnchor, constant: -8),
            
            todoTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            todoTableView.widthAnchor.constraint(equalToConstant: viewWidth),
            todoTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doingTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doingTitleView.leadingAnchor.constraint(equalTo: todoTableView.trailingAnchor),
            doingTitleView.widthAnchor.constraint(equalToConstant: viewWidth),
            doingTitleView.bottomAnchor.constraint(equalTo: doingTableView.topAnchor, constant: -8),
            
            doingTableView.leadingAnchor.constraint(equalTo: todoTableView.trailingAnchor),
            doingTableView.widthAnchor.constraint(equalToConstant: viewWidth),
            doingTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            doneTitleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            doneTitleView.leadingAnchor.constraint(equalTo: doingTitleView.trailingAnchor),
            doneTitleView.widthAnchor.constraint(equalToConstant: viewWidth),
            doneTitleView.bottomAnchor.constraint(equalTo: doneTableView.topAnchor, constant: -8),
            
            doneTableView.leadingAnchor.constraint(equalTo: doingTableView.trailingAnchor),
            doneTableView.widthAnchor.constraint(equalToConstant: viewWidth),
            doneTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

extension RootViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getNumberOfSection(tableView)
    }
    
    func getNumberOfSection(_ tableView: UITableView) -> Int {
        switch tableView.tag {
        case TableViewTag.todo.tag:
            return todoData.count
        case TableViewTag.doing.tag:
            return doingData.count
        case TableViewTag.done.tag:
            return doneData.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCell(tableView: tableView, indexPath: indexPath)
    }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var identifier: String
        var data: TextDataModel?
        
        switch tableView.tag {
        case TableViewTag.todo.tag:
            identifier = TableViewTag.todo.description
            data = todoData[safe: indexPath.item]
        case TableViewTag.doing.tag:
            identifier = TableViewTag.doing.description
            data = doingData[safe: indexPath.item]
        case TableViewTag.done.tag:
            identifier = TableViewTag.done.description
            data = doneData[safe: indexPath.item]
        default:
            return TableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TableViewCell,
              let data = data else {
            return TableViewCell()
        }
        
        let longTappedCell = UILongPressGestureRecognizer(target: self, action: #selector(longTappedCell))
        cell.configureLabel(textData: data)
        cell.addGestureRecognizer(longTappedCell)
        
        return cell
    }
    
    @objc private func longTappedCell(_ gestureRecognizer: UILongPressGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? UITableViewCell,
              let tableView = cell.superview as? UITableView else {
            return
        }
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let moveToToDo: UIAlertAction = UIAlertAction(title: "move to todo", style: .default) { [weak self] _ in
            if tableView.tag == TableViewTag.doing.tag { // doing -> todo
                guard let indexPath = self?.doingTableView.indexPath(for: cell),
                      let doingData = self?.doingData[safe: indexPath.row],
                      let todoDataCount = self?.todoData.count else {
                    return
                }
                
                self?.todoData.append(doingData)
                self?.doingData.remove(at: indexPath.row)
                self?.doingTableView.deleteRows(at: [indexPath], with: .automatic)
                let index = IndexPath(row: todoDataCount, section: 0)
                self?.todoTableView.insertRows(at: [index], with: .automatic)
            }
            
            if tableView.tag == TableViewTag.done.tag { // done -> todo
                guard let indexPath = self?.doneTableView.indexPath(for: cell),
                      let doneData = self?.doneData[safe: indexPath.row],
                      let todoDataCount = self?.todoData.count else {
                    return
                }
                
                self?.todoData.append(doneData)
                self?.doneData.remove(at: indexPath.row)
                self?.doneTableView.deleteRows(at: [indexPath], with: .automatic)
                let index = IndexPath(row: todoDataCount, section: 0)
                self?.todoTableView.insertRows(at: [index], with: .automatic)
            }
        }
        
        let moveToDoing: UIAlertAction = UIAlertAction(title: "move to doing", style: .default) { [weak self] _ in
            if tableView.tag == TableViewTag.todo.tag { // todo -> doing
                guard let indexPath = self?.todoTableView.indexPath(for: cell),
                      let todoData = self?.todoData[safe: indexPath.row],
                      let doingDataCount = self?.doingData.count else {
                    return
                }
                
                self?.doingData.append(todoData)
                self?.todoData.remove(at: indexPath.row)
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
                let index = IndexPath(row: doingDataCount, section: 0)
                self?.doingTableView.insertRows(at: [index], with: .automatic)
            }
            
            if tableView.tag == TableViewTag.done.tag { // done -> doing
                guard let indexPath = self?.doneTableView.indexPath(for: cell),
                      let doneData = self?.doneData[safe: indexPath.row],
                      let doingDataCount = self?.doingData.count else {
                    return
                }
                
                self?.doingData.append(doneData)
                self?.doneData.remove(at: indexPath.row)
                self?.doneTableView.deleteRows(at: [indexPath], with: .automatic)
                let index = IndexPath(row: doingDataCount, section: 0)
                self?.doingTableView.insertRows(at: [index], with: .automatic)
            }
        }
        
        let moveToDone: UIAlertAction = UIAlertAction(title: "move to done", style: .default) { [weak self] _ in
            if tableView.tag == TableViewTag.todo.tag { // todo -> done
                guard let indexPath = self?.todoTableView.indexPath(for: cell),
                      let todoData = self?.todoData[safe: indexPath.row],
                      let doneDataCount = self?.doneData.count else {
                    return
                }
                
                self?.doneData.append(todoData)
                self?.todoData.remove(at: indexPath.row)
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
                let index = IndexPath(row: doneDataCount, section: 0)
                self?.doneTableView.insertRows(at: [index], with: .automatic)
            }
            
            if tableView.tag == TableViewTag.doing.tag { // doing -> done
                guard let indexPath = self?.doingTableView.indexPath(for: cell),
                      let doingData = self?.doingData[safe: indexPath.row],
                      let doneDataCount = self?.doneData.count else {
                    return
                }
                
                self?.doneData.append(doingData)
                self?.doingData.remove(at: indexPath.row)
                self?.doingTableView.deleteRows(at: [indexPath], with: .automatic)
                let index = IndexPath(row: doneDataCount, section: 0)
                self?.doneTableView.insertRows(at: [index], with: .automatic)
            }
        }
        
        switch tableView.tag {
        case TableViewTag.todo.tag:
            alertController.addAction(moveToDoing)
            alertController.addAction(moveToDone)
        case TableViewTag.doing.tag:
            alertController.addAction(moveToToDo)
            alertController.addAction(moveToDone)
        case TableViewTag.done.tag:
            alertController.addAction(moveToToDo)
            alertController.addAction(moveToDoing)
        default:
            print("alertController error")
        }
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = cell
            let location = gestureRecognizer.location(in: cell)
            let rect = CGRect(origin: location, size: .zero)
            popoverController.sourceRect = rect
            popoverController.permittedArrowDirections = []
            
        }
        
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textData: TextDataModel?
        switch tableView.tag {
        case TableViewTag.todo.tag:
            textData = todoData[safe: indexPath.row]
        case TableViewTag.doing.tag:
            textData = doingData[safe: indexPath.row]
        case TableViewTag.done.tag:
            textData = doneData[safe: indexPath.row]
        default:
            print("textData error")
            return
        }
        
        guard let textData = textData else {
            return
        }
        
        let editViewController: EditViewController = EditViewController(textData: textData, writeMode: .edit, tableViewTag: tableView.tag, indexPath: indexPath)
        editViewController.modalPresentationStyle = .formSheet
        editViewController.delegate = self
        tableView.deselectRow(at: indexPath, animated: true)
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: editViewController)
        present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] (action, view, completionHandler) in
            switch tableView.tag {
            case TableViewTag.todo.tag:
                self?.todoData.remove(at: indexPath.row)
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.doing.tag:
                self?.doingData.remove(at: indexPath.row)
                self?.doingTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.done.tag:
                self?.doneData.remove(at: indexPath.row)
                self?.doneTableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                print("swipe error")
            }
            
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    

    

}

extension RootViewController: EditViewControllerDelegate {
    func updateCell(textData: TextDataModel, writeMode: WriteMode, tableViewTag: Int, indexPath: IndexPath?) {
        
        switch writeMode {
        case .new:
            let todoIndexPath: IndexPath = IndexPath(row: todoData.count, section: 0)
            todoData.append(textData)
            todoTableView.insertRows(at: [todoIndexPath], with: .automatic)
        case .edit:
            guard let indexPath = indexPath else {
                return
            }
            
            switch tableViewTag {
            case TableViewTag.todo.tag:
                todoData[indexPath.row] = textData
                todoTableView.reloadRows(at: [indexPath], with: .automatic)
            case TableViewTag.doing.tag:
                doingData[indexPath.row] = textData
                doingTableView.reloadRows(at: [indexPath], with: .automatic)
            case TableViewTag.done.tag:
                doneData[indexPath.row] = textData
                doneTableView.reloadRows(at: [indexPath], with: .automatic)
            default:
                print("delegate tag error")
                return
            }
        }
    }
}
