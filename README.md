# capacitor-choose-video
Select a video with Capacitor

# iOS installation
The iOS side ships as both a Swift package (`Package.swift`) and a CocoaPods spec
(`AthleticnetCapacitorChooseVideo.podspec`), so it works with either dependency manager:

- **Swift Package Manager** (Capacitor 8 default): `npx cap sync ios` picks up `Package.swift` from
  `node_modules` and adds the plugin to your app's `CapApp-SPM` package. Nothing else to configure.
- **CocoaPods**: `npx cap sync ios` adds the pod from the podspec as before.

# Making a new update
1. Make all commits
2. Run `npm version patch`
3. Run `npm publish`

- Use v0.0.8 with Capacitor 2
- Use v0.0.10 with Capacitor 3
- Use v5.0.5 with Capacitor 5
- Use v6.0.0 with Capacitor 6
- Use v7.0.0 with Capacitor 7
- Use v8.x with Capacitor 8 (iOS via SPM or CocoaPods)
