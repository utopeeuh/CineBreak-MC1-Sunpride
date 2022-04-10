//
//  HomeViewController.swift
//  MC1 Sunpride
//
//  Created by Ramadhan Kalih Sewu on 07/04/22.
//

import Foundation
import UIKit

@IBDesignable class TimerView: UIView
{
    @IBInspectable var initialTime: UInt = 1 { didSet {
        currentTime = initialTime
    }}
    @IBInspectable var fillProgress: Bool = true { didSet {
        shapeLayer.strokeEnd = fillProgress ? 0 : 1
    }}
    
    @IBOutlet weak var timerLogo: UIImageView!
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var buttonTimer: UIButton!
    
    var currentTime: UInt! { didSet {
        labelMinute?.text = String(format: "%02d", UInt(currentTime / 60))
        labelSecond?.text = String(format: "%02d", UInt(currentTime % 60))
    }}
    
    var isPlaying: Bool = false
    var timer: Timer!
    var progressionPath: CGPath!
    var changeStateLock = NSLock()
    let shapeLayer = CAShapeLayer()
    
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
        currentTime = initialTime
        let bundle  = Bundle(for: TimerView.self)
        let view    = bundle.loadNibNamed("TimerView", owner: self, options: nil)![0] as! UIView
        view.frame  = self.bounds
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
        shapeLayer.strokeColor = UIColor(named: "colorHighlight")?.cgColor
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
    
    @IBAction func onTimerButton(_ sender: Any)
    {
        synchronized(changeStateLock)
        {
            isPlaying = !isPlaying
            timerLogo.image = UIImage(named: isPlaying ? "stop.fill" : "play.fill")
            
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            if (isPlaying)
            {
                timer = Timer.scheduledTimer(
                    timeInterval: 1.0,
                    target: self,
                    selector: #selector(TimerView.onCountdown),
                    userInfo: nil,
                    repeats: true
                )
                animation.fromValue = fillProgress ? 0 : 1
                animation.toValue   = fillProgress ? 1 : 0
                animation.duration  = Double(initialTime)
                animation.fillMode  = .forwards
            }
            else
            {
                timer.invalidate()
                shapeLayer.removeAllAnimations()
                animation.fromValue = fillProgress ? Double(initialTime - currentTime) / Double(initialTime) : Double(currentTime) / Double(initialTime)
                animation.toValue   = fillProgress ? 0 : 1
                animation.duration  = 0.2
                animation.fillMode  = .forwards
                currentTime = initialTime
            }
            shapeLayer.add(animation, forKey: "animateStroke")
        }
    }
    
    @objc func onCountdown()
    {
        synchronized(changeStateLock)
        {
            currentTime -= 1
            if (currentTime == 0)
            {
                isPlaying = false
                currentTime = initialTime
                timerLogo.image = UIImage(named: "play.fill")
                timer.invalidate()
            }
        }
    }
    
    /// imitates synchronized block in java for multi-thread environment, prevent race condition
    func synchronized(_ lock: Any, closure: () -> Void)
    {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}
