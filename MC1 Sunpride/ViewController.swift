//
//  ViewController.swift
//  MC1-Sunpride
//
//  Created by Nikita Felicia on 05/04/22.
//

import UIKit

struct Section{
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingsSwitchOption)
    case resetCell(model: ResetOption)
}

struct SettingsSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() ->Void)
    let isOn: Bool
}

struct SettingsOption{
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (() ->Void)
}

struct ResetOption{
    let title: String
    let handler: (() ->Void)
}

extension UIColor {
    static let iconColor: UIColor = UIColor(named: "iconColor")!
    static let backgroundColor: UIColor = UIColor(named: "backgroundColor")!
    static let blackColor: UIColor = UIColor(named: "blackColor")!
    static let whiteColor: UIColor = UIColor(named: "whiteColor")!
    static let orangeColor: UIColor = UIColor(named: "orangeColor")!
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
    
        table.register(SettingsTableViewCell.self,
                       forCellReuseIdentifier: SettingsTableViewCell.identifier)
        table.register(SwitchTableViewCell.self,
                       forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.register(ResetTableViewCell.self,
                       forCellReuseIdentifier: ResetTableViewCell.identifier)
        return table
        
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
            title = "Settings"
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            tableView.backgroundColor = UIColor.backgroundColor
        
    }
  
        func configure(){
                
            models.append(Section(title: "General1", options: [
            
                .staticCell(model: SettingsOption(title: "Message Intensity", icon: UIImage(systemName: "message"), iconBackgroundColor: .iconColor){
            
                        
                }),
                .switchCell(model: SettingsSwitchOption(title: "Vibrate", icon: UIImage(systemName: "speaker.wave.3"), iconBackgroundColor: .iconColor, handler: {
                    
                }, isOn: true))
            
            ]))
            
            models.append(Section(title: "General2", options: [
                .staticCell(model: SettingsOption(title: "Notifications", icon: UIImage(systemName: "bell"), iconBackgroundColor: .iconColor){
                   
                    
                }),
                .staticCell(model: SettingsOption(title: "User Preferences", icon: UIImage(systemName: "gearshape.2"), iconBackgroundColor: .iconColor){
                    
                }),
                .staticCell(model:SettingsOption(title: "Tutorial", icon: UIImage(systemName: "book"), iconBackgroundColor: .iconColor){
                    
                })
            ]))
            
            models.append(Section(title: "General3", options: [
                .resetCell(model: ResetOption(title: "Reset Data"){
                        
                })
            ]))
    }
    
    //judul buat masing2
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let section = models[section]
//        return section.title
//    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsTableViewCell.identifier,
                for: indexPath
    
            ) as? SettingsTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with:model)
            return cell
            
        case .switchCell(let model):
    
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchTableViewCell.identifier,
                for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with:model)
            return cell
            
        case .resetCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ResetTableViewCell.identifier,
                for: indexPath
                
            ) as? ResetTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with:model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
           
        let type = models[indexPath.section].options[indexPath.row]
    
        switch type.self{
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        case .resetCell(let model):
            model.handler()

        }
    }
    
}
