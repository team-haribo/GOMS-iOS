import UIKit
import RxFlow
import Kingfisher
import SnapKit
import Then
import RxSwift
import RxCocoa

class ScanViewController: BaseViewController<ScanViewModel> {

    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = true
        super.viewDidLoad()
        bindViewModel()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func bindViewModel() {
        let input = ScanViewModel.Input(
            nextButtonDidTap: nextButton.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
    }
    
    private let successScanImage = UIImageView().then {
        $0.image = UIImage(named: "successScan.svg")
    }
    
    private let successText = UILabel().then {
        $0.text = "QR 스캔 완료!"
        $0.font = UIFont.GOMSFont(size: 35, family: .SemiBold)
        $0.textColor = .black
    }
    
    private var nextButton = UIButton().then {
        $0.backgroundColor = UIColor.mainColor
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .SemiBold)
        $0.layer.cornerRadius = 10
    }
    
    override func addView() {
        [successScanImage, successText, nextButton].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        successScanImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset((bounds.height) / 4.61)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(218)
        }
        successText.snp.makeConstraints {
            $0.top.equalTo(successScanImage.snp.bottom).offset(76)
            $0.centerX.equalToSuperview()
        }
        nextButton.snp.makeConstraints {
            $0.top.equalTo(successText.snp.bottom).offset(39)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(140)
            $0.height.equalTo(38)
        }
    }
}
