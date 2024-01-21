import Foundation

public enum RestingEnergyEquation: Int16, Hashable, Codable, CaseIterable {
    case katchMcardle = 1
    case henryOxford
    case mifflinStJeor
    case schofield
    case cunningham
    case rozaShizgal
    case harrisBenedict
}
