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
    @IBOutlet weak var countdonwLabel: UILabel!
    @IBOutlet weak var progressSlider: UISlider!
    
    private var taskName: String!
    private var countdownTime: Int! // 単位：1分
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func completeButtonTapped(_ sender: Any) {
        
    }
    
    func setTaskName(taskName: String) {
        self.taskName = taskName
    }
    
    func setCountdownTime(timeMinutes: Int) {
        self.countdownTime = timeMinutes
    }
    
    
    
}

