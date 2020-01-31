//
//  CommonViewController.swift
//  TaskRTA
//
//  Created by Atsushi Otsubo on 2020/02/01.
//  Copyright © 2020 Rirex. All rights reserved.
//

import UIKit

class CommonViewController: UIViewController {
    
    func showAlart(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle:  UIAlertController.Style.alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }

}
