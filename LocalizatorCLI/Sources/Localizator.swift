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
        let localizator = LocalizatorSDK.Mediator(apiKey: apiKey)
        let eventStream = localizator.localize(filePath: filePath, languageCodes: languageCodes)
        
        do {
            try await Noora().progressBarStep(message: "Translation progress") { progress in
                for try await event in eventStream {
                    switch event {
                    case let .warning(message):
                        Noora().warning(
                            .alert("Warning: \(message)")
                        )
                    case let .progress(current, total):
                        progress(Double(current)/Double(total))
                    }
                }
            }
            Noora().success(
                .alert("Translations have been written successfully!")
            )
        } catch {
            Noora().error(
                .alert("Ooops! An error occurred: \(error.localizedDescription)")
            )
        }
    }
}
