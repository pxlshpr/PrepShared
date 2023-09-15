import Foundation

public enum FoodDataset: Int, Codable {
    case usda = 1
    case ausnut2011_2013
}

public extension FoodDataset {
    var abbreviation: String {
        switch self {
        case .usda:             "USDA"
        case .ausnut2011_2013:  "AUSNUT"
        }
    }
    
    func url(_ id: String?) -> URL? {
        let string = switch self {
        case .usda:
            if let id {
                "https://fdc.nal.usda.gov/fdc-app.html#/food-details/\(id)/nutrients"
            } else {
                "https://fdc.nal.usda.gov/index.html"
            }
        case .ausnut2011_2013:  "https://www.foodstandards.gov.au/science/monitoringnutrients/ausnut/foodnutrient/Pages/default.aspx"
        }
        return URL(string: string)
    }
}
