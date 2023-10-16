import UIKit
import RxCocoa
import RxSwift
import Then

class BaseViewController<T>: UIViewController {
    let viewModel: T
    var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds
    let keychain = Keychain()
    lazy var userAuthority = keychain.read(key: Const.KeychainKey.authority)
    
    init(_ viewModel: T) {
        self.viewModel = viewModel
        super .init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = .black
        view.backgroundColor = .background
        self.navigationItem.backButtonTitle = ""
        addView()
        setLayout()
        bind(reactor: viewModel)
    }
    
    func addView() {
        
    }
    
    func setLayout() {
        
    }
    
    func bind(reactor: T) {
        bindView(reactor: reactor)
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    func bindView(reactor: T) {}
    func bindAction(reactor: T) {}
    func bindState(reactor: T) {}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
