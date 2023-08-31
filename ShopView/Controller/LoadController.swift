
import Foundation

class LoadController {
    
    let mainUrl = "https://www.avito.st/s/interns-ios/main-page.json"
    let detailsUrl = "https://www.avito.st/s/interns-ios/details/{itemId}.json"
    let replaceDetailsUrl = "{itemId}"
    
    enum Screens {
        case main
        case details
    }
    
    func getMainScreenData() {
        let url = URL(string: mainUrl)!
        let request = URLRequest(url: url)
        makeRequest(request, screen: .main)
    }
    
    func getDetailsScreenData(id: String) {
        let url = URL(string: detailsUrl.replacingOccurrences(of: replaceDetailsUrl, with: id))!
        let request = URLRequest(url: url)
        makeRequest(request, screen: .details)
    }
    
    func sendError() {
        NotificationCenter.default.post(name: .error, object: nil)
    }
    
    func makeRequest(_ request: URLRequest, screen: Screens) {
        let config = URLSessionConfiguration.default
        
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    self.sendError()
                    return
                }
                guard let _ = data else {
                    self.sendError()
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    let status = httpResponse.statusCode
                    if status == 200 {
                        if let data = data {
                            do {
                                switch screen {
                                case .main:
                                    let json = try JSONDecoder().decode(MainScreenData.self, from: data)
                                    let userInfo = [ Notification.Name.advertisements : json.advertisements?.sorted{$0.id < $1.id} ]
                                    NotificationCenter.default.post(name: .advertisements, object: nil, userInfo: userInfo as [AnyHashable : Any] )
                                case .details:
                                    let json = try JSONDecoder().decode(DetailsScreenData.self, from: data)
                                    let userInfo = [ Notification.Name.details : json ]
                                    NotificationCenter.default.post(name: .details, object: nil, userInfo: userInfo as [AnyHashable : Any] )
                                }
                            }
                            catch {
                                self.sendError()
                            }
                        }
                        
                    } else {
                        self.sendError()
                    }
                }
            }
        }.resume()
    }
    
}
extension Notification.Name {
    public static let error = Notification.Name(rawValue: "error")
    public static let advertisements = Notification.Name(rawValue: "advertisements")
    public static let details = Notification.Name(rawValue: "details")
}
