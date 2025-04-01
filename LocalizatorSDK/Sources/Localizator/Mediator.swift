import Foundation

public final class Mediator {
    public enum ProgressEvent {
        case progress(current: Int, total: Int)
        case warning(message: String)
    }
    
    let network: Network
    
    public init(apiKey: String, apiUrl: String? = nil) {
        network = Network(apiKey: apiKey)
    }
    
    public func localize(
        filePath: String,
        languageCodes: [String]
    ) -> AsyncThrowingStream<ProgressEvent, any Error> {
        AsyncThrowingStream { [network] continuation in
            Task {
                var localizableSource: Localizable
                
                do {
                    localizableSource = try FileUtility.readLocalizableFile(path: filePath)
                } catch {
                    continuation.finish(throwing: error)
                    return
                }
                                
                for (index, (localizableSourceValue, localizableSourceString)) in localizableSource.strings.enumerated() {
                    continuation.yield(.progress(current: index, total: localizableSource.strings.count))
                    
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
                        let translatedText: String
                        
                        do {
                            translatedText = try await network.request(translation: translation)
                        } catch {
                            continuation.yield(.warning(message: "Translation key '\(localizableSourceValue)' fetch failure - \(error.localizedDescription)"))
                            continue
                        }
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
                
                do {
                    try FileUtility.writeLocalizableFile(data: localizableSource, at: filePath)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
}
