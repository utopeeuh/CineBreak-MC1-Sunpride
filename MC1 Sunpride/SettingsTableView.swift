import Foundation
import UIKit

@IBDesignable class SettingsTableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var models = [Section]()
    
    let iconBgColor: UIColor = .systemIndigo
    
    override init(frame: CGRect, style: UITableView.Style)
    {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
        setup()
    }
    
    override func prepareForInterfaceBuilder() { setup() }
    
    func setup()
    {
        configure()
        self.delegate   = self
        self.dataSource = self
        self.frame      = self.bounds
        
        let cells = [TableNavigationCell.self, TableSwitchCell.self, ResetTableViewCell.self]
        for cell in cells
            { self.register(cell, forCellReuseIdentifier: "\(cell)") }
    }
    
    func configure()
    {
        let msgIntensity = "\(UserSettings.get(.messageIntensity) as! MessageIntensity)".capitalized
        
        models.append(Section(title: "General1", options: [
            .staticCell(model:
                SettingNavigationModel(
                    title: "Message Intensity",
                    icon: UIImage(systemName: "message"),
                    desc: msgIntensity,
                    iconBackgroundColor: .systemIndigo
                ) { (sender) in
                    // on selection handler
            }),
            .switchCell(model:
                SettingsSwitchModel(
                    title: "Vibrate",
                    icon: UIImage(systemName: "speaker.wave.3"),
                    iconBackgroundColor: .systemIndigo,
                    initialState: UserSettings.get(.enableVibrate)! as! Bool
                ) { (sender) in
                    // on selection handler
                    UserSettings.set(.enableVibrate, sender.isOn)
            })
        ]))
        
        models.append(Section(title: "Watch Target", options: [
            .staticCell(model:
                SettingNavigationModel(
                    title: "Sleep Time",
                    icon: UIImage(systemName: "tv.fill"),
                    desc: UserSettings.get(.sleepTime) as? String,
                    iconBackgroundColor: .systemIndigo
                ) { (sender) in
                    // on selection handler
            }),
            .staticCell(model:
                SettingNavigationModel(
                    title: "Watch Duration",
                    icon: UIImage(systemName: "bed.double.fill"),
                    desc: UserSettings.get(.targetWatchDuration) as? String,
                    iconBackgroundColor: .systemIndigo
                ) { (sender) in
                    // on selection handler
            })
        ]))
        
        models.append(Section(title: "Send Notification", options: [
            .switchCell(model:
                SettingsSwitchModel(
                    title: "Breaktime",
                    icon: UIImage(systemName: "speaker.wave.3"),
                    iconBackgroundColor: . systemIndigo,
                    initialState: UserSettings.get(.enableBreaktimeNotification)! as! Bool
                ) { (sender) in
                    // on selection handler
                    UserSettings.set(.enableBreaktimeNotification, sender.isOn)
            }),
            .switchCell(model:
                SettingsSwitchModel(
                    title: "Overtime",
                    icon: UIImage(systemName: "speaker.wave.3"),
                    iconBackgroundColor: . systemIndigo,
                    initialState: UserSettings.get(.enableOvertimeNotification)! as! Bool
                ) { (sender) in
                    // on selection handler
                    UserSettings.set(.enableOvertimeNotification, sender.isOn)
            }),
            .switchCell(model:
                SettingsSwitchModel(
                    title: "Pass Bedtime",
                    icon: UIImage(systemName: "speaker.wave.3"),
                    iconBackgroundColor: . systemIndigo,
                    initialState: UserSettings.get(.enablePassBedtimeNotification)! as! Bool
                ) { (sender) in
                    // on selection handler
                    UserSettings.set(.enablePassBedtimeNotification, sender.isOn)
            })
        ]))
            
        models.append(Section(title: "Tips", options: [
            .staticCell(model:
                SettingNavigationModel(
                    title: "Tutorial",
                    icon: UIImage(systemName: "book"),
                    desc: nil,
                    iconBackgroundColor: .systemIndigo
                ) { (sender) in
                    // on selection handler
            }),
            .staticCell(model:
                SettingNavigationModel(title: "About",
                icon: UIImage(systemName: "info"),
                desc: nil, iconBackgroundColor: .systemIndigo
                ) { (sender) in
                    // on selection handler
            })
        ]))
        
        models.append(Section(title: "General3", options: [
            .resetCell(model: ResetOption(title: "Reset Data") { (sender) in
                // on selection handler
            })
        ]))
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { return models.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return models[section].options.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self
        {
        case .staticCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(TableNavigationCell.self)",
                for: indexPath
            ) as! TableNavigationCell
            cell.configure(with: model)
            return cell
            
        case .switchCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(TableSwitchCell.self)",
                for: indexPath
            ) as! TableSwitchCell
            cell.onChangeValueClosure = model.handler
            cell.configure(with: model)
            return cell
            
        case .resetCell(let model):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "\(ResetTableViewCell.self)",
                for: indexPath
            ) as! ResetTableViewCell
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let type = models[indexPath.section].options[indexPath.row]
        let senderCell = tableView.cellForRow(at: indexPath)!
        
        switch type.self
        {
        case .staticCell(let model):
            model.handler(senderCell as! TableNavigationCell)
            break
        case .resetCell(let model):
            model.handler(senderCell as! ResetTableViewCell)
            break
        case .switchCell(let model):
            break
        }
    }
}
