import UIKit

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellID = "cell"
    let headerID = "header"
    var collectionView: UICollectionView! = nil
    var mobileVersionLabel = UILabel()
    
    var offers: [Advertisement]?
    
    override func viewWillAppear(_ animated: Bool) {

        if #available(iOS 16.0, *) {

            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene

            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .portrait))

        } else {
            AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        }
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(self.getOffers(_:)), name: Notification.Name.advertisments, object: nil)
        LoadController().getMainScreenData()
        
        self.navigationController?.isNavigationBarHidden = true
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: headerID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        let topTapbarPosition = tabBarController?.tabBar.frame.minY
        let tabHeight = self.view.frame.height - (topTapbarPosition ?? 0)
        collectionView.frame = CGRect.init(x: 0, y: 194, width: self.view.frame.width, height: self.view.frame.height - 194 - tabHeight)
        print(self.view.frame.height)
        view.addSubview(collectionView)
    
    }
    func createLayout() -> UICollectionViewLayout {
        
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .estimated(70))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let group = NSCollectionLayoutGroup.vertical(layoutSize: itemSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(self.view.frame.width / 2 - 3),
                    heightDimension: .estimated(self.view.frame.width / 2 + 80 - 3)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(self.view.frame.height / 2)
                )
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize,
                    subitem: item,
                    count: 2)
                let section = NSCollectionLayoutSection(group: group)
                return section
            }
            
        }
        return layout
    }
   /*
    @objc func getMyOffers(_ notification: Notification) {
        guard let offers = notification.userInfo?[Notification.Name.advertisments] as? [Advertisement] else {
            self.offers = []
            self.collectionView.reloadData()
            return
        }
        self.offers = offers
        self.collectionView.reloadData()
    }*/
    
    @objc func getOffers(_ notification: Notification) {
        
        guard let offers = notification.userInfo?[Notification.Name.advertisments] as? ([Advertisement]) else { return }
        self.offers = offers
        self.collectionView.reloadData()
        print(offers)
    }
    
}

extension MainScreen {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        default:
            return offers?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerID, for: indexPath) as UICollectionViewCell
            cell.addSubview(addObjectView())
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as UICollectionViewCell
            cell.backgroundView = cellView(indexPath.row)
            return cell
            
        }
    }
    func addObjectView() -> UIView {
        let addObjectView = UIView()
        addObjectView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 60)
        let button = UIButton()
        button.frame = CGRect.init(x: 50, y: 10, width: self.view.frame.width - 100, height: 50)
        button.setTitle("З", for: .normal)
//        button.addTarget(self, action: #selector(addObject), for: .touchUpInside)
        button.setTitleColor(.blue, for: .normal)
        button.backgroundColor = UIColor(cgColor: CGColor.init(red: 90 / 100, green: 94 / 100, blue: 100 / 100, alpha: 1.0))
        button.layer.cornerRadius = 5
        addObjectView.addSubview(button)
                        
        return addObjectView
    }
    func cellView(_ index: Int) -> UIView {
        let cell = UIView()
        let width = (self.view.frame.width/2) - 10
        let cellView = UIImageView()
        cellView.frame = CGRect(x: 10, y: 0, width: width - 10, height: width - 10)
        
        let configuration = UIImage.SymbolConfiguration(pointSize: 200, weight: .regular, scale: .medium)
        let placeholder = UIImage(systemName: "photo.fill", withConfiguration: configuration)
//        if let imgUrl = offers?[index].imageUrl {
//            cellView.af_setImage(withURL: GetOffersController().getOfferUrl(name: imgUrl), placeholderImage: placeholder, filter: AspectScaledToFillSizeWithRoundedCornersFilter(size: cellView.frame.size, radius: 20.0))
//        } else {
//            cellView.image = placeholder
//            cellView.layer.cornerRadius = 20
//        }
        cellView.image = placeholder
                    cellView.layer.cornerRadius = 20
        let firstLabel = UILabel()
        let secondLabel = UILabel()
        let thirdLabel = UILabel()
        firstLabel.frame = CGRect(x: 20, y: width + 2, width: width - 20, height: 20)
        secondLabel.frame = CGRect(x: 20, y: width + 22, width: width - 20, height: 20)
        thirdLabel.frame = CGRect(x: 20, y: width + 42, width: width - 20, height: 18)
    
        firstLabel.font = .boldSystemFont(ofSize: 25)
        secondLabel.text = offers?[index].title ?? ""
        thirdLabel.text = offers?[index].price ?? ""
        thirdLabel.textColor = .gray
        
        cell.addSubview(cellView)
        cell.addSubview(firstLabel)
        cell.addSubview(secondLabel)
        cell.addSubview(thirdLabel)
        print(cell.frame)
        print(cellView.frame)
        print(thirdLabel.frame)
        return cell
    }
    
}

