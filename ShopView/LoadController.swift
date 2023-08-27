
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
    
    func makeRequest(_ request: URLRequest, config: URLSessionConfiguration) {
        let session = URLSession(configuration: config)
        session.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard error == nil else {
                    print(error)
                    return
                }
                guard let _ = data else {
                    print("Response Data is empty")
                    return
                }
                if let httpResponse = response as? HTTPURLResponse {
                    let status = httpResponse.statusCode
                    if status == 200 {
                        if let data = data {
                            do {
                                let json = try JSONDecoder().decode(MainScreenData.self, from: data)
                                print(json)
                            }
                            catch {
                                print("Error")
                                do {
                                    let json = try JSONSerialization.jsonObject(with: data)
                                    print(json)
                                }
                                catch {
                                    print("Error")
                                }
                            }
                        }
                        
                    } else {
                        print("Error")
                    }
                }
            }
        }.resume()
    }
    
}
