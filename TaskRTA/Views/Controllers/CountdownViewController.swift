//
//  CountdonwViewController
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//


import RxCocoa
import RxSwift
import UIKit
import Charts

class CountdownViewController: CommonViewController {
    
    @IBOutlet weak var countdownPieChartView: PieChartView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    @IBOutlet weak var progressRateLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    
    let presenter = CountdownPresenter()
    let uiFeedBack = UIFeedbackService.shared
    let disposeBag = DisposeBag()
    var touchProgressSliderFlag = BehaviorRelay<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        ignitionStream()
    }
    
    func initialization() {
        self.navigationItem.hidesBackButton = true
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
        presenter.attachView(self)
    }
    
    func ignitionStream() {
        // Stream
        let finishButtonTouchDown = finishButton.rx.controlEvent(.touchDown)
        let finishButtonTapped = finishButton.rx.tap
        let progressSliderChanged = progressSlider.rx.controlEvent(.valueChanged)
        let progressValue = progressSlider.rx.value
        
        // UI
        finishButtonTouchDown
            .subscribe(onNext: { [weak self] _ in
                self?.uiFeedBack.impact(style: .medium)
            }).disposed(by: disposeBag)
        
        finishButtonTapped.withLatestFrom(progressValue)
            .map { $0
        }
        .subscribe({ [weak self] value in
            self?.uiFeedBack.impact(style: .light)
            self?.presenter.taskFinish(progress: value.element!)
            self?.navigationController?.popViewController(animated: true)
        })
            .disposed(by: disposeBag)
        
        progressSliderChanged.withLatestFrom(progressValue)
            .map { Int(round($0 * 100))
        }.do(onNext: { [weak self] _ in
            self?.touchProgressSliderFlag.accept(true)
        })
            .map { "Progress".localized + ": \($0) %" }
            .bind(to: progressRateLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

extension CountdownViewController: CountdownView {
    
    func setTaskName(_ name: String) {
        taskNameLabel.text = name
    }
    
    func updateCountdownTime(startDate: Date, targetDate: Date) {
        // 各時刻の算出
        let now = Date()
        let countdownTime = Int(ceil(targetDate.timeIntervalSince(now)))
        let unsignedCountdownTime = abs(countdownTime)
        let cd_hour = Int(floor(Double(unsignedCountdownTime) / 3600.0))
        let cd_minute = Int(floor(Double(unsignedCountdownTime % 3600) / 60.0))
        let cd_second = Int(Double(unsignedCountdownTime % 60))
        
        var countdownTimeStr = ""
        if (cd_hour == 0) {
            countdownTimeStr = String(format: "%02d:%02d", cd_minute, cd_second)
        } else {
            countdownTimeStr = String(format: "%02d:%02d:%02d", cd_hour, cd_minute, cd_second)
        }
        
        let countupTime = now.timeIntervalSince(startDate)
        let cu_hour = Int(floor(countupTime / 3600.0))
        let cu_minute = Int(floor(Double(Int(countupTime) % 3600 / 60)))
        let cu_second = Int(countupTime) % 60
        var countupTimeStr = ""
        if (cu_hour == 0) {
            countupTimeStr = String(format: "%02d:%02d", cu_minute, cu_second)
        } else {
            countupTimeStr = String(format: "%02d:%02d:%02d", cu_hour, cu_minute, cu_second)
        }
        
        // グラフ関連
        var value = countupTime * 100.0 / targetDate.timeIntervalSince(startDate)
        var cdTextColor = UIColor.darkGray // 基本カラー
        var cdFontSize = 24
        if (cd_hour == 0) {
            cdFontSize = 28
        }
        if (countdownTime <= 0) {
            cdTextColor = .red
            value = 100
        }
        let dataEntries = [
            PieChartDataEntry(value: value, label: ""),
            PieChartDataEntry(value: 100 - value, label: ""),
        ]
        
        let dataSet = PieChartDataSet(entries: dataEntries, label: "")
        dataSet.colors = [UIColor(red: 0.57, green: 0.68, blue: 0.35, alpha: 1), UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)]
        dataSet.valueTextColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0) // グラフのデータの値の色
        dataSet.entryLabelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0) // グラフのデータのタイトルの色
        self.countdownPieChartView.data = PieChartData(dataSet: dataSet)
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: countdownTimeStr + "\n" + countupTimeStr)
        
        centerText.setAttributes([
            .foregroundColor: cdTextColor,
            .font : UIFont(name: "Futura", size: CGFloat(cdFontSize))!,
            .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: countdownTimeStr.count))
        centerText.setAttributes([
            .foregroundColor: UIColor.darkGray,
            .font : UIFont(name: "Futura", size: 16)!,
            .paragraphStyle : paragraphStyle], range: NSRange(location: countdownTimeStr.count, length: countupTimeStr.count + 1
        ))
        countdownPieChartView.centerAttributedText = centerText
        if (touchProgressSliderFlag.value != true) {
            progressSlider.value = Float(value / 100.0)
            progressRateLabel.text = "Progress".localized + ": \(Int(value)) %"
        }
    }
}

