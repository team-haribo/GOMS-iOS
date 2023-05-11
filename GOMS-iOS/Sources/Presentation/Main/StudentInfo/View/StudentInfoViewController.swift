//
//  StudentInfoViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/05/11.
//

import UIKit

class StudentInfoViewController: BaseViewController<StudentInfoViewModel> {

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

}
