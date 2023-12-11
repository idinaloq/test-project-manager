//
//  RootViewController.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/04.
//

import UIKit

class RootViewController: UIViewController {
    private var todoData: [TextData] = []
    private var doingData: [TextData] = []
    private var doneData: [TextData] = []
    
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
        
        return tableView
    }()
    
    private let doingTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewTag.doing.description)
        
        return tableView
    }()
    
    private let doneTableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewTag.done.description)
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureNatigation()
        configureUI()
        configureLayout()
    }
    
    private func configureNatigation() {
        let plusBotton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(touchUpPlusButton))
        navigationItem.rightBarButtonItem = plusBotton
        navigationItem.title = "Project Manager"
    }
    
    @objc private func touchUpPlusButton() {
        let editViewController: EditViewController = EditViewController()
        editViewController.modalPresentationStyle = .formSheet
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createCell(tableView: tableView, indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func createCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        var identifier: String
        
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? TableViewCell else {
            return TableViewCell()
        }

        return cell
    }
}

