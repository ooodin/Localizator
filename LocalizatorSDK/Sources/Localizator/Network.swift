import Foundation
import ChatGPTSwift

public final class Network {
    private let apiService: ChatGPTAPI
    
    public init(apiKey: String) {
        self.apiService = ChatGPTAPI(
            apiUrl: ApiParameters.ChatParameters.apiUrl,
            apiKey: apiKey
        )
    }
    
    public func request(translation: Translation) async throws -> String {
        apiService.replaceHistoryList(with: [
            .init(role: "user", content: translation.instructions)
        ])
        let stream = try await apiService.sendMessageStream(
            text: translation.message,
            model: ApiParameters.ChatParameters.model,
            temperature: ApiParameters.ChatParameters.temperature,
            maxTokens: ApiParameters.ChatParameters.maxTokens
        )
        var responseMessageText: String = ""
        
        for try await line in stream {
            responseMessageText += line
        }
        return responseMessageText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
