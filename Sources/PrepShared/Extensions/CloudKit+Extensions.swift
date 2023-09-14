import Foundation
import CloudKit
import OSLog

public let PublicDatabase = CKContainer.prepPublicDatabase

public extension CKQuery {
    static func updatedRecords(of recordType: RecordType) -> CKQuery {
        CKQuery(recordType: recordType.name, predicate: .recordsToDownload(for: recordType))
    }
    
    static func fetchRecord(id: UUID, recordType: RecordType) -> CKQuery {
        CKQuery(recordType: recordType.name, predicate: .record(with: id))
    }
}

public extension CKContainer {
    static var prepContainer: CKContainer {
        CKContainer(identifier: "iCloud.com.ahmdrghb.Prep")
    }
    static var prepPublicDatabase: CKDatabase {
        prepContainer.publicCloudDatabase
    }
    
    static func getCloudKitID() async throws -> String {
    #if targetEnvironment(simulator)
        /// Hardcoded until we can figure out how to get it on the simulator
        return "_105388eaefce030f4e15a7cea035084f"
    #else
        try await withCheckedThrowingContinuation { continuation in
            
            /// Explicitly setting the identifier here to *possibly* mitigate a potential issue mentioned [here](https://twitter.com/ryanashcraft/status/1566579908138061824)
            /// ** Keep an eye on this**
            prepContainer
                .fetchUserRecordID(completionHandler: { (recordID, error) in
                if let name = recordID?.recordName {
                    continuation.resume(returning: name)
                }
                else if let error = error {
                    continuation.resume(throwing: error)
                }
            })
        }
    #endif
    }
}

public extension CKDatabase {

    func record(id: UUID, recordType: RecordType) async throws -> CKRecord? {
        do {
            let query = CKQuery.fetchRecord(id: id, recordType: recordType)
            return try await record(matching: query)
        } catch let error as CKError {
            if error.code == .unknownItem {
                return nil
            } else {
                throw error
            }
        } catch {
            throw error
        }
    }

    func searchWords(containing string: String) async throws -> [CKRecord] {
        do {
            let query = CKQuery(
                recordType: RecordType.searchWord.name,
                predicate: NSPredicate(format: "self contains %@", string)
            )
            return try await records(matching: query)
        } catch let error as CKError {
            if error.code == .unknownItem {
                return []
            } else {
                throw error
            }
        } catch {
            throw error
        }

    }
    
    func findSearchWord(withSingular singular: String) async throws -> CKRecord? {
        /// Get the records containing the `singular` string (this uses a `self contains` predicate in CloudKit,
        /// so the results could have the word in any field (including the spellings array)
        let records = try await searchWords(containing: singular)

        /// Return the first having the same `singular` string
        return records.first(where: {
            $0.singular!.compare(singular, options: .diacriticInsensitive) == .orderedSame
        })
    }

    func record(matching searchWord: SearchWord) async throws -> CKRecord? {
        if let record = try await record(id: searchWord.id, recordType: .searchWord) {
            return record
        }
    
        if let record = try await findSearchWord(withSingular: searchWord.singular) {
            return record
        }
        
        return nil
    }

    func records(matching query: CKQuery) async throws -> [CKRecord] {
        do {
            let (results, _) = try await PublicDatabase.records(matching: query)
            return results.compactMap {
                switch $0.1 {
                case .failure(let error):
                    let logger = Logger(subsystem: "CKDatabase", category: "Query")
                    logger.error("Error fetching record: \(error.localizedDescription)")
                    return nil
                case .success(let record):
                    return record
                }
            }
        } catch let error as CKError {
            if error.code == .unknownItem {
                return []
            } else {
                throw error
            }
        } catch {
            throw error
        }
    }
    
    func record(matching query: CKQuery) async throws -> CKRecord? {
        try await records(matching: query).first
    }
    
//    func saveRecord(_ record: CKRecord) async -> Bool {
//        await withCheckedContinuation { continuation in
//            saveRecord(record) { success in
//                continuation.resume(returning: success)
//            }
//        }
//    }
//
//    func saveRecord(
//        _ record: CKRecord,
//        completion: @escaping ((Bool) -> ())
//    ) {
//        save(record) { record, error in
//            if let error = error {
//                completion(false)
//            } else {
//                completion(true)
//            }
//        }
//    }
}

public extension NSPredicate {
    static func recordsToDownload(for recordType: RecordType) -> NSPredicate {
        if let latestModificationDate = recordType.latestModificationDate {
            /// Always fetch records 1/1000 of a second after the latest one to ensure we don't keep fetching that one
            let date = latestModificationDate.addingTimeInterval(0.001)
            PublicStore.logger.debug("Fetching \(recordType.name) records modified after: \(date)")
            let predicate = NSPredicate(format: "modificationDate > %@", date as NSDate)
            return predicate
        } else {
            PublicStore.logger.debug("Fetching all \(recordType.name) records")
            return NSPredicate(format: "TRUEPREDICATE")
        }
    }
    
    static func record(with id: UUID) -> NSPredicate {
        NSPredicate(format: "id == %@", id.uuidString)
    }
}

public extension Array where Element == CKRecord {
    var latestModifiedDate: Date? {
        self.compactMap { $0.modificationDate }
            .sorted()
            .last
    }
}

public extension Array where Element == (CKRecord.ID, Result<CKRecord, Error>) {
    var records: [CKRecord] {
        self.compactMap {
            switch $0.1 {
            case .success(let record):
                return record
            case .failure:
                return nil
            }
        }
    }
    
    func latestModificationDate(ifAfter date: Date?) -> Date? {
        guard let latestModificationDate = records.latestModifiedDate else {
            return date
        }
        guard let date else { return latestModificationDate }
        return latestModificationDate > date ? latestModificationDate : date
    }
}
