import UIKit
import QRScanner
import SnapKit
import AVFoundation
import Then
import RxFlow
import RxCocoa
import RxSwift
import QRCode

class QRCodeViewController: BaseViewController<QRCodeViewModel> {
    
    lazy var qrScannerView = QRScannerView(frame: view.bounds)
    
    private let userIsBlackList = UserDefaults.standard.bool(forKey: "userIsBlackList")
    private var timerLeft: Int = 300
    
    override func viewDidLoad() {
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        super.viewDidLoad()
        startTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        checkUserIsAdmin()
        checkIsBlackList()
    }

    override func viewDidDisappear(_ animated: Bool) {
        qrScannerView.stopRunning()
    }
    
    private func checkIsBlackList() {
        if userIsBlackList == true {
            viewModel.steps.accept(GOMSStep.failureAlert(
                title: "",
                message: "외출이 금지된 상태입니다.",
                action: [.init(title: "확인",style: .default) { _ in
                    self.viewModel.steps.accept(GOMSStep.introIsRequired)}
                        ]
            ))
        }
    }
    
    private func checkUserIsAdmin() {
        if userAuthority == "ROLE_STUDENT_COUNCIL" {
            qrScannerView.isHidden = true
            outingMainText.isHidden = false
            outingSubText.isHidden = false
            lastTimeText.isHidden = false
            lastTimer.isHidden = false
            createQrCode()
        }
        else {
           setupQRScanner()
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (t) in
            self.timerLeft -= 1
            let minutes = self.timerLeft / 60
            let seconds = self.timerLeft % 60
            if self.timerLeft > 0 {
                self.lastTimer.text = String(format: "%d분 %02d초", minutes, seconds)
            }
            else {
                self.lastTimer.text = "0분 00초"
                self.createQrCode()
                self.timerLeft = 300
            }
        })
    }
    
    private func createQrCode() {
        viewModel.makeQRCode {
            guard let urlUUID = self.viewModel.uuidData?.outingUUID else {return}
            var qrCode = QRCode(
                url: (
                    URL(string: "\(BaseURL.baseURL)/outing/\(urlUUID)") ?? .init(string: "https://naver.com")!
                )
            )
            qrCode?.color = UIColor.black
            qrCode?.backgroundColor = .background ?? .white
            qrCode?.size = CGSize(width: 200, height: 200)
            qrCode?.scale = 1.0
            qrCode?.inputCorrection = .quartile
            
            let qrImageView = UIImageView.init(qrCode: qrCode!)
            self.view.addSubview(qrImageView)
            qrImageView.snp.makeConstraints {
                $0.height.width.equalTo(250)
                $0.center.equalTo(self.view.snp.center).offset(0)
            }
        }
    }
    
    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }
    
    private func setupQRScannerView() {
        view.addSubview(qrScannerView)
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }
    
    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(
                title: "Error",
                message: "카메라 접근을 허용해주세요",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    private let outingMainText = UILabel().then {
        $0.isHidden = true
        $0.text = "외출하기"
        $0.textColor = .black
        $0.font = UIFont.GOMSFont(size: 22, family: .Bold)
    }
    
    private let outingSubText = UILabel().then {
        $0.isHidden = true
        $0.text = "모바일 기기로\nQRCode를 스캔한 후 외출해주세요!"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .black
        $0.font = UIFont.GOMSFont(size: 16, family: .Medium)
    }
    
    private let lastTimeText = UILabel().then {
        $0.isHidden = true
        $0.text = "남은시간"
        $0.textColor = .black
        $0.font = UIFont.GOMSFont(size: 16, family: .Bold)
    }
    
    private let lastTimer = UILabel().then {
        $0.isHidden = true
        $0.text = "5분 00초"
        $0.textColor = .adminColor
        $0.font = UIFont.GOMSFont(size: 22, family: .Bold)
    }
    
    override func addView() {
        [outingMainText, outingSubText, lastTimeText, lastTimer].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        outingMainText.snp.makeConstraints {
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 4.95)
            $0.centerX.equalToSuperview()
        }
        outingSubText.snp.makeConstraints {
            $0.top.equalTo(outingMainText.snp.bottom).offset(18)
            $0.centerX.equalToSuperview()
        }
        lastTimeText.snp.makeConstraints {
            $0.bottom.equalTo(view.snp.bottom).inset((bounds.height) / 3.34)
            $0.centerX.equalToSuperview()
        }
        lastTimer.snp.makeConstraints {
            $0.top.equalTo(lastTimeText.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
    }
}

extension QRCodeViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
    }
    
    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print(code)
        viewModel.userOutingData(qrCodeURL: code)
    }
}
