//
//  CountdonwViewController
//  toDO
//
//  Created by Mercury on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class CountdownViewController: UIViewController {
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var countdownLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    
    private var taskName: String!
    private var countdownTime: Int! // 単位：1分
    private var countdownTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    func initialization() {
        taskNameLabel.text = taskName
        updateCountdownTime()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountdownViewController.timerUpdate), userInfo: nil, repeats: true)
    }
    
    @objc func timerUpdate() {
        countdownTime -= 1
        updateCountdownTime()
        if countdownTime == 0 {
            timeup()
        }
    }
    
    func timeup() {
        countdownTimer.invalidate()
        // TODO:バイブレーション
        
    }
    
    func updateCountdownTime() {
        let hour = Int(floor(Double(countdownTime) / 3600.0))
        let minute = Int(floor(Double(countdownTime) / 60.0))
        let second = Int(countdownTime % 60)
        
        var outputTime = ""
        if (hour == 0) {
            outputTime = String(format: "%02d:%02d", minute, second)
        } else {
            outputTime = String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        countdownLabel.text = outputTime
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        
    }
    
    func setTaskName(taskName: String) {
        self.taskName = taskName
    }
    
    func setCountdownTime(timeMinutes: Int) {
        self.countdownTime = timeMinutes
    }
    
    
    
}

