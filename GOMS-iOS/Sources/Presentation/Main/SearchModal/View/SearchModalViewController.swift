import UIKit
import Then
import SnapKit

class SearchModalViewController: BaseViewController<SearchModalViewModal> {
    
    private let roleName = ["학생","학생회","외출금지"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private var searchBar = UITextField().then {
        $0.backgroundColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        $0.font = UIFont.GOMSFont(size: 14, family: .Regular)
        $0.layer.cornerRadius = 10
        $0.placeholder = "찾으시는 학생이 있으신가요?"
        $0.addLeftPadding()
    }
    
    private let roleText = UILabel().then {
        $0.text = "역할"
        $0.font = UIFont.GOMSFont(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private let gradeText = UILabel().then {
        $0.text = "학년"
        $0.font = UIFont.GOMSFont(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private let classNumText = UILabel().then {
        $0.text = "반"
        $0.font = UIFont.GOMSFont(size: 16, family: .Regular)
        $0.textColor = .black
    }
    
    private var roleSeg = UISegmentedControl(items: ["학생","학생회","외출금지"]).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor.white
        $0.selectedSegmentTintColor = .white
        $0.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
    }
    
    override func addView() {
        [searchBar,roleText,gradeText,classNumText, roleSeg].forEach {
            view.addSubview($0)
        }
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(38)
            $0.trailing.leading.equalToSuperview().inset(26)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        roleText.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(35)
            $0.leading.equalToSuperview().offset(26)
        }
        
        gradeText.snp.makeConstraints {
            $0.top.equalTo(roleText.snp.bottom).offset(65)
            $0.leading.equalToSuperview().offset(26)
        }
        
        classNumText.snp.makeConstraints {
            $0.top.equalTo(gradeText.snp.bottom).offset(65)
            $0.leading.equalToSuperview().offset(26)
        }
        
        roleSeg.snp.makeConstraints {
            $0.top.equalTo(roleText.snp.bottom).offset(6)
            $0.leading.equalTo(view.snp.leading).offset(26)
            $0.trailing.equalTo(view.snp.trailing).inset(26)
            $0.height.equalTo(46)
        }
    }
}
