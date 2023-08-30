import UIKit

class DetailsScreen: UIViewController {
   
    var details: DetailsScreenData?
    
    
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

        NotificationCenter.default.addObserver(self, selector: #selector(self.getDetails(_:)), name: Notification.Name.advertisements, object: nil)
        LoadController().getMainScreenData()
        
        
    
    }
   
    
    @objc func getDetails(_ notification: Notification) {
        
        guard let details = notification.userInfo?[Notification.Name.advertisements] as? (DetailsScreenData) else { return }
        self.details = details
    
    }
    
}
