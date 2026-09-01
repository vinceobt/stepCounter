# CountUp

A small SwiftUI iPhone app for manually adding step samples to Apple Health.

## Run in Xcode

1. Open `StepsCount.xcodeproj` in Xcode.
2. Select the `StepsCount` target and choose your Apple Developer Team under **Signing & Capabilities**.
3. Confirm the **HealthKit** capability is present. The project includes the HealthKit entitlement and write permission description.
4. Select a physical iPhone as the run destination and build the app.
5. Enter a positive step count, choose the event date and time, then tap **Log Steps**.
6. Approve permission when prompted. Verify the entry in **Health > Browse > Activity > Steps**.

HealthKit data is private and permission must be granted on the device. The app writes manual step samples; it does not replace steps automatically recorded by the iPhone or Apple Watch.
