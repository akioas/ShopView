import UIKit

class DetailsScreen: UIViewController {
   
    var details: DetailsScreenData?
    var id: String?
    
    
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
        view.backgroundColor = .white

        NotificationCenter.default.addObserver(self, selector: #selector(self.getDetails(_:)), name: Notification.Name.details, object: nil)
        if let id = id {
            LoadController().getDetailsScreenData(id: id)
        }
        
    
    }
    
    func setupImage() {
        let loader = ImageLoader()
        loader.frame = view.frame
        
        view.addSubview(loader)

        if let imgUrl = details?.image_url {
            print(imgUrl)
            loader.loadImageWithUrl(URL(string: imgUrl)!)
        }
    }
   
    
    @objc func getDetails(_ notification: Notification) {
        guard let details = notification.userInfo?[Notification.Name.details] as? (DetailsScreenData) else { return }
        self.details = details
        setupImage()

    }
    
}
