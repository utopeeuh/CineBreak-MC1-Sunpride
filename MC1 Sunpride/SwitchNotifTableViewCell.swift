//
//  SwitchNotifTableViewCell.swift
//  MC1-Sunpride
//
//  Created by Nikita Felicia on 06/04/22.
//

import UIKit

class SwitchNotifTableViewCell: UITableViewCell {
    static let identifier = "SwitchNotifTableViewCell"
   
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
       
        mySwitch.onTintColor = .orangeColor
        return mySwitch
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(mySwitch)
        contentView.clipsToBounds = true
        
        backgroundColor = UIColor.blackColor
        
        //buat > di settings
        accessoryType = .none
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(
            x: contentView.frame.size.width - mySwitch.frame.size.width - 20,
            y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
            width: mySwitch.frame.size.width,
            height: mySwitch.frame.size.height)
        
        label.frame = CGRect(
            x: 25,
            y: 0,
            width: contentView.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        mySwitch.isOn = false
    }
    
    public func configure(with model: SwitchNotifOption){
        label.text = model.title
        label.textColor = UIColor.whiteColor
        mySwitch.isOn = model.isOn
    }
}
