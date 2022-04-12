import Foundation
import UIKit

class TableSwitchCell: GeneralTableCell
{
    public var onChangeValueClosure: (_ sender: UISwitch) -> Void = {(s) in}
    
    let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = UIColor.orange
        return mySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryView = mySwitch
        self.selectionStyle = .none
        mySwitch.addTarget(self, action: #selector(onChangeValue(_:)), for: .valueChanged)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        mySwitch.isOn = false
    }
    
    public func configure(with model: SettingsSwitchModel)
    {
        label.text = model.title
        label.textColor = UIColor.white
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        mySwitch.isOn = model.initialState
    }
    
    @objc func onChangeValue(_ sender: UISwitch)
    {
        onChangeValueClosure(sender)
    }
}

