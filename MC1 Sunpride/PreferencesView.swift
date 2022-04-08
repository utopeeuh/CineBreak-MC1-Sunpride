//
//  PreferencesView.swift
//  UserPreferenceSetting
//
//  Created by Wilbert Devin Wijaya on 08/04/22.
//

import Foundation
import UIKit

struct Section {
    let title: String
    let options: [SettingsOption]
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() -> Void)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SettingsTableViewCell.self, forCellReuseIdentifier: SettingsTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        title = "User Preferences"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    func configure(){
        models.append(Section(title: "  ", options: [
            SettingsOption(title: "Sleep Time", icon: UIImage(systemName: "bed.double"), iconBackgroundColor: UIColor(named: "CustomIconBG")!) {
                print("Tapped First Cell")
            },
        
            SettingsOption(title: "Watch Time", icon: UIImage(systemName: "clock"), iconBackgroundColor: UIColor(named: "CustomIconBG")!) {
                
            },
/*            SettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemGreen) {
                
            },
            SettingsOption(title: "iCloud", icon: UIImage(systemName: "cloud"), iconBackgroundColor: .systemOrange) {
                
            },
        ]))
        models.append(Section(title: "Information", options: [
            SettingsOption(title: "Wifi", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink) {
                
            },
            SettingsOption(title: "Bluetooth", icon: UIImage(systemName: "bluetooth"), iconBackgroundColor: .link) {
                
            },
            SettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemGreen) {
                
            },
            SettingsOption(title: "iCloud", icon: UIImage(systemName: "cloud"), iconBackgroundColor: .systemOrange) {
                
            },
        ]))
        models.append(Section(title: "Apps", options: [
            SettingsOption(title: "Wifi", icon: UIImage(systemName: "house"), iconBackgroundColor: .systemPink) {
                
            },
            SettingsOption(title: "Bluetooth", icon: UIImage(systemName: "bluetooth"), iconBackgroundColor: .link) {
                
            },
            SettingsOption(title: "Airplane Mode", icon: UIImage(systemName: "airplane"), iconBackgroundColor: .systemGreen) {
                
            },
            SettingsOption(title: "iCloud", icon: UIImage(systemName: "cloud"), iconBackgroundColor: .systemOrange) {
                
            },*/
        ]))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTableViewCell.identifier,
            for: indexPath)
        as? SettingsTableViewCell else{
            return UITableViewCell()
        }
        
        cell.configure(with: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        model.handler()
    }
}

