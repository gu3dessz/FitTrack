@Model
final class FoodItem {
    var id: UUID
    var name: String
    var brand: String?
    var servingSize: Double       // grams
    var servingDescription: String // "1 fatia", "100g"
    var calories: Double          // kcal per serving
    var protein: Double           // g per serving
    var carbs: Double             // g per serving
    var fat: Double               // g per serving
    var fiber: Double?
    var sugar: Double?
    var category: FoodCategory
    var isCustom: Bool
    
    func nutritionForAmount(_ amount: Double) -> NutritionInfo {
        let ratio = amount / servingSize
        return NutritionInfo(
            calories: calories * ratio,
            protein: protein * ratio,
            carbs: carbs * ratio,
            fat: fat * ratio,
            fiber: (fiber ?? 0) * ratio,
            sugar: (sugar ?? 0) * ratio
        )
    }
}

@Model
final class MealEntry {
    var food: FoodItem?
    var recipe: Recipe?
    var mealType: MealType
    var amount: Double
    var date: Date
    
    var nutrition: NutritionInfo {
        food?.nutritionForAmount(amount) ?? recipe?.nutritionPerServing ?? .zero
    }
}

@Model
final class DailyLog {
    var date: Date
    var mealEntries: [MealEntry]
    var waterEntries: [WaterEntry]
    var workoutSessions: [WorkoutSession]
    
    var totalNutrition: NutritionInfo {
        mealEntries.reduce(.zero) { $0 + $1.nutrition }
    }
}