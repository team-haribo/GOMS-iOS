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
    
    private let logoImage = UIImageView().then {
        $0.image = UIImage(named: "colorLogo.svg")
    }
    
    override func addView() {
        [logoImage].forEach{
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset((bounds.height) / 7.31)
            $0.centerX.equalToSuperview()
        }
    }


}

