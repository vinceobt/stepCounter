import SwiftUI

struct ContentView: View {
    @StateObject private var healthKit = HealthKitManager()
    @State private var stepsText = ""
    @State private var loggedAt = Date()
    @FocusState private var isStepsFieldFocused: Bool

    private var stepCount: Int? {
        guard let value = Int(stepsText), value > 0 else { return nil }
        return value
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("0", text: $stepsText)
                        .keyboardType(.numberPad)
                        .focused($isStepsFieldFocused)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.center)
                        .accessibilityLabel("Number of steps")
                } header: {
                    Text("Steps to log")
                } footer: {
                    Text("This entry will be added to Apple Health as a manual step sample.")
                }

                Section("When") {
                    DatePicker("Date and time", selection: $loggedAt, in: ...Date())
                }

                Section {
                    Button {
                        isStepsFieldFocused = false
                        healthKit.logSteps(stepCount!, at: loggedAt)
                    } label: {
                        HStack {
                            Spacer()
                            if healthKit.isSaving {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "figure.walk")
                                Text("Log Steps")
                                    .fontWeight(.semibold)
                            }
                            Spacer()
                        }
                    }
                    .disabled(stepCount == nil || healthKit.isSaving)
                    .listRowBackground(Color.accentColor)
                    .foregroundStyle(.white)
                }

                if let message = healthKit.message {
                    Section {
                        Label(message.text, systemImage: message.isSuccess ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                            .foregroundStyle(message.isSuccess ? .green : .red)
                    }
                }
            }
            .navigationTitle("CountUp")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isStepsFieldFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
