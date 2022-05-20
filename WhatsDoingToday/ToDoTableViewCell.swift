//
//  ToDoTableViewCell.swift
//  WhatsDoingToday
//
//  Created by Георгий Маркарян on 16.05.2022.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor("#292a30")
        return view
    }()
    
    private let insertView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor("#373738")
        return view
    }()
    
    let doneView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor("#292a30")
        view.alpha = 0
        return view
    }()
    
    
    let importantButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "flag"), for: UIControl.State.normal)
        return $0
    }(UIButton())

    let descriptionButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "bubble.right"), for: UIControl.State.normal)
        return $0
    }(UIButton())
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "nameLabel"
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        customizeCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell(_ model: Task) {
        nameLabel.text = model.title
        if model.isImportant {
            importantButton.setImage(UIImage(systemName: "flag.fill"), for: UIControl.State.normal)
            insertView.layer.borderColor = UIColor.red.cgColor
        } else{
            importantButton.setImage(UIImage(systemName: "flag"), for: UIControl.State.normal)
            insertView.layer.borderColor = UIColor.black.cgColor
        }
        if model.isDone{
            doneView.alpha = 1
        } else {
            doneView.alpha = 0
        }
        if model.isReadingDescription{
            descriptionButton.setImage(UIImage(systemName: "bubble.right.fill"), for: UIControl.State.normal)
        } else {
            descriptionButton.setImage(UIImage(systemName: "bubble.right"), for: UIControl.State.normal)
        }
    }
    
    private func customizeCell() {
        insertView.layer.cornerRadius = 10
        insertView.layer.borderWidth = 2
        insertView.layer.borderColor = UIColor.black.cgColor
    }
    
    private func layout() {
        [cellView, insertView, doneView, nameLabel, importantButton, descriptionButton].forEach { contentView.addSubview($0) }
        
        let viewInset: CGFloat = 8
        let inset: CGFloat = 10
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            insertView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: viewInset),
            insertView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: viewInset),
            insertView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -viewInset),
            insertView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewInset)
        ])
        
        NSLayoutConstraint.activate([
            importantButton.topAnchor.constraint(equalTo: insertView.topAnchor, constant: viewInset),
            importantButton.trailingAnchor.constraint(equalTo: insertView.trailingAnchor, constant: -viewInset),
            importantButton.centerYAnchor.constraint(equalTo: insertView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            descriptionButton.topAnchor.constraint(equalTo: insertView.topAnchor, constant: viewInset),
            descriptionButton.trailingAnchor.constraint(equalTo: importantButton.leadingAnchor, constant: -viewInset),
            descriptionButton.centerYAnchor.constraint(equalTo: insertView.centerYAnchor)
        ])

        NSLayoutConstraint.activate([
            doneView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: viewInset),
            doneView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: viewInset),
            doneView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -viewInset),
            doneView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -viewInset)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: insertView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: insertView.leadingAnchor, constant: inset),
            nameLabel.trailingAnchor.constraint(equalTo: insertView.trailingAnchor, constant: -inset),
        ])
    }
    
}
