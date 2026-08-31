import SwiftUI
import SwiftData

@main
struct FitTrackApp: App {
    let modelContainer: ModelContainer
    
    init() {
        do {
            let schema = Schema([
                UserProfile.self,
                FoodItem.self,
                MealEntry.self,
                DailyLog.self,
                WaterEntry.self,
                Exercise.self,
                WorkoutTemplate.self,
                WorkoutSession.self,
                WorkoutExerciseLog.self,
                Recipe.self,
                RecipeIngredient.self,
                WeightLog.self,
                FoodPhoto.self,
                ShoppingListItem.self
            ])
            let config = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: false,
                cloudKitDatabase: .automatic  // iCloud sync
            )
            modelContainer = try ModelContainer(
                for: schema, 
                configurations: [config]
            )
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(modelContainer)
        }
    }
}