import UIKit
import QRCode

extension UIImageView {
    convenience init(qrCode: QRCode) {
        self.init(image: qrCode.unsafeImage)
    }
}
