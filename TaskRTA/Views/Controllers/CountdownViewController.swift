//
//  CountdonwViewController
//  TaskRTA
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
    var touchProgressSliderFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    func initialization() {
        taskNameLabel.text = taskName
        updateCountdownTime()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(CountdownViewController.timerUpdate), userInfo: nil, repeats: true)
        
        countdownPieChartView.usePercentValuesEnabled = false
        countdownPieChartView.drawSlicesUnderHoleEnabled = false
        countdownPieChartView.holeRadiusPercent = 0.6
        countdownPieChartView.transparentCircleRadiusPercent = 0.1
        countdownPieChartView.chartDescription?.enabled = false
        countdownPieChartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        countdownPieChartView.chartDescription?.enabled = false
        countdownPieChartView.rotationAngle = -90
        countdownPieChartView.rotationEnabled = false
        countdownPieChartView.highlightPerTapEnabled = false
        countdownPieChartView.legend.enabled = false
        countdownPieChartView.holeColor = .white
        
    }
    
    @objc func timerUpdate() {
        countdownTime -= 1
        updateCountdownTime()
        if countdownTime == 0 {
            timeup()
        }
    }
    
    @IBAction func progressSliderChanged(_ sender: UISlider) {
        touchProgressSliderFlag = true
        let progress = Int(sender.value * 100)
        progressRateLabel.text = "Progress \(progress) %"
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
        
        // グラフに表示するデータのタイトルと値
        let value = Double(initialCountdownTime - countdownTime) * 100.0 / Double(initialCountdownTime)
        let dataEntries = [
            PieChartDataEntry(value: value, label: ""),
            PieChartDataEntry(value: 100 - value, label: ""),
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [UIColor(red: 0.57, green: 0.68, blue: 0.35, alpha: 1), UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)]
        
        // グラフの色
        // dataSet.colors = ChartColorTemplates.vordiplom()
        // グラフのデータの値の色
        dataSet.valueTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        // グラフのデータのタイトルの色
        dataSet.entryLabelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        
        self.countdownPieChartView.data = PieChartData(dataSet: dataSet)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: outputTime)
        
        centerText.setAttributes([.font : UIFont(name: "Futura", size: 22)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        countdownPieChartView.centerAttributedText = centerText;
        
        if (touchProgressSliderFlag != true) {
            progressSlider.value = Float(value / 100.0)
            progressRateLabel.text = "Progress \(Int(value)) %"
        }
        
    }
    
    func timeup() {
        countdownTimer.invalidate()
        let soundService = VibrationService.shared
        soundService.startVibrate(times: 60)
    }
    
    func taskFinish() {
        let soundService = VibrationService.shared
        soundService.stopVibrate()
        countdownTimer.invalidate()
        let progress = progressSlider.value
        let now = Date()
        let task = Task(name: taskName, progress: progress, date: now)
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

