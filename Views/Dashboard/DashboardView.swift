struct DashboardView: View {
    @EnvironmentObject var healthKitManager: HealthKitManager
    @State private var todayLog: DailyLog?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Calorie Balance Ring
                    ZStack {
                        Circle()
                            .stroke(Color.accentColor.opacity(0.15), lineWidth: 12)
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .trim(from: 0, to: calorieProgress)
                            .stroke(Color.accentColor, 
                                    style: StrokeStyle(lineWidth: 12, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                            .animation(.spring(duration: 1), value: calorieProgress)
                        
                        VStack {
                            Text("\(Int(caloriesRemaining))")
                                .font(.title2).fontWeight(.bold)
                            Text("restantes").font(.caption2)
                        }
                    }
                    
                    // Macro Rings (P, H, G)
                    HStack(spacing: 16) {
                        MiniRing(progress: protein / targetProtein, 
                                 color: .blue, label: "P")
                        MiniRing(progress: carbs / targetCarbs, 
                                 color: .orange, label: "H")
                        MiniRing(progress: fat / targetFat, 
                                 color: .yellow, label: "G")
                    }
                    
                    // Activity from HealthKit
                    ActivityTile(
                        icon: "figure.walk",
                        value: healthKitManager.stepCountFormatted,
                        label: "Passos",
                        progress: healthKitManager.stepProgress
                    )
                    
                    // Water intake tracker
                    waterCard
                    
                    // Weekly steps chart (Swift Charts)
                    Chart(healthKitManager.weeklySteps) { data in
                        BarMark(x: .value("Dia", data.dayLabel),
                                y: .value("Passos", data.steps))
                    }
                }
            }
        }
    }
}