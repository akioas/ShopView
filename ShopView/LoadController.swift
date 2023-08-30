
import Foundation

class LoadController {
    
    let mainUrl = "https://www.avito.st/s/interns-ios/main-page.json"
    let detailsUrl = "https://www.avito.st/s/interns-ios/details/{itemId}.json"
    let replaceDetailsUrl = "{itemId}"
    
    func getMainScreenData() {
        let url = URL(string: mainUrl)!
        var request = URLRequest(url: url)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 20
        let config = URLSessionConfiguration.default
        makeRequest(request, config: config)
    }
    
    func sendError() {
        NotificationCenter.default.post(name: .error, object: nil)
    }
    
    func makeRequest(_ request: URLRequest, config: URLSessionConfiguration) {
        
        
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
                                print(data)
                                let json = try JSONDecoder().decode(MainScreenData.self, from: data)

                                let userInfo = [ Notification.Name.advertisments : json.advertisements ]
                                NotificationCenter.default.post(name: .advertisments, object: nil, userInfo: userInfo as [AnyHashable : Any] )
                            }
                            catch {
                                self.sendError()
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data)
                                    print(json)
                                }
                                catch {
                                    self.sendError()
                                }
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
    public static let advertisments = Notification.Name(rawValue: "advertisments")
}
