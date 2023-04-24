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

class QRCodeViewController: BaseViewController<QRCodeViewModel>, QRCodeReaderViewControllerDelegate{
    override func viewDidLoad() {
        super.viewDidLoad()
        // [카메라 권한 부여 확인 실시]
        self.checkCameraPermission()
     }
     
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if permissionNoArray.count > 0 && permissionNoArray.isEmpty == false {
            showAlert(tittle: "[알림]", content: "카메라 권한이 비활성 상태입니다.", okBtb: "확인", noBtn: "")
            permissionNoArray.removeAll()
        }
        
        else {
            self.callQrScanStart()
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
    lazy var readerVC: QRCodeReaderViewController = {
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
            print("")
            print("===============================")
            print("[ViewController >> callQrScanStart() :: QR 스캔 결과 확인 실시]")
            print("result : ", result?.value ?? "")
            print("===============================")
            print("")
        }
         
        // [readerVC를 모달 양식 시트로 표시]
        self.readerVC.modalPresentationStyle = .fullScreen
    
        self.present(self.readerVC, animated: true, completion: nil)
        
    }
     
     
     
     // MARK: [QRCodeReaderViewController 대리자 메소드]
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning() // 스캔 중지
        self.dismiss(animated: true, completion: nil) // 카메라 팝업창 없앰
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
        self.dismiss(animated: true, completion: nil) // 카메라 팝업창 없앰
    }
     
     
     
    // MARK: [alert 팝업창 호출 메소드 정의 실시 : 이벤트 호출 시]
    // 호출 방법 : showAlert(tittle: "title", content: "content", okBtb: "확인", noBtn: "취소")
    func showAlert(tittle:String, content:String, okBtb:String, noBtn:String) {
        // [UIAlertController 객체 정의 실시]
        let alert = UIAlertController(title: tittle, message: content, preferredStyle: UIAlertController.Style.alert)
        
        // [인풋으로 들어온 확인 버튼이 nil 아닌 경우]
        if(okBtb != "" && okBtb.count>0){
            let okAction = UIAlertAction(title: okBtb, style: .default) { (action) in
                // [확인 버튼 클릭 이벤트 내용 정의 실시]
                return
            }
            alert.addAction(okAction) // 버튼 클릭 이벤트 객체 연결
        }
         
        // [인풋으로 들어온 취소 버튼이 nil 아닌 경우]
        if(noBtn != "" && noBtn.count>0){
            let noAction = UIAlertAction(title: noBtn, style: .default) { (action) in
                // [취소 버튼 클릭 이벤트 내용 정의 실시]
                return
            }
            alert.addAction(noAction) // 버튼 클릭 이벤트 객체 연결
        }
         
        // [alert 팝업창 활성 실시]
        present(alert, animated: false, completion: nil)
    }


}
