import SwiftUI

/*
 * configurable settings:
 *   widget theme - default is rectangle
 *   widget ratio - default is 1:1
 *   show widget percentage info - default is turned off
 */

class SettingManager: ObservableObject {
    @AppStorage("widgetTheme") var widgetTheme: WidgetTheme = .rectangle
    @AppStorage("widgetRatio") var widgetRatio: WidgetRatio = .one
    @AppStorage("showRatioInfo") var showRatioInfo = false
}

struct SettingsView: View {
    
    @EnvironmentObject var settingManager: SettingManager
    
    var body: some View {
        Form {
            Section(header: Text("Widget Theme")) {
                Picker("Theme", selection: settingManager.$widgetTheme) {
                    ForEach(WidgetTheme.allCases) { theme in
                        Text(theme.rawValue).tag(theme)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Widget Ratio")) {
                Picker("Ratio", selection: settingManager.$widgetRatio) {
                    ForEach(WidgetRatio.allCases) { ratio in
                        Text(ratio.info.description).tag(ratio)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            Section(header: Text("Widget Information")) {
                Toggle(isOn: settingManager.$showRatioInfo) {
                    Text("Display widget area ratio")
                }
            }
        }
        .navigationTitle("Settings")
    }
}
