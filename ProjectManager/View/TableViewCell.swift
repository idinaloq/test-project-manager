//
//  TableViewCell.swift
//  ProjectManager
//
//  Created by idinaloq on 2023/12/05.
//

import UIKit

final class TableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.text = "레이블 텍스트"
        
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "레이블 바디"
        return label
    }()
    
    private let deadLineLabel: UILabel = {
        let label: UILabel = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "레이블 데드라인"
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let bodyStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    private let deadLineStackView: UIStackView = {
        let stackView: UIStackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        configureUI()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        titleStackView.addArrangedSubview(titleLabel)
        bodyStackView.addArrangedSubview(bodyLabel)
        deadLineStackView.addArrangedSubview(deadLineLabel)
        contentView.addSubview(titleStackView)
        contentView.addSubview(bodyStackView)
        contentView.addSubview(deadLineStackView)
    }
    
    private func configureLayout() {
        let height: CGFloat = contentView.frame.height / 3.0
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: bodyStackView.topAnchor),
            titleStackView.heightAnchor.constraint(equalToConstant: height),
            
            bodyStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bodyStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bodyStackView.bottomAnchor.constraint(equalTo: deadLineStackView.topAnchor),
            bodyStackView.heightAnchor.constraint(equalToConstant: height),
            
            deadLineStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            deadLineStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            deadLineStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            deadLineStackView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
