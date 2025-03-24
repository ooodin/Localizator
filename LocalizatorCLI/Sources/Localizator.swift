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
        
        try await Noora().progressBarStep(message: "Translation in progress...") { progress in
            var completedCount = 0
            
            for (localizableSourceValue, localizableSourceString) in localizableSource.strings {
                if localizableSourceString.shouldTranslate == false {
                    continue
                }
                for languageCode in languageCodes {
                    if let localization = localizableSourceString.localizations[languageCode], localization.stringUnit.state != .new {
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
                    localizableSource.strings[localizableSourceValue]?.localizations = localizations
                }
                
                completedCount += 1
                progress(Double(completedCount / localizableSource.strings.count))
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
