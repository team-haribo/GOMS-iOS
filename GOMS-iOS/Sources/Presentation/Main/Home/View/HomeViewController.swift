//
//  HomeViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import Foundation

class HomeViewController: BaseViewController<HomeViewModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItems()
    }
    
    override func addView() {
        [].forEach {
            
        }
    }
    
    override func setLayout() {
        
    }
}
