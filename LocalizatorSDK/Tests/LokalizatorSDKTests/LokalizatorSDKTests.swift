import Testing
@testable import LokalizatorSDK

@Test func simpleTranslation() async throws {
    let networkClient = Network()
    let translation = Translation(
        sourceLanguage: "en",
        targetLanguage: "ru",
        sourceText: "apple",
        comment: nil
    )
    let translatedText = try await networkClient.request(
        translation: translation
    )
    #expect(translatedText == "яблоко")
}

@Test func specialSymbolsTranslation() async throws {
    let networkClient = Network()
    let translation = Translation(
        sourceLanguage: "en",
        targetLanguage: "ru",
        sourceText: "%1$@ FREE, then %2$@/week",
        comment: nil
    )
    let translatedText = try await networkClient.request(
        translation: translation
    )
    #expect(translatedText == "%1$@ БЕСПЛАТНО, затем %2$@/неделя")
}
