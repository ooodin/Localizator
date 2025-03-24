import Foundation
import ChatGPTSwift

enum ApiParameters {
    enum ChatParameters {
        static let apiUrl = "https://api.openai.com/v1"
        static let maxTokens: Int = 1000
        static let temperature: Double = 1.0
        static let model: ChatGPTModel = .gpt_hyphen_4o_hyphen_mini
    }
}
