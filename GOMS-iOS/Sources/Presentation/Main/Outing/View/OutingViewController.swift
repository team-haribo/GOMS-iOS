//
//  OutingViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import UIKit
import Then
import SnapKit

class OutingViewController: BaseViewController<OutingViewModel> {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        outingTableView.delegate = self
        outingTableView.dataSource = self
        outingTableView.layer.cornerRadius = 10
        outingTableView.layer.masksToBounds = true
    }
    
    private let outingMainText = UILabel().then {
        $0.text = "외출현황"
        $0.numberOfLines = 3
        $0.font = UIFont.GOMSFont(
            size: 24,
            family: .Bold
        )
        $0.textColor = .black
    }
    
    private let outingTableView = UITableView().then {
        $0.register(OutingTableViewCell.self, forCellReuseIdentifier: "OutingTableViewCell")
        $0.separatorStyle = .none
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
    }
    
    override func addView() {
        [outingMainText, outingTableView].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        outingMainText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 7.73)
            $0.leading.equalToSuperview().offset(26)
        }
        outingTableView.snp.makeConstraints {
            $0.top.equalTo(outingMainText.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(26)
            $0.bottom.equalToSuperview()
        }
    }

}

extension OutingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = outingTableView.dequeueReusableCell(withIdentifier: "OutingTableViewCell", for: indexPath) as! OutingTableViewCell
        cell.userProfile.image = UIImage(named: "userProfile.svg")
        cell.userName.text = "선민재"
        cell.userNum.text = "3학년 1반 11번"
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
