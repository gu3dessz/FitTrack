@Model
final class UserProfile {
    var id: UUID
    var name: String
    var age: Int
    var weight: Double    // kg
    var height: Double    // cm
    var sex: BiologicalSex
    var activityLevel: ActivityLevel
    var goal: FitnessGoal
    var targetCalories: Double
    var targetProtein: Double
    var targetCarbs: Double
    var targetFat: Double
    var targetWater: Double    // ml
    
    // Mifflin-St Jeor Equation
    static func calculateTDEE(
        weight: Double, height: Double, age: Int,
        sex: BiologicalSex, activityLevel: ActivityLevel, 
        goal: FitnessGoal
    ) -> (calories: Double, protein: Double, carbs: Double, fat: Double) {
        
        // BMR calculation
        let bmr: Double
        if sex == .male {
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) + 5
        } else {
            bmr = 10 * weight + 6.25 * height - 5 * Double(age) - 161
        }
        
        // Apply activity multiplier
        let tdee = bmr * activityLevel.multiplier
        
        // Adjust for goal
        let targetCalories: Double
        switch goal {
        case .loseWeight:  targetCalories = tdee - 500  // -500 kcal deficit
        case .maintain:    targetCalories = tdee
        case .gainMuscle:  targetCalories = tdee + 300  // +300 kcal surplus
        }
        
        // Macro split
        let protein = weight * (goal == .gainMuscle ? 2.2 : 1.6) // g/kg
        let fat = targetCalories * 0.25 / 9   // 25% of calories
        let carbs = (targetCalories - (protein * 4) - (fat * 9)) / 4
        
        return (targetCalories, protein, carbs, fat)
    }
}