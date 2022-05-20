//
//  CreateTasksViewController.swift
//  WhatsDoingToday
//
//  Created by Георгий Маркарян on 17.05.2022.
//

import UIKit

class CreateTasksViewController: UIViewController {
    private let nc = NotificationCenter.default
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = UIColor("#292a30")
        return contentView
    }()
    
    private lazy var taskTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textAlignment = .left
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.delegate = self
        textField.layer.cornerRadius = 10
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.darkGray.cgColor
        textField.attributedPlaceholder = NSAttributedString(string: "Ваша задача.",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textField.textColor = .white
        textField.backgroundColor = UIColor("#373738")
        return textField
    }()

    private lazy var descriptionTextView: UITextView = {
        let descriptionTextView = UITextView()
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.textAlignment = .natural
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.layer.borderWidth = 0.5
        descriptionTextView.layer.borderColor = UIColor.darkGray.cgColor
        descriptionTextView.text = "Здесь можно описать подробнее"
        descriptionTextView.backgroundColor = UIColor("#373738")
        descriptionTextView.textColor = UIColor.lightGray
        descriptionTextView.delegate = self
        return descriptionTextView
    }()
    
    private var categoryButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "list.bullet.circle"), for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(addCategoryButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    let imageDown: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "chevron.down")
        return $0
    }(UIImageView())
    
    
    private var dateButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "calendar.circle"), for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(addDatetButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())

    private var remindButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "alarm"), for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(addRemindButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private var regularButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "repeat.1.circle"), for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(addRepeatButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private var addTaskButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "plus.circle"), for: UIControl.State.normal)
        $0.addTarget(self, action: #selector(addTaskButtonAction), for: .touchUpInside)
        return $0
    }(UIButton())
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor("#262626")
        stackView.distribution = .fillEqually
        stackView.spacing = 0.5
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.darkGray.cgColor
        
        return stackView
    }()
    
    @objc private func addTaskButtonAction(){
        let toDoVC = ToDoViewController()
        if !taskTextField.text!.isEmpty{
            if let newTaskTitle = taskTextField.text{
                if descriptionTextView.text.isEmpty{
                    toDoVC.saveTask(withTitle: newTaskTitle)
                } else {
                    if let newDescription = descriptionTextView.text{
                        toDoVC.saveTask(withTitle: newTaskTitle, newDescription)
                    }
                }
            }
        }
        dismiss( animated: true)
    }

    @objc private func addCategoryButtonAction(){
        categoryButton.setImage(UIImage(systemName: "list.bullet.circle.fill"), for: UIControl.State.normal)
    }
    @objc private func addDatetButtonAction(){
        dateButton.setImage(UIImage(systemName: "calendar.circle.fill"), for: UIControl.State.normal)
    }
    @objc private func addRemindButtonAction(){
        remindButton.setImage(UIImage(systemName: "alarm.fill"), for: UIControl.State.normal)
    }
    @objc private func addRepeatButtonAction(){
        regularButton.setImage(UIImage(systemName: "repeat.1.circle.fill"), for: UIControl.State.normal)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor("#292a30")
        layout()
        setupGestures()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
        nc.addObserver(self, selector: #selector(keyboardShow), name:  UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupGestures() {
        let tapScreen = UITapGestureRecognizer(target: self, action: #selector(tapDismiss))
        tapScreen.cancelsTouchesInView = false
        view.addGestureRecognizer(tapScreen)
        
    }
    @objc private func tapDismiss(){
        view.endEditing(true)
    }
    @objc private func keyboardShow(notification: NSNotification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            contentView.backgroundColor = UIColor("#d1d4da")
            view.backgroundColor = UIColor("#d1d4da")
            scrollView.contentInset.bottom = -keyboardSize.height - 200
        }
    }
    @objc private func keyboardHide(){
        contentView.backgroundColor = UIColor("#292a30")
        view.backgroundColor = UIColor("#292a30")
        scrollView.contentInset = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }

    private func layout(){
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        [categoryButton, regularButton, dateButton, remindButton, addTaskButton].forEach {stackView.addArrangedSubview($0)}
        
        [imageDown, taskTextField, descriptionTextView, stackView].forEach {contentView.addSubview($0)}
        
        
        NSLayoutConstraint.activate([
            imageDown.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageDown.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            taskTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            taskTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            taskTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            taskTextField.heightAnchor.constraint(equalToConstant: 40),
            
            descriptionTextView.topAnchor.constraint(equalTo: taskTextField.bottomAnchor, constant: 10),
            descriptionTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descriptionTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 150),
            descriptionTextView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50),
            
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 50),
            
        ])
    }
}

// MARK: - UITextFieldDelegate
extension CreateTasksViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case taskTextField:
            if range.length + range.location > (textField.text?.count)!{
                return false
            }
            let newLimit = (textField.text?.count)! + string.count - range.length
            return newLimit <= 35
        case descriptionTextView:
            if range.length + range.location > (textField.text?.count)!{
                return false
            }
            let newLimit = (textField.text?.count)! + string.count - range.length
            return newLimit <= 400
        default:
            return false
        }

    }
}

// MARK: - UITextViewDelegate

extension CreateTasksViewController: UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Здесь можно описать подробнее"
            textView.textColor = UIColor.lightGray
        }
    }

}
