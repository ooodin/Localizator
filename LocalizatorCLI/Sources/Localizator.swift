import ArgumentParser
import LocalizatorSDK
import Noora

@main
struct Localizator: AsyncParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "Generate a Localizable strings file")
    
    @Argument(help: "OpenAI API key")
    private var apiKey: String
    
    @Argument(
        help: "File path to exist localizable strings file.",
        completion: .file()
    )
    private var filePath: String
    
    @Argument(parsing: .allUnrecognized, help: "Target language codes")
    private var languageCodes: [String]
    
    func run() async throws {
        Noora().warning(
            .alert("API Key: \(apiKey)"),
            .alert("File path: \(filePath)"),
            .alert("Target Languages: \(languageCodes.joined(separator: ", "))")
        )
        
        let network = Network(apiKey: apiKey)
        var localizableSource: Localizable
        
        do {
            localizableSource = try FileUtility.readLocalizableFile(path: filePath)
        } catch {
            Noora().error(
                .alert("File read failure - \(error.localizedDescription)")
            )
            return
        }
        
        try await Noora().progressBarStep(message: "Translation progress") { progress in
            var completedCount = 0
            
            for (localizableSourceValue, localizableSourceString) in localizableSource.strings {
                completedCount += 1
                progress(Double(completedCount) / Double(localizableSource.strings.count))
                
                if localizableSourceString.shouldTranslate == false ||
                    localizableSourceValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    continue
                }
                for languageCode in languageCodes {
                    if let stringUnit = localizableSourceString.localizations?[languageCode]?.stringUnit, stringUnit.state != .new {
                        continue
                    }
                    let translation = Translation(
                        sourceLanguage: localizableSource.sourceLanguage,
                        targetLanguage: languageCode,
                        sourceText: localizableSourceValue,
                        comment: localizableSourceString.comment
                    )
                    let translatedText = try await network.request(translation: translation)
                    var localizations = localizableSource.strings[localizableSourceValue]?.localizations ?? [:]
                    
                    localizations[languageCode] = Localization(
                        stringUnit: .init(state: .needsReview, value: translatedText)
                    )
                    localizations[localizableSource.sourceLanguage] = Localization(
                        stringUnit: .init(state: .translated, value: localizableSourceValue)
                    )
                    localizableSource.strings[localizableSourceValue]?.localizations = localizations
                }
            }
        }
                
        do {
            try FileUtility.writeLocalizableFile(data: localizableSource, at: filePath)
        } catch {
            Noora().error(
                .alert("File write failure - \(error.localizedDescription)")
            )
            return
        }

        Noora().success(
            .alert("Translations have been written successfully!")
        )
    }
}
