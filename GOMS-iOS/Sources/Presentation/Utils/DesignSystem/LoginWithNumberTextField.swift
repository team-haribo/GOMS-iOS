import UIKit


public final class LoginWithNumberTextField: UITextField {
    required public init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }
    
    init(){
        super.init(frame: CGRect.zero)
    }
    
    convenience init(
        placeholder: String = "",
        width: Int = 0
    ) {
        self.init()
        self.placeholder = placeholder
        self.leftPadding(width: width)
        self.backgroundColor = .gomsWhite
        self.layer.cornerRadius = 10
        self.textColor = .gomsBlack
        self.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        self.font = UIFont.GOMSFont(
            size:14,
            family: .Regular
        )
    }
    
    public override func becomeFirstResponder() -> Bool {
        let didBecomeFirstResponder = super.becomeFirstResponder()
        if didBecomeFirstResponder {
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.p10?.cgColor
        }
        return didBecomeFirstResponder
    }

    public override func resignFirstResponder() -> Bool {
        let didResignFirstResponder = super.resignFirstResponder()
        if didResignFirstResponder {
            self.layer.borderWidth = 0
            self.layer.borderColor = nil
        }
        return didResignFirstResponder
    }
}
