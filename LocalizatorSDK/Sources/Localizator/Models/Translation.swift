import Foundation

public struct Translation {
    public let sourceLanguage: String
    public let targetLanguage: String
    public let sourceText: String
    public let comment: String?
    
    var message: String {
        if let comment {
            return """
            SourceLanguage: \(sourceLanguage)
            TargetLanguage: \(targetLanguage)
            SourceText: \(sourceText)
            Comment: \(comment)
            """
        } else {
            return """
            SourceLanguage: \(sourceLanguage)
            TargetLanguage: \(targetLanguage)
            SourceText: \(sourceText)
            """
        }
    }
    
    var instructions: String {
        "Instructions: Translate the source text to the target language, very important to KEEP the original capitalization style (uppercase or lowercase) of the source text in the translated string (even because target language orthography is different, this text will be using in UI). Do not add any extra text or explanations. Only provide the translated string. Keep Special Symbols for NSString and Swift String formatting."
    }
    
    public init(sourceLanguage: String, targetLanguage: String, sourceText: String, comment: String?) {
        self.sourceLanguage = sourceLanguage
        self.targetLanguage = targetLanguage
        self.sourceText = sourceText
        self.comment = comment
    }
}
