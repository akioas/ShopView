import UIKit

class DetailsScreen: UIViewController {
   
    var details: DetailsScreenData?
    var id: String?
    
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
        if let id = id {
            LoadController().getDetailsScreenData(id: id)
        }
        
    
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
    
    func setupDetails() {
        let detailsView = UIView()
        detailsView.frame = CGRect.init(x: 10, y: (view.frame.height + 104) / 2, width: view.frame.width - 20, height: (view.frame.height - 104) / 2)
        let descriptionLabel = UILabel()
        let secondLabel = UILabel()
        let thirdLabel = UILabel()
        let description = UILabel()
        descriptionLabel.frame = CGRect(x: 0, y: 0, width: detailsView.frame.width, height: 50)
        secondLabel.frame = CGRect(x: 0, y: 52, width: detailsView.frame.width, height: 18)
        thirdLabel.frame = CGRect(x: 0, y: 70, width: detailsView.frame.width, height: 20)
        thirdLabel.frame = CGRect(x: 0, y: 90, width: detailsView.frame.width, height: 20)
    
        descriptionLabel.text = details?.description ?? ""
        descriptionLabel.numberOfLines = 5
        secondLabel.text = details?.price ?? ""
        secondLabel.font = .boldSystemFont(ofSize: 15)

        thirdLabel.text = details?.location
        description.text = details?.address
        thirdLabel.textColor = .gray
        
        detailsView.addSubview(descriptionLabel)
        detailsView.addSubview(secondLabel)
        detailsView.addSubview(thirdLabel)
        detailsView.addSubview(description)
                
        view.addSubview(detailsView)
    }
    
    func setupLoadView() {
        
    }
    
    func setupErrorView() {
        
    }
    
    func setupImage() {
        let loader = ImageLoader()
        loader.frame = CGRect.init(x: 10, y: 104, width: view.frame.width - 20, height: (view.frame.height - 104) / 2)
        
        view.addSubview(loader)

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

    }
    
}
