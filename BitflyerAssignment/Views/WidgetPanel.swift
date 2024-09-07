import SwiftUI

struct WidgetPanel: View {
    @Binding var draggingWidget: Widget?

    private let widgetHeight: CGFloat = 50
    private let widgetWidth: CGFloat = 50
    private let widgets: [Color]

    
    
    init(draggingWidget: Binding<Widget?>, widgets: [Color?]) {
        self._draggingWidget = draggingWidget
        self.widgets = widgets.compactMap { $0 }
    }

    
    var body: some View {
        HStack (spacing: 10){
            ForEach(widgets, id:\.self) { color in
                RoundedRectangle(cornerRadius: widgetWidth/2, style: .continuous)
                    .foregroundColor(color)
                    .frame(width: widgetWidth, height: widgetHeight)
                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: widgetWidth/2, style: .continuous))
                    .onDrag({
                        draggingWidget = Widget(position: CGPointZero, width: 0, height: 0, color: color)
                        
                        return NSItemProvider()
                    })
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 40).fill(.white).shadow(color: .gray, radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x:0, y:5)
        )
    }
}
