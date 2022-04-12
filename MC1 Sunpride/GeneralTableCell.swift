import Foundation
import UIKit

class GeneralTableCell: UITableViewCell
{
    let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.numberOfLines = 1
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(iconImageView)
        contentView.clipsToBounds = true
        backgroundColor = .tableCellColor
    }
    
    required init?(coder: NSCoder) { super.init(coder: coder) }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()

        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
    
        let imageSize = size/1.8
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        iconImageView.center = iconContainer.center
        
        label.frame = CGRect(
            x: 25 + iconContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 20 - iconContainer.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        label.text = nil
        iconImageView.image = nil
        iconContainer.backgroundColor = nil
    }
}
