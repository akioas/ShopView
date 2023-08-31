import UIKit

class DetailsScreen: UIViewController {
   
    var details: DetailsScreenData?
    var id: String?
    var errorView = UIView()
    
    let header = UILabel()
    
    
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
        setupView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getDetails(_:)), name: Notification.Name.details, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.error), name: Notification.Name.error, object: nil)
        reload()
        
    
    }
    
    func setupView() {
        view.backgroundColor = .white
        setupHeader()
        setupDetails()
    }
    
    func setupHeader() {
        header.frame = CGRect.init(x: 40, y: 44, width: self.view.frame.width - 80, height: 70)
        header.textAlignment = .center
        header.font = .systemFont(ofSize: 20)
        view.addSubview(header)
        
        let button = UIButton()
        button.frame = CGRect.init(x: 5, y: 64, width: 30, height: 30)
        button.setTitle("X", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(back), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func back() {
        self.dismiss(animated: false)
    }
    @objc func reload() {
        if let id = id {
            LoadController().getDetailsScreenData(id: id)
        }
    }
    func setupErrorView() {
        let button = UIButton()
        button.frame = CGRect(x: (view.frame.width - 100) / 2, y: (view.frame.height - 44) / 2, width: 100, height: 20)
        button.setTitle("Обновить", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .systemGray2
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(reload), for: .touchUpInside)
        errorView.addSubview(button)
        errorView.backgroundColor = .white
        view.addSubview(errorView)
        errorView.isHidden = true
    }
    
    func setupDetails() {
        let detailsView = UIView()
        let height = (view.frame.height - 104) / 2
        detailsView.frame = CGRect.init(x: 10, y: (view.frame.height + 104) / 2, width: view.frame.width - 20, height: height)
        let descriptionLabel = UILabel()
        let priceLabel = UILabel()
        let locationLabel = UILabel()
        let dateLabel = UILabel()
        let contactsLabel = UILabel()
        let phoneLabel = UILabel()
        let addressLabel = UILabel()
        descriptionLabel.frame = CGRect(x: 0, y: 80, width: detailsView.frame.width, height: 50)
        priceLabel.frame = CGRect(x: 0, y: 60, width: detailsView.frame.width, height: 18)
        locationLabel.frame = CGRect(x: 0, y: 10, width: 250, height: 20)
        addressLabel.frame = CGRect(x: 0, y: 30, width: 250, height: 20)
        contactsLabel.frame = CGRect(x: 0, y: height - 80, width: detailsView.frame.width, height: 20)
        dateLabel.frame = CGRect(x: detailsView.frame.width - 140, y: 10, width: 140, height: 20)
        phoneLabel.frame = CGRect(x: 0, y: height - 60, width: detailsView.frame.width, height: 20)
    
        descriptionLabel.text = details?.description
        descriptionLabel.numberOfLines = 5
        priceLabel.text = details?.price
        priceLabel.font = .boldSystemFont(ofSize: 15)
        dateLabel.text = details?.created_date
        dateLabel.textAlignment = .right
        locationLabel.text = details?.location
        addressLabel.text = details?.address
        contactsLabel.text = details?.email
        phoneLabel.text = details?.phone_number
        addressLabel.textColor = .gray
        dateLabel.textColor = .gray
        locationLabel.textColor = .gray
        phoneLabel.textColor = .blue
        contactsLabel.textColor = .blue
        
        detailsView.addSubview(descriptionLabel)
        detailsView.addSubview(priceLabel)
        detailsView.addSubview(locationLabel)
        detailsView.addSubview(dateLabel)
        detailsView.addSubview(addressLabel)
        detailsView.addSubview(contactsLabel)
        detailsView.addSubview(phoneLabel)
                
        view.addSubview(detailsView)
    }
    
    @objc func error(_ notification: Notification) {
        errorView.isHidden = false
        errorView.superview?.bringSubviewToFront(errorView)
    }
    
    func setupImage() {
        let loader = ImageLoader()
        loader.frame = CGRect.init(x: 10, y: 104, width: view.frame.width - 20, height: (view.frame.height - 104) / 2)
        
        view.addSubview(loader)
        loader.layer.cornerRadius = 15
        loader.layer.masksToBounds = true

        if let imgUrl = details?.image_url {
            loader.loadImageWithUrl(URL(string: imgUrl)!)
        }
    }
   
    
    @objc func getDetails(_ notification: Notification) {
        guard let details = notification.userInfo?[Notification.Name.details] as? (DetailsScreenData) else { return }
        self.details = details
        setupImage()
        header.text = self.details?.title
        setupDetails()
        errorView.isHidden = true
    }
    
}
