import UIKit
import OSLog

private let logger = Logger(subsystem: "ImageManager", category: "")

struct ImageManager {

    static var imagesURL: URL {
        documentsURL.appendingPathComponent("Images")
    }
    
    static func url(for id: UUID) -> URL {
        imagesURL.appendingPathComponent("\(id.uuidString).heic")
    }
    
    static func legacyURL(for id: UUID) -> URL? {
        imagesURL.appendingPathComponent("\(id.uuidString).jpg")
//        Bundle.main.url(forResource: id.uuidString, withExtension: "jpg")
    }
    
    static func load(_ id: UUID) -> UIImage? {
        if let image = load(url(for: id)) {
            return image
        }
        if let url = legacyURL(for: id) {
            return load(url)
        }
        return nil
    }

    static func imageExists(_ id: UUID) -> Bool {
        let url = url(for: id)
        if FileManager.default.fileExists(atPath: url.path()) {
            return true
        }
        guard let legacyURL = legacyURL(for: id) else {
            return false
        }
        return FileManager.default.fileExists(atPath: legacyURL.path())
    }

    static func delete(_ id: UUID) {
        let didDelete = delete(url(for: id))
        if !didDelete, let url = legacyURL(for: id) {
            let _ = delete(url)
        }
    }
}

extension ImageManager {
    
    static func load(_ url: URL) -> UIImage? {
        do {
            logger.debug("Loading image from URL: \(url.absoluteString, privacy: .public)")
            
            let data = try Data(contentsOf: url)
            guard let image = UIImage(data: data) else {
                logger.error("Error reading image data for: \(url.absoluteString, privacy: .public)")
                return nil
            }
            logger.debug("Loaded image: \(url.absoluteString, privacy: .public)")
            return image
        } catch {
            logger.error("Error loading image: \(url.absoluteString, privacy: .public)")
            return nil
        }
    }
    
    static func delete(_ url: URL) -> Bool {
        do {
            logger.debug("Deleting image: \(url.absoluteString, privacy: .public)")
            try FileManager.default.removeItem(at: url)
            logger.debug("Deleted image: \(url.absoluteString, privacy: .public)")
            return true
        } catch {
            logger.error("Error deleting image: \(url.absoluteString, privacy: .public)")
            return false
        }
    }

    static func save(image: UIImage, id: UUID) {
        guard let data = image.heicData() else {
            logger.error("Couldn't get HEIC data for image: \(id, privacy: .public)")
            return
        }
        do {
            logger.debug("Saving image: \(id, privacy: .public)")
            
            if !FileManager.default.fileExists(atPath: imagesURL.path()) {
                logger.debug("Images directory does not exist, creating...")
                try FileManager.default.createDirectory(
                    atPath: imagesURL.path(),
                    withIntermediateDirectories: true
                )
            } else {
                logger.debug("Images directory exists")
            }
            
            try data.write(to: url(for: id))
            logger.debug("Image saved: \(id, privacy: .public)")
        } catch {
            logger.error("Error saving image: \(id, privacy: .public)")
        }
    }
}
