import Foundation


struct DetailsScreenData: Decodable {
    var id: Int?
    var title: String?
    var price: String?
    var location: String?
    var image_url: String?
    var created_date: String?
    var description: String?
    var email: String?
    var phone_number: String?
    var address: String?
}
