//
//  IntroViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/17.
//

import UIKit
import Then
import SnapKit

class IntroViewController: BaseViewController<IntroViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func addView() {
        [].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        
    }


}

