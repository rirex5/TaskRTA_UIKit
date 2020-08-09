//
//  TopViewController.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopViewController: CommonViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var countdownDatePicker: UIDatePicker!
    @IBOutlet weak var finishTimeLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    private let presenter = TopPresenter()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        ignitionStream()
    }
    
    func initialization() {
        self.parent?.title = "TaskRTA"
        self.parent?.navigationController?.navigationBar.barTintColor = UIColor(red: 0.59, green: 0.67, blue: 0.39, alpha: 1)
        self.parent?.navigationController?.navigationBar.titleTextAttributes
            = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "Futura", size: 20)!
        ]
        taskNameTextField.delegate = self
        taskNameTextField.becomeFirstResponder() // キーボードを開く
        presenter.attachView(self)
    }
    
    func ignitionStream() {
        
        // Stream
        let remainingTime = countdownDatePicker.rx.countDownDuration
            .map { countDownDuration  -> String in
                var date = Date()
                let timeInterval: TimeInterval = countDownDuration
                date.addTimeInterval(timeInterval)
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                return formatter.string(from: date)
        }
        let startButtonTouchDown = startButton.rx.controlEvent(.touchDown)
        let startButtonTapped = startButton.rx.tap
        
        // UI
        remainingTime.bind(to: finishTimeLabel.rx.text)
            .disposed(by: disposeBag)
        
        startButtonTouchDown.subscribe(onNext: { [weak self] _ in
            self?.presenter.uiFeedBack.impact(style: .medium)
            }).disposed(by: disposeBag)
        
        startButtonTapped.subscribe(onNext: { [weak self] _ in
            self?.presenter.uiFeedBack.impact(style: .light)
            if self?.taskNameTextField.text != "" {
                guard let taskName = self?.taskNameTextField.text else { return }
                guard let timeMinutes = self?.countdownDatePicker.countDownDuration else { return }
                let targetDate = Date(timeInterval: timeMinutes, since: Date())
                self?.presenter.makeTask(taskName: taskName, targetDate: targetDate)
            } else {
                self?.showAlart(title: "Please enter task name".localized, message: "")
            }
        }).disposed(by: disposeBag)
        
        
        
    }
}

extension TopViewController: UITextFieldDelegate {
    // To close keyboard by enter button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // To close keyboard by tap
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension TopViewController: TopView {
    func showCountdownView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let countdownViewController = storyboard.instantiateViewController(withIdentifier: "CountdownView") as! CountdownViewController
        self.parent?.navigationController?.show(countdownViewController, sender: nil)
    }
}
