//
//  SplashViewController.swift
//  GOMS-iOS
//
//  Created by 신아인 on 2023/08/11.
//  Copyright © 2023 HARIBO. All rights reserved.
//

import UIKit
import SnapKit
import Then

class SplashViewController: UIViewController {
    
    private let textLogo = UILabel().then {
        $0.text = "GOMS"
        $0.font = UIFont.LogoFont(size: 30,family: .Black)
        $0.textColor = .p10
    }
    
    private let iconImage = UIImageView().then {
        $0.image = UIImage(named: "Icon2")
        $0.isHidden = true
        $0.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bg
        addView()
        setLayout()
        startAnimation()
    }
    
    private func addView() {
        [textLogo, iconImage].forEach {
            view.addSubview($0)
        }
    }
    
    private func setLayout() {
        textLogo.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        iconImage.snp.makeConstraints {
            $0.height.equalTo(96)
            $0.bottom.equalTo(textLogo.snp.top)
            $0.leading.trailing.equalToSuperview().inset(131)
        }
    }
    
    private func startAnimation() {
        iconImage.transform = CGAffineTransform(translationX: 0, y: 50)
        iconImage.alpha = 0
        iconImage.isHidden = false
        
        UIView.animate(withDuration: 1.0, delay: 0.5, options: .curveEaseOut, animations: {
            self.iconImage.transform = .identity
            self.iconImage.alpha = 1
        }, completion: nil)
    }
}

