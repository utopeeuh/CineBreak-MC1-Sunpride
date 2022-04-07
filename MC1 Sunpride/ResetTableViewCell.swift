//
//  ResetTableViewCell.swift
//  MC1-Sunpride
//
//  Created by Nikita Felicia on 05/04/22.
//

import Foundation
import UIKit

class ResetTableViewCell: UITableViewCell {
    static let identifier = "ResetTableViewCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.clipsToBounds = true
        accessoryType = .none
        backgroundColor = UIColor.greyColor
    }
    
    required init?(coder: NSCoder){
        fatalError()
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            let size: CGFloat = contentView.frame.size.height - 12
        
        label.frame = CGRect(x: 134,
                             y: 0,
                             width: contentView.frame.size.width,
                             height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
    }
    
    public func configure(with model: ResetOption){
        label.text = model.title
        label.textColor = UIColor.systemRed

    }
}
