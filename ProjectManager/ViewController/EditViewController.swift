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
    
    private let titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        textField.placeholder = "Title"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .red
        return textField
    }()
    
    private let bodyTextView: UITextView = {
        let textView: UITextView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .green
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigation()
        configureDatePicker()
        configureLayout()
        
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
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
        datePicker.backgroundColor = .blue
    }
    
    @objc private func selectDatePicker() {
        
    }
    
    private func configureNavigation() {
        let doneButton: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action:#selector( touchUpDoneButton))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.title = "타이틀" //해당부분 TODO, DOING, DONE으로 변경이 가능해야 함
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
    
    @objc private func touchUpEditButton() {
        
    }
    
    @objc private func touchUpCancelButton() {
        
    }
    
    @objc private func touchUpDoneButton() {
        
    }
}
