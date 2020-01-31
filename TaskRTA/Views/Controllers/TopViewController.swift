//
//  TopViewController.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class TopViewController: CommonViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var countdownDatePicker: UIDatePicker!
    @IBOutlet weak var finishTimeLabel: UILabel!
    fileprivate let presenter = TopPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
        presenter.attachView(self)
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
    }
    
    @IBAction func countdownDatePickerChanged(_ sender: Any) {
        var date = Date()
        let timeInterval = countdownDatePicker.countDownDuration
        date.addTimeInterval(timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        finishTimeLabel.text = formatter.string(from: date)
    }
    
    @IBAction func startButtonTouchDown(_ sender: Any) {
        presenter.uiFeedBack.impact(style: .medium)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        presenter.uiFeedBack.impact(style: .light)
        if taskNameTextField.text != "" {
            let taskName = taskNameTextField.text!
            let timeMinutes = countdownDatePicker.countDownDuration
            let targetDate = Date(timeInterval: timeMinutes, since: Date())
            presenter.makeTask(taskName: taskName, targetDate: targetDate)
        } else {
            showAlart(title: "Please enter task name", message: "")
        }
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
