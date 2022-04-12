import Foundation
import UIKit

class TableNavigationCell: GeneralTableCell
{
    let disclosureImage: UIImageView = {
        let imgview = UIImageView(image: UIImage(systemName: "chevron.right"))
        imgview.tintColor = .white
        return imgview
    }()
    
    let descLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 230, y: 7, width: 70, height: 30))
        label.textColor = .highlightColor
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryView = disclosureImage
        addSubview(descLabel)
    }
    
    required init?(coder: NSCoder)
    {
        super.init(coder: coder)
    }
    
    public func configure(with model: SettingNavigationModel)
    {
        label.text = model.title
        descLabel.text = model.desc
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
    }
}
