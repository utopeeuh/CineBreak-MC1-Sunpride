import Foundation
import UIKit

struct Section
{
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType
{
    case staticCell(model: SettingNavigationModel)
    case switchCell(model: SettingsSwitchModel)
    case resetCell(model: ResetOption)
}

struct SettingsSwitchModel
{
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let initialState: Bool
    let handler: ((_ sender: UISwitch) -> Void)
}

struct SettingNavigationModel
{
    let title: String
    let icon: UIImage?
    let desc: String?
    let iconBackgroundColor: UIColor
    let handler: ((_ sender: TableNavigationCell) -> Void)
}

struct ResetOption
{
    let title: String
    let handler: ((_ sender: ResetTableViewCell) -> Void)
}
