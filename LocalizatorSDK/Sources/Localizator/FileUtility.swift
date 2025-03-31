import Foundation

enum FileUtilityError: Error {
    case fileIsNotExist
    case fileIsEmpty
}

enum FileUtility {
    static func readLocalizableFile(path: String) throws -> Localizable {
        guard FileManager.default.fileExists(atPath: path) else {
            throw FileUtilityError.fileIsNotExist
        }
        guard let fileData = FileManager.default.contents(atPath: path) else {
            throw FileUtilityError.fileIsEmpty
        }
        return try JSONDecoder().decode(Localizable.self, from: fileData)
    }

    static func writeLocalizableFile(data: Localizable, at path: String) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let fileData = try encoder.encode(data)
        try fileData.write(to: URL(fileURLWithPath: path))
    }
}
