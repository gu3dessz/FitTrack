class ClaudeVisionService: ObservableObject {
    private let apiURL = "https://api.anthropic.com/v1/messages"
    private let model = "claude-opus-4-5"
    
    func analyzeFoodImage(
        image: UIImage,
        useReferenceObject: Bool = false,
        mealContext: String = "refeição"
    ) async throws -> AnalysisResponse {
        
        let base64Image = image.jpegData(compressionQuality: 0.8)!
            .base64EncodedString()
        
        let requestBody: [String: Any] = [
            "model": model,
            "max_tokens": 2048,
            "system": systemPrompt,
            "messages": [[
                "role": "user",
                "content": [
                    ["type": "image", "source": [
                        "type": "base64",
                        "media_type": "image/jpeg",
                        "data": base64Image
                    ]],
                    ["type": "text", "text": userPrompt]
                ]
            ]]
        ]
        
        // Response JSON format:
        // {
        //   "foods": [{
        //     "foodName": "Peito de Frango",
        //     "estimatedAmount": 150,
        //     "confidence": "Alta|Média|Baixa",
        //     "calories": 248,
        //     "protein": 46,
        //     "carbs": 0,
        //     "fat": 5,
        //     "portionDescription": "1 peito médio"
        //   }],
        //   "overallConfidence": "Alta",
        //   "warningMessage": null
        // }
    }
}