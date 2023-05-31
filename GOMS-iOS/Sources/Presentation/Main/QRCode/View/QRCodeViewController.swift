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
    private let userIsBlackList = UserDefaults.standard.bool(forKey: "userIsBlackList")
    private var timerLeft: Int = 300
    
    override func viewDidLoad() {
        checkIsBlackList()
        checkUserIsAdmin()
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem()
        self.navigationItem.leftLogoImage()
        super.viewDidLoad()
        bindViewModel()
        barButtonDidTap()
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
            qrCodeBackImg.isHidden = true
            useQRCodeButton.isHidden = true
            outingMainText.isHidden = false
            outingSubText.isHidden = false
            lastTimeText.isHidden = false
            lastTimer.isHidden = false
            createQrCode()
            startTimer()
            bindViewModel()
        }
        else {
            if permissionNoArray.count > 0 && permissionNoArray.isEmpty == false {
                showAlert(tittle: "[알림]", content: "카메라 권한이 비활성 상태입니다.", okBtb: "확인", noBtn: "취소")
                permissionNoArray.removeAll()
            }
            else {
                self.openCamera()
            }
        }
    }
    
    private func bindViewModel() {
        useQRCodeButton.rx.tap
            .bind{
                self.openCamera()
            }.disposed(by: disposeBag)
    }
    
    private func barButtonDidTap() {
        let input = QRCodeViewModel.Input(
            navProfileButtonTap: navigationItem.rightBarButtonItem!.rx.tap.asObservable()
        )
        viewModel.transVC(input: input)
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
            $0.showSwitchCameraButton = false // 화면 전환 버튼 표시 여부
            $0.showCancelButton       = true // 취소 버튼 표시 여부
            $0.showOverlayView        = true
            $0.rectOfInterest         = CGRect(x: 0.2, y: 0.2, width: 0.6, height: 0.6)
        }
        return QRCodeReaderViewController(builder: builder)
    }()
    
    func openCamera(){
            print("")
            print("===============================")
            print("[A_Main >> openCamera() :: 카메라 열기 수행 실시]")
            print("===============================")
            print("")
            
            /*
            MARK: [QR 코드 스캔 필요 사항]
            1. info.plist 권한 : Privacy - Camera Usage Description
            2. 라이브러리 설치 git : https://github.com/yannickl/QRCodeReader.swift.git
            3. SPM 패키지 매니저 사용해 설치 시 참고 : branch >> 라이브러리 설치 진행
            4. 필요 import :
               - import AVFoundation
               - import QRCodeReader
            5. 필요 딜리게이트 : QRCodeReaderViewControllerDelegate
            6. 로직 :
              - 카메라 권한 상태 퍼미션 인증 확인
              - 카메라 호출 및 QR 스캔 시작 실시
              - QR 스캔 완료 시 카메라 활성 창 닫기 및 스캔 종료 실시
            */
            
            
            // [SEARCH FAST] : [카메라 호출 수행]
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    print("")
                    print("===============================")
                    print("[A_Main > openCamera() :: 카메라 권한 허용 상태]")
                    print("===============================")
                    print("")
                    
                    // [카메라 열기 수행 실시]
                    DispatchQueue.main.async {
                        // -----------------------------------------
                        // [사진 찍기 카메라 호출]
                        /*let camera = UIImagePickerController()
                        camera.sourceType = .camera
                        self.present(camera, animated: false, completion: nil)*/
                        // -----------------------------------------
                        // [QR 패턴 사용 실시]
                        self.readerVC.delegate = self
                        
                        
                        // [클로저 사용 실시]
                        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
                            print("")
                            print("===============================")
                            print("[A_Main >> openCamera() :: 카메라 스캔 결과 확인 실시]")
                            print("result [결과] :: ", result?.value ?? "")
                            print("===============================")
                            print("")
                            let scanResult = String(describing: result?.value ?? "")
                            self.viewModel.userOutingData(qrCodeURL: scanResult)
                        }
                        self.readerVC.modalPresentationStyle = .fullScreen
                        //self.readerVC.modalPresentationStyle = .fullScreen
                       
                        self.present(self.readerVC, animated: false, completion: nil)
                        // -----------------------------------------
                    }
                }
            })
        }
     
    func callQrScanStart(){
        self.readerVC.delegate = self
        
        self.readerVC.completionBlock = { (result: QRCodeReaderResult?) in
            print("result : ", result?.value ?? "")
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
