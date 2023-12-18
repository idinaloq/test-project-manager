//
//  EditViewController.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/06.
//

//새로 할 일 작성, 기존 할 일 수정 모두 호환되어야 함
import UIKit

final class EditViewController: UIViewController {
    private let datePicker: UIDatePicker = UIDatePicker()
    private var textData: TextData
    private let writeMode: WriteMode
    private let tableViewTag: TableViewTag
    var delegate: EditViewController?
    
    private let titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = .systemFont(ofSize: 24)
        textField.borderStyle = .roundedRect
        
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 32)
        textView.layer.borderWidth = 1.0
        
        return textView
    }()
    
    init(textData: TextData, writeMode: WriteMode, tableViewTag: TableViewTag) {
        self.textData = textData
        self.writeMode = writeMode
        self.tableViewTag = tableViewTag
        super.init(nibName: nil, bundle: nil)
    }
    
//    init(writeMode: WriteMode) {
//        self.writeMode = writeMode
//        super.init(nibName: nil, bundle: nil)
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureDatePicker()
        configureLayout()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        bodyTextView.delegate = self
        titleTextField.delegate = self
        view.addSubview(titleTextField)
        view.addSubview(datePicker)
        view.addSubview(bodyTextView)
    }
    
    private func configureDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "ko-KR")
        datePicker.timeZone = .autoupdatingCurrent
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(selectDatePicker), for: .allEvents)
    }
    
    @objc private func selectDatePicker() {
        
    }
    
    private func configureNavigation() {
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(touchUpDoneButton))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "타이틀" //해당부분 TODO, DOING, DONE으로 변경이 가능해야 함
        
        switch writeMode {
        case .edit:
            let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(touchUpEditButton))
            navigationItem.leftBarButtonItem = cancelButton
        case .add:
            let addButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(touchUpCancelButton))
            navigationItem.leftBarButtonItem = addButton
        }
    }
    
    @objc private func touchUpDoneButton() {
        
    }
    
    @objc private func touchUpEditButton() {
        
    }
    
    @objc private func touchUpCancelButton() {
        dismiss(animated: true)
        print(textData)
    }

    private func configureLayout() {
        NSLayoutConstraint.activate([
            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            titleTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            titleTextField.heightAnchor.constraint(equalToConstant: 64),
            
            datePicker.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            datePicker.bottomAnchor.constraint(equalTo: bodyTextView.topAnchor, constant: -8),
            
            bodyTextView.heightAnchor.constraint(equalToConstant: 300),
            bodyTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            bodyTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            bodyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
}

extension EditViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textData.title = textField.text
        print(textData.title as Any)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textData.body = textView.text
        print(textData.body as Any)
    }
}

protocol EditViewControllerDelegate: AnyObject {
    func getData(textData: TextData, writeMode: WriteMode, tableViewTag: TableViewTag)
}
