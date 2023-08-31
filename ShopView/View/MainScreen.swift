import UIKit

class MainScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let cellID = "cell"
    let headerID = "header"
    var collectionView: UICollectionView! = nil
    var errorView = UIView()
    var mobileVersionLabel = UILabel()
    
    var offers: [Advertisement]?
    var isEmpty = true
        
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.getOffers(_:)), name: Notification.Name.advertisements, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.error), name: Notification.Name.error, object: nil)
        reload()
        
        self.navigationController?.isNavigationBarHidden = true
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: headerID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.frame = CGRect.init(x: 0, y: 44, width: self.view.frame.width, height: self.view.frame.height - 44 )
        view.addSubview(collectionView)
        setupErrorView()
    
    }
                
    func setupErrorView() {
        
        let button = UIButton()
        button.frame = CGRect(x: (view.frame.width - 100) / 2, y: (view.frame.height - 44) / 2, width: 100, height: 20)
        button.setTitle("Ошибка", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        errorView.addSubview(button)
        view.addSubview(errorView)
        errorView.isHidden = true
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
   
    func toDetailsView(selectedId: String) {
        let vc = DetailsScreen()
        vc.id = selectedId
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false)
    }
    
    @objc func getOffers(_ notification: Notification) {

        guard let offers = notification.userInfo?[Notification.Name.advertisements] as? ([Advertisement]) else { return }
        self.offers = offers
        self.collectionView.reloadData()
        isEmpty = false
        collectionView.isHidden = false
        collectionView.superview?.bringSubviewToFront(collectionView)
    }
    @objc func error() {
        collectionView.isHidden = true
        errorView.isHidden = false
        errorView.superview?.bringSubviewToFront(errorView)
    }
    @objc func reload() {
        LoadController().getMainScreenData()
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
            return offers?.count ?? 20
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedId = offers?[indexPath.row].id ?? ""
        toDetailsView(selectedId: selectedId)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: headerID, for: indexPath) as UICollectionViewCell
            cell.addSubview(topView())
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as UICollectionViewCell
            cell.backgroundView = cellView(indexPath.row)
            return cell
            
        }
    }
    func topView() -> UIView {
        let topView = UIView()
        topView.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 60)
        let textField = TextField()
        textField.frame = CGRect.init(x: 10, y: 10, width: self.view.frame.width - 80, height: 50)
        textField.layer.cornerRadius = 15
        textField.placeholder = "Поиск"
        textField.backgroundColor = .systemGray6
        
        let glassImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        let imgView = UIImageView()
        imgView.frame = CGRect.init(x: 10, y: 15, width: 20, height: 20)
        imgView.image = glassImage
        
        
        let cart = UIImageView()
        cart.frame = CGRect.init(x: self.view.frame.width - 50, y: 20, width: 30, height: 30)
        let cartImage = UIImage(systemName: "basket")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        cart.image = cartImage
        
        textField.addSubview(imgView)
        topView.addSubview(textField)
        topView.addSubview(cart)
                        
        return topView
    }
    func cellView(_ index: Int) -> UIView {
        let cell = UIView()
        let width = (self.view.frame.width / 2)
        let cellView = UIImageView()
        
        cellView.frame = CGRect(x: 5, y: 0, width: width - 20, height: width - 20)
        
        let loader = ImageLoader()
        
        loader.frame = cellView.frame
        loader.layer.cornerRadius = 10
        loader.layer.masksToBounds = true
        
        cellView.addSubview(loader)

        if let imgUrl = offers?[index].image_url {
            loader.loadImageWithUrl(URL(string: imgUrl)!)
        }
        let firstLabel = UILabel()
        let secondLabel = UILabel()
        let thirdLabel = UILabel()
        firstLabel.frame = CGRect(x: 10, y: width - 18, width: width - 20, height: 20)
        secondLabel.frame = CGRect(x: 10, y: width + 4, width: width - 20, height: 20)
        thirdLabel.frame = CGRect(x: 10, y: width + 24, width: width - 20, height: 18)
        
        if !isEmpty {
            setClearColor(firstLabel)
            setClearColor(secondLabel)
            setClearColor(thirdLabel)
            setClearColor(cellView)
        } else {
            setGrayColor(firstLabel)
            setGrayColor(secondLabel)
            setGrayColor(thirdLabel)
            setGrayColor(cellView)
        }
    
        secondLabel.font = .boldSystemFont(ofSize: 15)
        firstLabel.text = offers?[index].title ?? ""
        secondLabel.text = offers?[index].price ?? ""
        thirdLabel.text = offers?[index].location ?? ""
        thirdLabel.textColor = .gray
        
        cell.addSubview(cellView)
        cell.addSubview(firstLabel)
        cell.addSubview(secondLabel)
        cell.addSubview(thirdLabel)
  
        return cell
    }
    
    func setClearColor(_ view: UIView) {
        view.backgroundColor = .clear
    }
    func setGrayColor(_ view: UIView) {
        view.backgroundColor = .lightGray
    }
    
}

