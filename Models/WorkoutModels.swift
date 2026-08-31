@Model
final class Exercise {
    var name: String
    var muscleGroup: MuscleGroup
    var secondaryMuscles: [MuscleGroup]
    var equipmentType: EquipmentType
    var trackingType: TrackingType   // weightReps | time | distance
    var descriptionText: String
    var isCustom: Bool
}

struct SetLog: Codable, Identifiable {
    var setNumber: Int
    var weight: Double?    // kg
    var reps: Int?
    var duration: Int?     // seconds
    var isCompleted: Bool
    
    // Epley Formula for 1 Rep Max
    var oneRepMax: Double? {
        guard let weight, let reps, reps > 0, reps <= 36 else { return nil }
        return weight * (1 + Double(reps) / 30.0)
    }
}

@Model
final class WorkoutTemplate {
    var name: String
    var exerciseConfigs: [ExerciseConfig]
    var estimatedDuration: Int    // minutes
    var difficulty: WorkoutDifficulty
    var isCustom: Bool
    var timesUsed: Int
}

struct ExerciseConfig: Codable, Identifiable {
    var exerciseName: String
    var muscleGroup: MuscleGroup?
    var sets: Int
    var reps: Int?
    var duration: Int?    // seconds (for time-based)
    var weight: Double?   // starting weight kg
    var restTime: Int     // seconds
}