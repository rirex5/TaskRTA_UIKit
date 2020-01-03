//
//  TopViewController.swift
//  TaskRTA
//
//  Created by Mercury on 2019/07/23.
//  Copyright © 2019 Rirex. All rights reserved.
//

import UIKit

class TopViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var countdownDatePicker: UIDatePicker!
    @IBOutlet weak var finishTimeLabel: UILabel!
    
    let viewModel = TopViewModel()
    let uiFeedBack = UIFeedbackService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
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
        if (viewModel.readRunningTask() != nil) {
            showCountdownView()
        }
    }
    
    @IBAction func countdownDatePickerChanged(_ sender: Any) {
        var date = Date()
        let timeInterval = countdownDatePicker.countDownDuration
        date.addTimeInterval(timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        finishTimeLabel.text = formatter.string(from: date)
        print(date)
    }
    
    @IBAction func startButtonTouchDown(_ sender: Any) {
        uiFeedBack.impact(style: .medium)
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        uiFeedBack.impact(style: .light)
        if taskNameTextField.text != "" {
            makeTask()
            showCountdownView()
        } else {
            showAlart(title: "Please enter task name", message: "")
        }
    }
    
    func makeTask() {
        let taskName = taskNameTextField.text!
        let timeMinutes = countdownDatePicker.countDownDuration
        let now = Date()
        let targetDate = Date(timeInterval: timeMinutes, since: now)
        let task = Task(name: taskName, progress: 0, startDate: now, targetDate: targetDate, finishDate: nil)
        viewModel.save(task: task)
    }
    
    func showCountdownView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let countdownViewController = storyboard.instantiateViewController(withIdentifier: "CountdownView") as! CountdownViewController
        self.parent?.navigationController?.show(countdownViewController, sender: nil)
    }
    
    func showAlart(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
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
