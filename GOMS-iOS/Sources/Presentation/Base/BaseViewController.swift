//
//  BaseViewController.swift
//  GOMS-iOS
//
//  Created by 선민재 on 2023/04/17.
//

import UIKit
import RxCocoa
import RxSwift

class BaseViewController<T>: UIViewController {
    let viewModel: T
    var disposeBag = DisposeBag()
    let bounds = UIScreen.main.bounds

    
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
        addView()
        setLayout()
    }
    
    func addView() {
        
    }
    
    func setLayout() {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
