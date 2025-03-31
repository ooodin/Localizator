import Foundation

typealias Localization = Localizable.StringData.Localization
typealias StringData = Localizable.StringData
typealias StringUnit = Localizable.StringData.StringUnit

struct Localizable: Codable {
    let sourceLanguage: String
    let version: String
    var strings: [String: StringData]
    
    struct StringData: Codable {
        let comment: String?
        let shouldTranslate: Bool?
        var localizations: [String: Localization]?
        
        struct Localization: Codable {
            let stringUnit: StringUnit?
            
            init(stringUnit: StringUnit) {
                self.stringUnit = stringUnit
            }
        }
        struct StringUnit: Codable {
            enum Strate: String, Codable {
                case new
                case needsReview = "needs_review"
                case translated
            }
            let state: Strate
            let value: String
            
            init(state: Strate, value: String) {
                self.state = state
                self.value = value
            }
        }
    }
}
