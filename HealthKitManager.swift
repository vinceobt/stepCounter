import Foundation
import HealthKit

@MainActor
final class HealthKitManager: ObservableObject {
    struct StatusMessage {
        let text: String
        let isSuccess: Bool
    }

    @Published private(set) var isSaving = false
    @Published private(set) var message: StatusMessage?

    private let healthStore = HKHealthStore()

    func logSteps(_ count: Int, at date: Date) {
        guard count > 0 else {
            message = StatusMessage(text: "Enter a step count greater than zero.", isSuccess: false)
            return
        }

        guard HKHealthStore.isHealthDataAvailable() else {
            message = StatusMessage(text: "Apple Health is not available on this device.", isSuccess: false)
            return
        }

        isSaving = true
        message = nil

        guard let stepType = HKObjectType.quantityType(forIdentifier: .stepCount) else {
            finish(with: "Step data is unavailable.", success: false)
            return
        }

        healthStore.requestAuthorization(toShare: [stepType], read: []) { [weak self] authorized, error in
            guard let self else { return }

            Task { @MainActor in
                guard authorized, error == nil else {
                    let detail = error?.localizedDescription ?? "Allow step access in Settings and try again."
                    self.finish(with: detail, success: false)
                    return
                }

                let endDate = date.addingTimeInterval(60)
                let quantity = HKQuantity(unit: .count(), doubleValue: Double(count))
                let sample = HKQuantitySample(type: stepType, quantity: quantity, start: date, end: endDate)

                self.healthStore.save(sample) { [weak self] success, error in
                    Task { @MainActor in
                        guard let self else { return }
                        if success {
                            self.finish(with: "Logged \(count.formatted()) steps to Apple Health.", success: true)
                        } else {
                            self.finish(with: error?.localizedDescription ?? "Apple Health could not save this entry.", success: false)
                        }
                    }
                }
            }
        }
    }

    private func finish(with text: String, success: Bool) {
        isSaving = false
        message = StatusMessage(text: text, isSuccess: success)
    }
}
