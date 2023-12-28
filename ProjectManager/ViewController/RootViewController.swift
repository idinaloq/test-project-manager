//
//  RootViewController.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/04.
//
// 해야 될 작업
// TODO, DOING, DONE 제목 옆에 메모 갯수 표시하기
// 각각 TableView마다 구분선 표시하기
// 아이클라우드 연동

import UIKit

final class RootViewController: UIViewController {
    private let cellViewModel: CellViewModel = CellViewModel()
    
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
        let editViewController: EditViewController = EditViewController(data: TextDataModel(), writeMode: .new, tableView: todoTableView, indexPath: nil)
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
        
        return cellViewModel.getNumberOfData(in: tableView)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return createCell(for: tableView, at: indexPath)
    }
    
    func createCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        var identifier: String
        var data: TextDataModel?
        let index = indexPath.row
        
        switch tableView.tag {
        case TableViewTag.todo.tag:
            identifier = TableViewTag.todo.description
        case TableViewTag.doing.tag:
            identifier = TableViewTag.doing.description
        case TableViewTag.done.tag:
            identifier = TableViewTag.done.description
        default:
            return TableViewCell()
        }
        
        data = cellViewModel.getTextData(for: tableView, at: index)
        
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
              let tableView = cell.superview as? UITableView else { return }
        
        let alertController: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let moveToToDo: UIAlertAction = UIAlertAction(title: "move to todo", style: .default) { [weak self] _ in
            guard let indexPath = tableView.indexPath(for: cell),
                  let data = self?.cellViewModel.getTextData(for: tableView, at: indexPath.row),
                  let numberOfData = self?.cellViewModel.getNumberOfData(tag: .todo) else { return }
            
            let index = IndexPath(row: numberOfData, section: 0)
            self?.cellViewModel.appendData(data: data, tag: .todo)
            self?.cellViewModel.removeData(tableView: tableView, index: indexPath.row)
            
            switch tableView.tag {
            case TableViewTag.doing.tag:
                self?.doingTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.done.tag:
                self?.doneTableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                return
            }
            
            self?.todoTableView.insertRows(at: [index], with: .automatic)
        }
        
        let moveToDoing: UIAlertAction = UIAlertAction(title: "move to doing", style: .default) { [weak self] _ in
            guard let indexPath = tableView.indexPath(for: cell),
                  let data = self?.cellViewModel.getTextData(for: tableView, at: indexPath.row),
                  let numberOfData = self?.cellViewModel.getNumberOfData(tag: .doing) else { return }
            
            let index = IndexPath(row: numberOfData, section: 0)
            self?.cellViewModel.appendData(data: data, tag: .doing)
            self?.cellViewModel.removeData(tableView: tableView, index: indexPath.row)
            
            switch tableView.tag {
            case TableViewTag.todo.tag:
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.done.tag:
                self?.doneTableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                return
            }
            
            self?.doingTableView.insertRows(at: [index], with: .automatic)
        }
        
        let moveToDone: UIAlertAction = UIAlertAction(title: "move to done", style: .default) { [weak self] _ in
            guard let indexPath = tableView.indexPath(for: cell),
                  let data = self?.cellViewModel.getTextData(for: tableView, at: indexPath.row),
                  let numberOfData = self?.cellViewModel.getNumberOfData(tag: .done) else { return }
            
            let index = IndexPath(row: numberOfData, section: 0)
            self?.cellViewModel.appendData(data: data, tag: .done)
            self?.cellViewModel.removeData(tableView: tableView, index: indexPath.row)
            
            switch tableView.tag {
            case TableViewTag.todo.tag:
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.doing.tag:
                self?.doingTableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                return
            }
            
            self?.doneTableView.insertRows(at: [index], with: .automatic)
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

        guard let popoverController = alertController.popoverPresentationController else { return }
        
        popoverController.sourceView = cell
        let location = gestureRecognizer.location(in: cell)
        let rect = CGRect(origin: location, size: .zero)
        popoverController.sourceRect = rect
        popoverController.permittedArrowDirections = []
        present(alertController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = cellViewModel.getTextData(for: tableView, at: indexPath.row) else { return }
        
        let editViewController: EditViewController = {
            let viewController = EditViewController(data: data, writeMode: .edit, tableView: tableView, indexPath: indexPath)
            viewController.modalPresentationStyle = .formSheet
            viewController.delegate = self
            
            return viewController
        }()
        
        let navigationController: UINavigationController = UINavigationController(rootViewController: editViewController)
        tableView.deselectRow(at: indexPath, animated: true)
        present(navigationController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction: UIContextualAction = UIContextualAction(style: .destructive, title: "Delete", handler: { [weak self] (action, view, completionHandler) in
            
            self?.cellViewModel.removeData(tableView: tableView, index: indexPath.row)
            
            switch tableView.tag {
            case TableViewTag.todo.tag:
                self?.todoTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.doing.tag:
                self?.doingTableView.deleteRows(at: [indexPath], with: .automatic)
            case TableViewTag.done.tag:
                self?.doneTableView.deleteRows(at: [indexPath], with: .automatic)
            default:
                print("swipe error")
            }
            
        })
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

extension RootViewController: EditViewControllerDelegate {
    func updateCell(data: TextDataModel, writeMode: WriteMode, tableView: UITableView, indexPath: IndexPath?) {
        
        switch writeMode {
        case .new:
            let todoIndexPath: IndexPath = IndexPath(row: cellViewModel.getNumberOfData(in: tableView), section: 0)
            cellViewModel.appendData(tableView: tableView, data: data)
            todoTableView.insertRows(at: [todoIndexPath], with: .automatic)
        case .edit:
            guard let indexPath = indexPath else { return }
            cellViewModel.changeData(tableView: tableView, index: indexPath.row, data: data)
            
            switch tableView.tag {
            case TableViewTag.todo.tag:
                todoTableView.reloadRows(at: [indexPath], with: .automatic)
            case TableViewTag.doing.tag:
                doingTableView.reloadRows(at: [indexPath], with: .automatic)
            case TableViewTag.done.tag:
                doneTableView.reloadRows(at: [indexPath], with: .automatic)
            default:
                print("delegate tag error")
                return
            }
        }
    }
}
