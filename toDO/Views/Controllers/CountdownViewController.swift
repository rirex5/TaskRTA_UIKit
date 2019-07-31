//
//  CountdonwViewController
//  toDO
//
//  Created by Mercury on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit
import Charts

class CountdownViewController: UIViewController {
    
    @IBOutlet weak var countdownPieChartView: PieChartView!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var progressRateLabel: UILabel!
    
    var taskName: String!
    var countdownTime: Int! // 単位：1秒
    var initialCountdownTime: Int!
    var countdownTimer: Timer!
    let viewModel = CountdownViewModel()
    
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
    
    @IBAction func progressSliderChanged(_ sender: UISlider) {
        let progress = Int(sender.value * 100)
        progressRateLabel.text = "進捗 \(progress) %"
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        taskFinish()
    }
    
    func updateCountdownTime() {
        let hour = Int(floor(Double(countdownTime) / 3600.0))
        let minute = Int(floor(Double(countdownTime % 3600) / 60.0))
        let second = Int(countdownTime % 60)
        
        var outputTime = ""
        if (hour == 0) {
            outputTime = String(format: "%02d:%02d", minute, second)
        } else {
            outputTime = String(format: "%02d:%02d:%02d", hour, minute, second)
        }
        print(outputTime)
        countdownPieChartView.centerText = outputTime
        // グラフに表示するデータのタイトルと値
        let value = Double(initialCountdownTime - countdownTime) * 100.0 / Double(initialCountdownTime)
            // Double(countdownTime / initialCountdownTime) * 100
//        print(initialCountdownTime)
        print(value)
        let dataEntries = [
        
        
            PieChartDataEntry(value: value, label: ""),
            PieChartDataEntry(value: 100 - value, label: ""),
//            PieChartDataEntry(value: 25, label: "C")
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        // グラフの色
        dataSet.colors = ChartColorTemplates.vordiplom()
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor.black
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor.black
        
        self.countdownPieChartView.data = PieChartData(dataSet: dataSet)
        
    }
    
    func timeup() {
        countdownTimer.invalidate()
        let soundService = VibrationService.shared
        soundService.startVibrate(times: 10)
    }
    
    func taskFinish() {
        countdownTimer.invalidate()
        let progress = progressSlider.value
        let task = Task(name: taskName, progress: progress)
        viewModel.save(task: task)
        dismiss(animated: true, completion: nil)
    }
    
    func setTaskName(taskName: String) {
        self.taskName = taskName
    }
    
    func setCountdownTime(timeMinutes: Int) {
        self.countdownTime = timeMinutes
        self.initialCountdownTime = timeMinutes
    }
    
    
    
}

