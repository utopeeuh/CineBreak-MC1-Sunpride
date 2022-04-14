import UIKit

class MessageIntensitySetView: UIView
{
    @IBOutlet var view: UIView!
    
    @IBOutlet weak var strongButton: UIButton!
    @IBOutlet weak var normalButton: UIButton!
    @IBOutlet weak var softButton: UIButton!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
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
        let bundle = Bundle(for: MessageIntensitySetView.self)
        bundle.loadNibNamed(String(describing: MessageIntensitySetView.self), owner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
    }
    
    @IBAction func onSetButton(_ sender: Any)
    {
        if (strongButton.isSelected)
            { UserSettings.set(.messageIntensity, MessageIntensity.strong.rawValue) }
        if (normalButton.isSelected)
            { UserSettings.set(.messageIntensity, MessageIntensity.normal.rawValue) }
        if (softButton.isSelected)
            { UserSettings.set(.messageIntensity, MessageIntensity.soft.rawValue) }
        self.removeFromSuperview()
    }
}
