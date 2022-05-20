//
//  ViewController.swift
//  WhatsDoingToday
//
//  Created by Георгий Маркарян on 16.05.2022.
//

import UIKit
import CoreData

class ToDoViewController: UIViewController {

    private var managedObjectContext: NSManagedObjectContext?
    private let notificationCenter = NotificationCenter.default
    private var index: Int?

    private var tasks: [Task] = []

    private lazy var describeView: DescribeView = {
        let describeView = DescribeView()
        describeView.translatesAutoresizingMaskIntoConstraints = false
        describeView.alpha = 0
        return describeView
    }()

    private lazy var underView: UIView = {
        let underView = UIView()
        underView.translatesAutoresizingMaskIntoConstraints = false
        underView.alpha = 0
        underView.backgroundColor = UIColor("#d1d4da")
        return underView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor("#292a30")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ToDoTableViewCell.self, forCellReuseIdentifier: ToDoTableViewCell.identifier)
        return tableView
    }()

    private var addTaskButton: UIButton = {
        let addTaskButton = UIButton()
        addTaskButton.translatesAutoresizingMaskIntoConstraints = false
        addTaskButton.setImage(UIImage(systemName: "plus.circle"), for: UIControl.State.normal)
        addTaskButton.addTarget(self, action: #selector(addTaskButtonAction), for: .touchUpInside)
        return addTaskButton
    }()

    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

    func saveTask(withTitle title:String, _ description: String = "") {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Task",
                                                      in: context) else { return }
        let taskObject = Task(entity: entity, insertInto: context)
        taskObject.title = title
        taskObject.descriptionTask = description
        do {
            try context.save()
            tasks.append(taskObject)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    private func updateContext() {
        let context = getContext()

        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    private func getTasks(){
        let context = getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "isDone", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            tasks = try context.fetch(fetchRequest)

        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    private func removeTask(_ task: Task){
        let context = self.getContext()
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        if let objects = try? context.fetch(fetchRequest){
            for object in objects {
                if object == task{
                    context.delete(object)
                }
            }
        }
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        getTasks()
        setupGestures()
        view.backgroundColor = UIColor("#292a30")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        getTasks()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextObjectsDidChange), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        notificationCenter.removeObserver(self, name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: managedObjectContext)

    }

    @objc private func managedObjectContextObjectsDidChange(notification: NSNotification){
        guard let userInfo = notification.userInfo else { return }

        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            getTasks()
            self.tableView.reloadData()

        }

        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            getTasks()
            tableView.reloadData()
        }

        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            getTasks()
            tableView.reloadData()
        }
    }

    @objc private func addTaskButtonAction(){

        let createVC = CreateTasksViewController()
        present(createVC, animated: true)
    }

    @objc func importantButtonAction( _ button: UIButton){
        let importantButton = button.tag
        if tasks[importantButton].isImportant{
            tasks[importantButton].isImportant = false
            updateContext()
        } else {
            tasks[importantButton].isImportant = true
            updateContext()
        }
    }

    @objc func descriptionButtonAction( _ button: UIButton){
        let descriptionButton = button.tag
        if tasks[descriptionButton].isReadingDescription{
            tasks[descriptionButton].isReadingDescription = false
            describeView.alpha = 0
            underView.alpha = 0
            updateContext()
        } else {
            tasks[descriptionButton].isReadingDescription = true
            describeView.descriptionTextView.text =  tasks[descriptionButton].descriptionTask
            describeView.taskLabel.text =  tasks[descriptionButton].title
            index = button.tag
            describeView.alpha = 1
            underView.alpha = 0.75
            updateContext()
        }
    }

    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        underView.addGestureRecognizer(tapGesture)
    }

    @objc private func tapAction() {
        describeView.alpha = 0
        underView.alpha = 0
        tasks[index!].isReadingDescription = false
        updateContext()
    }

    private func layout() {
        view.addSubview(tableView)
        view.addSubview(addTaskButton)
        view.addSubview(underView)
        view.addSubview(describeView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            describeView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            describeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),

            underView.topAnchor.constraint(equalTo: view.topAnchor),
            underView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            underView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            underView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

}
// MARK: - UITableViewDataSourse

extension ToDoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoTableViewCell.identifier, for: indexPath) as! ToDoTableViewCell //
        cell.backgroundColor = UIColor("#292a30")
        cell.setupCell(tasks[indexPath.row])
        cell.importantButton.addTarget(self, action: #selector(importantButtonAction), for: .touchUpInside)
        cell.importantButton.tag = indexPath.row
        cell.descriptionButton.addTarget(self, action: #selector(descriptionButtonAction), for: .touchUpInside)
        cell.descriptionButton.tag = indexPath.row
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ToDoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = tasks[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_  in
            self.tasks.removeAll(where: {$0 == task })
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self.removeTask(task)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeActions
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tasks[indexPath.row].isDone{
            tasks[indexPath.row].isDone = false
        } else {
            tasks[indexPath.row].isDone = true
        }
        updateContext()
    }
}

