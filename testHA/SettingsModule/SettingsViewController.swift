//
//  SettingsViewController.swift
//  testHA
//
//  Created by murphy on 26.03.2024.
//
// SettingsViewController.swift
// SettingsViewController.swift
import UIKit

class SettingsViewController: UIViewController {
    var viewModel: SettingsViewModel!
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        // Setup UITableView
        tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)

        // Add "Add" button to the navigation bar
        navigationItem.title = "Settings"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    }

    // Handle "Add" button tap to add a new cell
    @objc func addButtonTapped() {
        let alertController = UIAlertController(title: "Enter Developer's Name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Developer's Name"
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let developerName = alertController.textFields?.first?.text, !developerName.isEmpty else {
                // Handle empty name input
                return
            }
            self?.viewModel.addDeveloper(withName: developerName)
            self?.tableView.reloadData()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableView Delegate & DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section
        return viewModel.numberOfDevelopers
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.developer(at: indexPath.row).name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Handle row selection if needed
    }
}
