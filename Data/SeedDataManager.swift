struct FoodCameraView: View {
    @StateObject private var claudeService = ClaudeVisionService()
    @State private var selectedImage: UIImage?
    @State private var analysisResult: AnalysisResponse?
    @State private var editableFoods: [EditableFoodResult] = []
    @State private var useReferenceObject = false
    
    var body: some View {
        ScrollView {
            // 1. Seleção de imagem (câmara ou galeria)
            PhotosPicker(selection: $selectedItem) {
                Label("Escolher Foto", systemImage: "photo")
            }
            
            // 2. Toggle para referência visual
            Toggle("Usar Referência Visual", isOn: $useReferenceObject)
            // Quando ativo: usa tamanho do prato/talheres
            // para calibrar estimativas de porção
            
            // 3. Durante análise
            if claudeService.isAnalyzing {
                ProgressView("A analisar a refeição...")
            }
            
            // 4. Resultados editáveis
            ForEach($editableFoods) { $food in
                FoodResultCard(editableFood: $food)
                // - Checkbox para incluir/excluir
                // - Campo de quantidade editável
                // - Badge de confiança (Alta/Média/Baixa)
                // - Aviso se confiança for baixa
            }
            
            // 5. Aviso de baixa confiança
            if analysisResult?.overallConfidence == .low {
                WarningBanner(
                    message: "Confiança baixa. Por favor verifica os alimentos identificados."
                )
            }
            
            // 6. Confirmar e adicionar ao registo
            Button("Confirmar") { confirmSelection() }
        }
    }
}