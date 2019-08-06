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
    let topViewModel = TopViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }
    
    func initialization() {
        taskNameTextField.delegate = self
        self.parent?.title = "TaskRTA"
        self.parent?.navigationController?.navigationBar.barTintColor = UIColor(red: 0.59, green: 0.67, blue: 0.39, alpha: 1)
        self.parent?.navigationController?.navigationBar.titleTextAttributes
            = [
                .foregroundColor: UIColor.white,
                .font: UIFont(name: "Futura", size: 20)!
        ]

    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        if taskNameTextField.text != "" {
            // self.tabBarController?.selectedIndex = 1
            showCountdownView()
        } else {
            showAlart(title: "Please enter task name", message: "")
        }
    }
    
    func showCountdownView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let countdownViewController = storyboard.instantiateViewController(withIdentifier: "CountdownView") as! CountdownViewController
        
        let taskName = taskNameTextField.text!
        let timeMinutes = Int(countdownDatePicker.countDownDuration)
        countdownViewController.setTaskName(taskName: taskName)
        countdownViewController.setCountdownTime(timeMinutes: timeMinutes)
        // partial ページめくり的な，coverVertical 下から上がってくる，crossDissolve ふわっと入れ替わる，flipHorizontal 画面がクルッと180度回る
        countdownViewController.modalTransitionStyle = UIModalTransitionStyle.crossDissolve // アニメーション
        self.present(countdownViewController, animated: true, completion: nil)
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
