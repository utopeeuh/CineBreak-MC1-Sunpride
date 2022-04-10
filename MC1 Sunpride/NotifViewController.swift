//
//  ViewController.swift
//  MC1-Sunpride
//
//  Created by Nikita Felicia on 06/04/22.
//

import UIKit

struct Section{
    let title: String
    let options: [NotificationOptionType]
}

enum NotificationOptionType {
    case switchNotifCell(model: SwitchNotifOption)
                
}

struct SwitchNotifOption{
    let title: String
    let handler: (() ->Void)
    let isOn: Bool
}

extension UIColor {
//    static let iconColor: UIColor = UIColor(named: "iconColor")!
    static let backgroundColor: UIColor = UIColor(named: "backgroundColor")!
    static let blackColor: UIColor = UIColor(named: "blackColor")!
    static let whiteColor: UIColor = UIColor(named: "whiteColor")!
    static let orangeColor: UIColor = UIColor(named: "orangeColor")!
    static let greyColor: UIColor = UIColor(named: "greyColor")!
}

class NotifViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(SwitchNotifTableViewCell.self,
                       forCellReuseIdentifier: SwitchNotifTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        title = "Notification"
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            tableView.backgroundColor = UIColor.backgroundColor
            tableView.separatorColor = UIColor.whiteColor
    }
    
    func configure(){
        models.append(Section(title: "General", options: [
        
            .switchNotifCell(model: SwitchNotifOption(title: "Break Notification", handler: {
                
            }, isOn: true)),
        
            .switchNotifCell(model: SwitchNotifOption(title: "Vibrate", handler: {
                    
            }, isOn: true)),
      
            .switchNotifCell(model: SwitchNotifOption(title: "Overtime", handler: {
                        
            }, isOn: false))
        ]))

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .switchNotifCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: SwitchNotifTableViewCell.identifier,
                for: indexPath
            ) as? SwitchNotifTableViewCell else {
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
        case .switchNotifCell(let model):
            model.handler()

        }
    }
    
}
