import UIKit
import Then
import SnapKit

class SearchModalViewController: BaseViewController<SearchModalViewModal> {
    
    private let roleName = ["학생","학생회","외출금지"]

    override func viewDidLoad() {
        super.viewDidLoad()
        roleCollectionView.dataSource = self
        roleCollectionView.delegate = self
        roleCollectionView.register(
            RoleCell.self,
            forCellWithReuseIdentifier: RoleCell.identifier
        )
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
    
    private let roleCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    ).then {
        $0.isScrollEnabled = false
        $0.backgroundColor = .background
    }
    
    override func addView() {
        [searchBar,roleText,gradeText,classNumText,roleCollectionView].forEach {
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
        
        roleCollectionView.snp.makeConstraints {
            $0.top.equalTo(roleText.snp.bottom).offset(6)
            $0.leading.equalToSuperview().offset(26)
            $0.trailing.equalToSuperview().inset(75)
            $0.bottom.equalTo(gradeText.snp.bottom).inset(40)
        }
    }
}
extension SearchModalViewController :
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout,
    UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let roleCell = collectionView.dequeueReusableCell(withReuseIdentifier: RoleCell.identifier, for: indexPath) as? RoleCell else {
            return UICollectionViewCell()
        }
        roleCell.backgroundColor = .white
        roleCell.layer.cornerRadius = 8
        roleCell.layer.applySketchShadow(
            color: UIColor.black,
            alpha: 0.1,
            x: 0,
            y: 2,
            blur: 8,
            spread: 0
        )
        roleCell.roleText.text = roleName[indexPath.row]
        return roleCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 74, height: 34)
    }
}
