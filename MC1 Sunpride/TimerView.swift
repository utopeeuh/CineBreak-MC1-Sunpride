import Foundation
import UIKit

var sharedStartSessionTime: Date? = nil

@IBDesignable class TimerView: UIView
{
    @IBOutlet var view: UIView!
    
    @IBInspectable var initialTime: UInt = 1 { didSet {
        currentTime = Double(initialTime)
    }}
    @IBInspectable var fillProgress: Bool = true { didSet {
        shapeLayer.strokeEnd = fillProgress ? 0 : 1
    }}
    
    @IBOutlet weak var timerLogo: UIImageView!
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var buttonTimer: UIButton!
    
    var currentTime: Double! { didSet {
        let normalized = currentTime < 0 ? 0 : UInt(currentTime)
        labelMinute?.text = String(format: "%02d", normalized / 60)
        labelSecond?.text = String(format: "%02d", normalized % 60)
        currentTime = Double(normalized)
    }}
    
    var timerPressedTime: Date!
    var isPlaying: Bool  = false
    var startTime: Date!
    var timer: Timer!
    var progressionPath: CGPath!
    var changeStateLock = NSLock()
    let shapeLayer = CAShapeLayer()
    
    var pulse: PulseAnimation!
    var pulse2: PulseAnimation!
    
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
        assert(initialTime != 0)
        
        let bundle = Bundle(for: TimerView.self)
        bundle.loadNibNamed(String(describing: TimerView.self), owner: self, options: nil)
        view.frame = self.bounds
        addSubview(view)
        
        // circular progressing bar arc center relative to button
        let center = CGPoint(
            x: buttonTimer.frame.midX,
            y: buttonTimer.frame.midY
        )
        // path
        let circPath = UIBezierPath(
            arcCenter: center,
            radius: buttonTimer.frame.width / 1.6,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: CGFloat.pi * 1.5,
            clockwise: true
        )
        // progression layer
        shapeLayer.path        = circPath.cgPath
        shapeLayer.strokeColor = UIColor.highlightColor.cgColor
        shapeLayer.fillColor   = UIColor.clear.cgColor
        shapeLayer.lineWidth   = 25
        shapeLayer.lineCap     = .round
        shapeLayer.strokeEnd   = fillProgress ? 0 : 1
        // track layer
        let trackLayer         = CAShapeLayer()
        trackLayer.path        = circPath.cgPath
        trackLayer.strokeColor = CGColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1)
        trackLayer.fillColor   = UIColor.clear.cgColor
        trackLayer.lineWidth   = 25
        trackLayer.lineCap     = .round
        // add track and progression bar as sublayer
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func onTimerButton(_ sender: UIButton)
    {
        if timerPressedTime == nil {
            timerPressedTime = Date()
        }
        
        AppNotification.removeAllNotification()
        
        let startTimerRoutine: () -> Void = { [self] in
            startTimer()
            sharedStartSessionTime = startTime
            AppNotification.sendNotification()
            // pulse animation
            pulse = PulseAnimation(numberOfPulse: Float.infinity, radius: 180, postion: buttonTimer.center)
            pulse.animationDuration = 1.2
            pulse.backgroundColor = UIColor.systemIndigo.cgColor
            // 2nd pulse animation
            pulse2 = PulseAnimation(numberOfPulse: Float.infinity, radius: 165, postion: buttonTimer.center)
            pulse2.animationDuration = 1.2
            pulse2.backgroundColor = UIColor.highlightColor.cgColor
            // show
            layer.insertSublayer(pulse, at: 0)
            layer.insertSublayer(pulse2, at: 1)
        }
        
        Task(priority: .high)
        {
            let status = await AppNotification.getAuthorizationStatus()
            let presented = notificationRequestVC.viewIfLoaded?.window != nil
            if (status != .authorized && !presented)
            {
                notificationRequestVC.modalPresentationStyle = .fullScreen
                let vc = UIApplication.shared.topMostViewController()
                vc?.present(notificationRequestVC, animated: true)
            }
            else { synchronized(changeStateLock)
            {
                isPlaying = !isPlaying
                timerLogo.image = UIImage(named: isPlaying ? "stop.fill" : "play.fill")
                if (isPlaying)
                {
                    setupVC.completionHandler = startTimerRoutine
                    let presented = setupVC.viewIfLoaded?.window != nil
                    if (!presented)
                    {
                        let vc = UIApplication.shared.topMostViewController()
                        vc?.present(setupVC, animated: true)
                    }
                }
                else
                {
                    stopTimer()
                    sharedStartSessionTime = nil
                    
                    pulse.removeFromSuperlayer()
                    pulse2.removeFromSuperlayer()
                    
                    // Input session data
                    createSession(startTime: timerPressedTime)
                    UserPerformance.shared.updateWeeklyStats()
                    timerPressedTime = nil
                }
            }}
        }
    }
    
    public func stopTimer()
    {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fillProgress ? Date().timeIntervalSince(startTime) / Double(initialTime) : currentTime / Double(initialTime)
        animation.toValue   = fillProgress ? 0 : 1
        animation.duration  = 0.2
        animation.fillMode  = .forwards
        shapeLayer.add(animation, forKey: "animateStroke")
        
        currentTime = Double(initialTime)
        timer?.invalidate()
    }
    
    public func startTimer()
    {
        startTime = Date()
        currentTime = Double(initialTime - 1)
        
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(TimerView.onCountdown),
            userInfo: nil,
            repeats: true
        )
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = fillProgress ? 0 : 1
        animation.toValue   = fillProgress ? 1 : 0
        animation.duration  = Double(initialTime)
        animation.fillMode  = .forwards
        animation.isRemovedOnCompletion = false
        shapeLayer.add(animation, forKey: "animateStroke")
    }
    
    @objc func onCountdown()
    {
        synchronized(changeStateLock)
        {
            currentTime = Double(initialTime) + startTime.timeIntervalSinceNow
            if (currentTime <= 0)
            {
                stopTimer()
                DispatchQueue.main.async
                    { AppNotification.onGuideMeAction() }
            }
            else if (UIApplication.shared.applicationState == .background)
            {
                let presented = stretchingVC.viewIfLoaded?.window != nil
                stretchingVC.completionHandler = nil
                if (presented)
                    { stretchingVC.dismiss(animated: false) }
            }
        }
    }
}
