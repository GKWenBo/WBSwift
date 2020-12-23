import UIKit

/*
 sing self-executing closures is a great way to encapsulate lazy property initialization:
 */
class StoreViewController: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let view = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
    }
}

extension StoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
}
