//
//  DescribeView.swift
//  WhatsDoingToday
//
//  Created by Георгий Маркарян on 20.05.2022.
//

import UIKit

class DescribeView: UIView {

    private let describeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var taskLabel: UILabel = {
        let taskLabel = UILabel()
        taskLabel.translatesAutoresizingMaskIntoConstraints = false
        taskLabel.textColor = UIColor("#373738")
        taskLabel.textAlignment = .center
        taskLabel.layer.cornerRadius = 10
        taskLabel.layer.borderWidth = 1.5
        taskLabel.layer.borderColor = UIColor("#373738").cgColor
        return taskLabel
    }()

    lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.textAlignment = .natural
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextView.backgroundColor = UIColor("#373738")
        descriptionTextView.textColor = .white
        return descriptionTextView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout(){
        [describeView, taskLabel, descriptionTextView].forEach {addSubview($0)}

         let insert: CGFloat = 4
        NSLayoutConstraint.activate([
            describeView.topAnchor.constraint(equalTo: topAnchor),
            describeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            describeView.widthAnchor.constraint(equalToConstant: 280),
            describeView.heightAnchor.constraint(equalToConstant: 350),

            taskLabel.topAnchor.constraint(equalTo: describeView.topAnchor, constant: insert),
            taskLabel.leadingAnchor.constraint(equalTo: describeView.leadingAnchor, constant: insert),
            taskLabel.trailingAnchor.constraint(equalTo: describeView.trailingAnchor, constant: -insert),
            taskLabel.heightAnchor.constraint(equalToConstant: 40),

            descriptionTextView.topAnchor.constraint(equalTo: taskLabel.bottomAnchor, constant: insert),
            descriptionTextView.leadingAnchor.constraint(equalTo: describeView.leadingAnchor, constant: insert),
            descriptionTextView.trailingAnchor.constraint(equalTo: describeView.trailingAnchor, constant: -insert),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 240),
            descriptionTextView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)

        ])
    }

}
