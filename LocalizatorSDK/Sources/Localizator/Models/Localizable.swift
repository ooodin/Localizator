import Foundation

public typealias Localization = Localizable.StringData.Localization
public typealias StringData = Localizable.StringData
public typealias StringUnit = Localizable.StringData.StringUnit

public struct Localizable: Codable {
    public let sourceLanguage: String
    public let version: String
    public var strings: [String: StringData]
    
    public struct StringData: Codable {
        public let comment: String?
        public let shouldTranslate: Bool?
        public var localizations: [String: Localization]?
        
        public struct Localization: Codable {
            public let stringUnit: StringUnit
            
            public init(stringUnit: StringUnit) {
                self.stringUnit = stringUnit
            }
        }
        public struct StringUnit: Codable {
            public enum Strate: String, Codable {
                case new
                case needsReview = "needs_review"
                case translated
            }
            public let state: Strate
            public let value: String
            
            public init(state: Strate, value: String) {
                self.state = state
                self.value = value
            }
        }
    }
}
