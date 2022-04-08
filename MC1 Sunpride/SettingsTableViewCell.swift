//
//  SettingsTableViewCell.swift
//  MC1-Sunpride
//
//  Created by Nikita Felicia on 05/04/22.
//

import Foundation
import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
   
    
    private let iconContainer: UIView = {
        let view = UIView()
        //let disView = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        accessoryView = UIImageView(image: UIImage(systemName: "chevron.right"))
        accessoryView?.tintColor = UIColor.whiteColor
        backgroundColor = UIColor.greyColor
        
    //iconImageView.separatorColor = UIColor.white
       //contentView.separatorColor = UIColor.whiteColor
        //Value of type 'UIView' has no member 'separatorColor'
        

    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
    
//        let size: CGFloat = contentView.frame.size.height - 12
//        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize = size/1.8
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        iconImageView.center = iconContainer.center
        
//        let imageSize = size/1.5
//        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
//        iconImageView.center = iconContainer.center
        
        label.frame = CGRect(x: 25 + iconContainer.frame.size.width,
                             y: 0,
                             width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
                             height: contentView.frame.size.height
        
      

        )
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        let size: CGFloat = contentView.frame.size.height - 12
//        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
//
//        let imageSize = size/1.5
//        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
//        iconImageView.center = iconContainer.center
//
//        label.frame = CGRect(x: 25 + iconContainer.frame.size.width,
//                             y: 0,
//                             width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
//                             height: contentView.frame.size.height
//
//
//        )
//
//   }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
        
    }
    
    public func configure(with model: SettingsOption){

        label.text = model.title
        label.textColor = UIColor.whiteColor
        //label.separatorColor = UIColor.systemBlue
        iconImageView.image = model.icon
    //iconImageView.separatorColor = model.iconBackgroundColor
        //iconContainer.separatorColor = model.iconBackgroundColor
        iconContainer.backgroundColor = model.iconBackgroundColor
    }
}
