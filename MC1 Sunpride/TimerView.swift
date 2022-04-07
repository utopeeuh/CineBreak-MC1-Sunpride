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
    var isPlaying: Bool = false
    var initialTime: Int32 = 10
    var currentTime: Int32 = 10
    var timer: Timer!
    
    @IBOutlet weak var timerLogo: UIImageView!
    @IBOutlet weak var labelMinute: UILabel!
    @IBOutlet weak var labelSecond: UILabel!
    @IBOutlet weak var buttonTimer: UIButton!
    
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
    
    func setup()
    {
        let viewFromXib = Bundle.main.loadNibNamed("TimerView", owner: self, options: nil)![0] as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
        updateLabel()
        
        let center = self.center
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: 140, y: 140),
            radius: 138,
            startAngle: -CGFloat.pi / 2.0,
            endAngle: CGFloat.pi * 2.0,
            clockwise: true
        )
        
        // progression layer
        
        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor   = UIColor.clear.cgColor
        shapeLayer.lineWidth   = 25
        shapeLayer.strokeEnd   = 0
        shapeLayer.lineCap     = .round
        
        // track layer
        let trackLayer = CAShapeLayer()
        
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.darkGray.cgColor
        trackLayer.fillColor   = UIColor.clear.cgColor
        trackLayer.lineWidth   = 25
        trackLayer.lineCap     = .round
        
        self.layer.addSublayer(trackLayer)
        self.layer.addSublayer(shapeLayer)
    }
    
    @IBAction func onTimerButton(_ sender: Any)
    {
        isPlaying = !isPlaying
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
            timerLogo.image = UIImage(named: "stop.fill")
            animation.fromValue = 0
            animation.toValue   = 1
            animation.duration  = Double(initialTime)
            animation.fillMode  = CAMediaTimingFillMode.both
        }
        else
        {
            timer.invalidate()
            timerLogo.image = UIImage(named: "play.fill")
            animation.fromValue = Double(initialTime - currentTime) / Double(initialTime)
            animation.toValue   = 0
            animation.duration  = Double(initialTime - currentTime) / Double(initialTime)
            animation.fillMode  = CAMediaTimingFillMode.backwards
            currentTime = initialTime
            updateLabel()
        }
        shapeLayer.add(animation, forKey: "animateStroke")
    }
    
    @objc func onCountdown()
    {
        currentTime -= 1
        if (currentTime == 0) { timer.invalidate() }
        updateLabel()
    }
    
    func updateLabel()
    {
        labelMinute.text = String(format: "%02d", Int(currentTime / 60))
        labelSecond.text = String(format: "%02d", Int(currentTime % 60))
    }
}
