import Foundation


struct MainScreenData: Decodable {
    var advertisements: [Advertisement]?
}

struct Advertisement: Decodable {
    var id: String?
    var title: String?
    var price: String?
    var location: String?
    var image_url: String?
    var created_date: String?
}
