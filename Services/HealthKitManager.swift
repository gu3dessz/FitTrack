@MainActor
class HealthKitManager: ObservableObject {
    private let healthStore: HKHealthStore?
    
    @Published var stepCount: Double = 0
    @Published var activeCalories: Double = 0
    @Published var restingCalories: Double = 0
    @Published var heartRate: Double = 0
    @Published var distance: Double = 0
    @Published var exerciseMinutes: Double = 0
    @Published var weeklySteps: [DailyStepData] = []
    
    func requestAuthorization() {
        let typesToRead: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .appleExerciseTime)!
        ]
        
        healthStore?.requestAuthorization(
            toShare: [HKObjectType.workoutType()],
            read: typesToRead
        ) { success, _ in
            if success { self.fetchTodayData() }
        }
    }
    
    private func fetchStepCount() {
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay, end: Date()
        )
        let query = HKStatisticsQuery(
            quantityType: HKQuantityType(.stepCount),
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            Task { @MainActor in
                self.stepCount = result?.sumQuantity()?.doubleValue(for: .count()) ?? 0
            }
        }
        healthStore?.execute(query)
    }
}