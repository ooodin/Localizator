import Foundation

public enum FileUtilityError: Error {
    case fileIsNotExist
    case fileIsEmpty
}

public enum FileUtility {
    public static func readLocalizableFile(path: String) throws -> Localizable {
        guard FileManager.default.fileExists(atPath: path) else {
            throw FileUtilityError.fileIsNotExist
        }
        guard let fileData = FileManager.default.contents(atPath: path) else {
            throw FileUtilityError.fileIsEmpty
        }
        return try JSONDecoder().decode(Localizable.self, from: fileData)
    }

    public static func writeLocalizableFile(data: Localizable, at path: String) throws {
        let fileData = try JSONEncoder().encode(data)
        try fileData.write(to: URL(fileURLWithPath: path))
    }
}
