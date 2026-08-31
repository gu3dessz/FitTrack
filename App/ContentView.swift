import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var healthKitManager = HealthKitManager()
    @StateObject private var appState = AppState()
    @State private var selectedTab: Tab = .dashboard
    @AppStorage("hasCompletedOnboarding") 
    private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if !hasCompletedOnboarding {
                OnboardingView(isCompleted: $hasCompletedOnboarding)
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView()
                        .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }
                        .tag(Tab.dashboard)
                    
                    NutritionView()
                        .tabItem { Label("Nutrição", systemImage: "fork.knife") }
                        .tag(Tab.nutrition)
                    
                    WorkoutView()
                        .tabItem { Label("Treino", systemImage: "dumbbell.fill") }
                        .tag(Tab.workout)
                    
                    RecipesView()
                        .tabItem { Label("Receitas", systemImage: "book.fill") }
                        .tag(Tab.recipes)
                    
                    ProfileView()
                        .tabItem { Label("Perfil", systemImage: "person.fill") }
                        .tag(Tab.profile)
                }
            }
        }
        .environmentObject(healthKitManager)
        .environmentObject(appState)
        .onAppear {
            SeedDataManager.seedIfNeeded(modelContext: modelContext)
            healthKitManager.requestAuthorization()
        }
    }
}