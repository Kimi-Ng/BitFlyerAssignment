import SwiftUI

@main
struct BitflyerAssignmentApp: App {
    @StateObject private var settingManager = SettingManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(settingManager)
        }
    }
}
