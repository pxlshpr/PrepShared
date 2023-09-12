import Foundation

var documentsURL: URL {
    FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}

