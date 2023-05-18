//
//  RequestViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/18.
//

import UIKit
import QRCodeReader
import SnapKit
import AVFoundation
import Then
import RxFlow
import RxCocoa
import RxSwift
import QRCode


class QRCodeViewController: BaseViewController<QRCodeViewModel>, QRCodeReaderViewControllerDelegate {
    
    private var timerLeft: Int = 300
    
    override func viewDidLoad() {
        checkUserIsAdmin()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        super.viewDidLoad()
        bindViewModel()
     }
    
    private func checkUserIsAdmin() {
        if userAuthority == "ROLE_STUDENT_COUNCIL" {
            qrCodeBackImg.isHidden = true
            useQRCodeButton.isHidden = true
            outingMainText.isHidden = false
            outingSubText.isHidden = false
            lastTimeText.isHidden = false
            lastTimer.isHidden = false
            createQrCode()
            startTimer()
        }
        else {
            if permissionNoArray.count > 0 && permissionNoArray.isEmpty == false {
                showAlert(tittle: "[알림]", content: "카메라 권한이 비활성 상태입니다.", okBtb: "확인", noBtn: "취소")
                permissionNoArray.removeAll()
            }
            else {
                self.callQrScanStart()
            }
        }
    }
    
    private func bindViewModel() {
        useQRCodeButton.rx.tap
            .bind{
                self.callQrScanStart()
            }.disposed(by: disposeBag)
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
        viewModel.makeQRCode()
        let urlUUID = viewModel.uuidData
        var qrCode = QRCode(
            url: (
                URL(string: "\(BaseURL.baseURL)/student-council/outing/\(urlUUID)") ?? .init(string: "https://naver.com")!
            )
        )
        qrCode?.color = UIColor.black
        qrCode?.backgroundColor = .background ?? .white
        qrCode?.size = CGSize(width: 200, height: 200)
        qrCode?.scale = 1.0
        qrCode?.inputCorrection = .quartile
        
        let qrImageView = UIImageView.init(qrCode: qrCode!)
        view.addSubview(qrImageView)
        qrImageView.snp.makeConstraints {
            $0.height.width.equalTo(250)
            $0.center.equalTo(view.snp.center).offset(0)
        }
    }
     
    var permissionNoArray : Array<String> = []
     
    func checkCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
            if granted {
                //MARK: 권한 허용 상태
            } else {
                //MARK: 권한 거부 상태
                self.permissionNoArray.append("카메라")
            }
        })
    }
     
     
     
     // MARK: [QR 객체 초기화 수행 실시]
    var readerVC: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
            
            // [QR 스캔 뷰 컨트롤러 구성 실시]
            $0.showTorchButton        = false
            $0.showSwitchCameraButton = true // 화면 전환 버튼 표시 여부
            $0.showCancelButton       = true // 취소 버튼 표시 여부
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
     
     
     
     // MARK: [QR 코드 스캔 시작 실시]
    func callQrScanStart(){
        // [QR 패턴 사용 실시]
        self.readerVC.delegate = self
        
        // [클로저 사용 실시]
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            let qrResult = String(describing: result?.value)
            self.viewModel.userOutingData(qrCodeURL: qrResult)
            print(qrResult)
        }
        
        
        self.readerVC.modalPresentationStyle = .fullScreen
        self.present(readerVC, animated: true)
    }
     
     
     
     // MARK: [QRCodeReaderViewController 대리자 메소드]
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning() // 스캔 중지
        self.dismiss(animated: true, completion: nil)// 카메라 팝업창 없앰
    }

     
     
    // MARK: [카메라 전환 버튼 이벤트 확인]
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        let cameraName = String(newCaptureDevice.device.localizedName)
        print("")
        print("===============================")
        print("[ViewController >> reader() :: 카메라 전환 버튼 이벤트 확인]")
        print("cameraName : ", cameraName)
        print("===============================")
        print("")
    }

     
     // MARK: [QR 스캔 종료 실시]
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning() // 스캔 중지
        self.dismiss(animated: true, completion: nil)// 카메라 팝업창 없앰
    }
    
    func showAlert(tittle:String, content:String, okBtb:String, noBtn:String) {
        let alert = UIAlertController(title: tittle, message: content, preferredStyle: UIAlertController.Style.alert)
        if(okBtb != "" && okBtb.count>0){
            let okAction = UIAlertAction(title: okBtb, style: .default) { (action) in
                return
            }
            alert.addAction(okAction)
        }
        if(noBtn != "" && noBtn.count>0){
            let noAction = UIAlertAction(title: noBtn, style: .default) { (action) in
                return
            }
            alert.addAction(noAction)
        }
        present(alert, animated: false, completion: nil)
    }
    
    private let qrCodeBackImg = UIImageView().then {
        $0.image = UIImage(named: "qrCodeImage.svg")
    }
    
    private var useQRCodeButton = UIButton().then {
        $0.setTitle("외출하기", for: .normal)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.titleLabel?.font = UIFont.GOMSFont(size: 14, family: .Bold)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .mainColor
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
        [qrCodeBackImg, useQRCodeButton, outingMainText, outingSubText, lastTimeText, lastTimer].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        qrCodeBackImg.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.snp.top).offset((bounds.height) / 2.55)
        }
        useQRCodeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(qrCodeBackImg.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(117)
            $0.height.equalTo(38)
        }
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
