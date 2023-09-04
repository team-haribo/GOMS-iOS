import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        setupFCM(application)
        return true
    }
    
    private func setupFCM(_ application: UIApplication) {
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [
                .sound,
                .alert,
                .badge
            ]
        ) { isAgree, error in
            if isAgree {
                print("알림허용")
            }
        }
        application.registerForRemoteNotifications()
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    //MARK: 푸시클릭시
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        print("Push Click: ", #function)
    }
    
    //MARK: 앱화면 보고있는중에 푸시올 때
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {
        print("Push: ", #function)
        return [
            .sound,
            .banner,
            .list
        ]
    }
    
    //MARK: FCMToken 업데이트시
    func messaging(
        _ messaging: Messaging,
        didReceiveRegistrationToken fcmToken: String?
    ) {
        print("FCMToken(Update): ", #function, fcmToken as Any)
    }
    
    //MARK: 스위즐링 NO시, APNs등록, 토큰값가져옴
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("deviceToken: ", #function, deviceTokenString)
        let keychain = Keychain()
        keychain.create(
            key: Const.KeychainKey.deviceToken,
            token: deviceTokenString 
        )
    }
    
    //MARK: error발생시
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Error: ", error)
    }
}
