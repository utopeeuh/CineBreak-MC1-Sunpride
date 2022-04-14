import UIKit

class WatchDurSetView: UIView
{
    @IBOutlet var view: UIView!
    
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
        let bundle = Bundle(for: WatchDurSetView.self)
        bundle.loadNibNamed(String(describing: WatchDurSetView.self), owner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
    }
    
    @IBAction func onSetButton(_ sender: Any)
    {
        self.removeFromSuperview()
    }
}
