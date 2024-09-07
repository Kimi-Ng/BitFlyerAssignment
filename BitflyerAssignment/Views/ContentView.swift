import SwiftUI

struct ContentView: View {
    @EnvironmentObject var settingManager: SettingManager

    @State private var draggingWidget: Widget?
    @State private var droppedWidgets: [Widget] = []
    @State private var dropPosition: CGPoint?

    private let widgetButtons = [Color(hex: "#00CFFF"),
                                 Color(hex: "#FF5C93"),
                                 Color(hex: "#FFEB3B"),
                                 Color(hex: "#AEEA00"),
                                 Color(hex: "#FF6D00")]

    var body: some View {
        NavigationView {
            VStack {
                CanvasView(
                    droppedWidgets: $droppedWidgets,
                    draggingWiget: $draggingWidget,
                    dropPosition: $dropPosition,
                    settingManager: settingManager)
                .padding(.top, 30)

                Spacer()

                WidgetPanel(
                    draggingWidget: $draggingWidget,
                    widgets: widgetButtons)
                .padding(.bottom, 30)

            }
            .padding(.horizontal)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color(hex: "#808080"))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Drag and Drop!")
                        .font(.largeTitle)
                        .foregroundColor(Color(hex: "#808080"))
                }
            }
        }
    }
}



#Preview {
    ContentView().environmentObject(SettingManager())
}

