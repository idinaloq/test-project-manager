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
    private let tableViewTag: Int
    private let indexPath: IndexPath?
    private var isEditable = false
    var delegate: EditViewControllerDelegate?
    
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
    
    init(textData: TextData, writeMode: WriteMode, tableViewTag: Int, indexPath: IndexPath?) {
        self.textData = textData
        self.writeMode = writeMode
        self.tableViewTag = tableViewTag
        self.indexPath = indexPath
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureDatePicker()
        configureLayout()
        configureTextData()
        check(mode: writeMode)
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        bodyTextView.delegate = self
        titleTextField.delegate = self
        view.addSubview(titleTextField)
        view.addSubview(datePicker)
        view.addSubview(bodyTextView)
    }
    
    private func configureTextData() {
        titleTextField.text = textData.title
        bodyTextView.text = textData.body
        guard let date = textData.deadline else {
            return
        }
        datePicker.date = date
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
        textData.deadline = datePicker.date
    }
    
    private func configureNavigation() {
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(touchUpDoneButton))
        navigationItem.rightBarButtonItem = doneButton
        switch tableViewTag {
        case TableViewTag.todo.tag:
            navigationItem.title = "TODO"
        case TableViewTag.doing.tag:
            navigationItem.title = "DOING"
        case TableViewTag.done.tag:
            navigationItem.title = "DONE"
        default:
            navigationItem.title = "navigation title error"
        }
        
        switch writeMode {
        case .edit:
            let cancelButton: UIBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(touchUpEditButton))
            navigationItem.leftBarButtonItem = cancelButton
        case .add:
            let addButton: UIBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(touchUpCancelButton))
            navigationItem.leftBarButtonItem = addButton
        }
    }
    
    @objc private func touchUpDoneButton() { // 메모가 없는 경우 얼럿으로 표시하기
        if textData.deadline == nil {
            textData.deadline = Date()
        }
        
        guard textData.title != "", textData.body != "" else {
            dismiss(animated: true)
            return
        }
        
        delegate?.updateCell(textData: textData, writeMode: writeMode, tableViewTag: tableViewTag, indexPath: indexPath)
        dismiss(animated: true)
    }
    
    @objc private func touchUpEditButton() {
        toggleEditable()
    }
    
    @objc private func touchUpCancelButton() {
        dismiss(animated: true)
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
    
    private func toggleEditable() {
        if isEditable {
            titleTextField.isEnabled = false
            bodyTextView.isEditable = false
            datePicker.isEnabled = false
            isEditable = false
        } else {
            titleTextField.isEnabled = true
            bodyTextView.isEditable = true
            datePicker.isEnabled = true
            isEditable = true
        }
    }
    
    private func check(mode: WriteMode) {
        switch mode {
        case .add:
            titleTextField.isEnabled = true
            bodyTextView.isEditable = true
            datePicker.isEnabled = true
        case .edit:
            titleTextField.isEnabled = false
            bodyTextView.isEditable = false
            datePicker.isEnabled = false
        }
    }
}

extension EditViewController: UITextFieldDelegate, UITextViewDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        let trimWhiteSpace = textField.text
        let text = trimWhiteSpace?.trimmingCharacters(in: .whitespaces)
        textData.title = text
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let trimWhiteSpace = textView.text
        let text = trimWhiteSpace?.trimmingCharacters(in: .whitespaces)
        textData.body = text
    }
}

protocol EditViewControllerDelegate: AnyObject {
    func updateCell(textData: TextData, writeMode: WriteMode, tableViewTag: Int, indexPath: IndexPath?)
}
