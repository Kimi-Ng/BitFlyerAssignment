import SwiftUI

enum Zone {
    case top
    case left
    case right
    case bottom
}


// A drop area for widgets
struct CanvasView: View {
    @Binding var droppedWidgets: [Widget]
    @Binding var draggingWiget: Widget?
    @Binding var dropPosition: CGPoint?
    @ObservedObject var settingManager: SettingManager
    @State private var droppedWidgetsPreview: [Widget] = []
  
    private func shape(for theme: WidgetTheme) -> some Shape {
       switch theme {
       case .circle:
           return AnyShape(Circle())
       case .rectangle:
           return AnyShape(RoundedRectangle(cornerRadius: 36))
       }
   }
    
    private var hideWelcomeView: Bool {
        return !droppedWidgets.isEmpty
    }
    
    private func welcomeView() -> some View {
        VStack (alignment: .center) {
            Image("welcomeHand").resizable().scaledToFit().frame(width: 100, height: 100).padding()
            Text("Hi!\nDrag and drop your widgets to unleash your creativity!").foregroundColor(Color(hex: "#808080"))
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    
                    Rectangle()
                        .fill(.white)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(
                            welcomeView().opacity(hideWelcomeView ? 0 : 1)
                        )

                    // render dropped widgets
                    let widgetsToRender = droppedWidgetsPreview.isEmpty ? droppedWidgets : droppedWidgetsPreview
                    
                    ForEach(widgetsToRender, id: \.self) { widget in
                        ZStack {
                            shape(for: settingManager.widgetTheme)
                                .fill(widget.color)
                                .frame(width: widget.width, height: widget.height)
                                .position(widget.position)
                            Text(String(format: "%.02f",widget.weight)+"%").opacity(settingManager.showRatioInfo ? 0.5: 0).position(widget.position)
                        }
                    }
                    
                }
                .onDrop(of: [.text], delegate: DropWidgetDelegate(droppedWidgets: $droppedWidgets, droppedWidgetsPreview: $droppedWidgetsPreview, draggingWidget: $draggingWiget, dropPosition: $dropPosition, settingManager: settingManager, canvasFrame: geometry.frame(in: .local)))
                .overlay(
                    RoundedRectangle(cornerRadius: 10).stroke(style: StrokeStyle(lineWidth: 5, dash: [5, 5])).foregroundColor(Color(hex:"#ededed"))
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1.0, contentMode: .fit)
    }
}



struct DropWidgetDelegate: DropDelegate {
    @Binding var droppedWidgets: [Widget]
    @Binding var droppedWidgetsPreview: [Widget]
    @Binding var draggingWidget: Widget?
    @Binding var dropPosition: CGPoint?
    @ObservedObject var settingManager: SettingManager
    var canvasFrame: CGRect = CGRectZero

    
    func performDrop(info: DropInfo) -> Bool {
        // Finalize the drop
        guard let widget = draggingWidget else { return false }
        
        DispatchQueue.main.async {
            self.droppedWidgets = self.droppedWidgetsPreview
            self.droppedWidgets.append(widget)
            self.droppedWidgetsPreview = []
            self.draggingWidget = nil
        }
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        dropPosition = info.location
        transformWidgetLayout()
        
    }
    
    func dropExited(info: DropInfo) {
        dropPosition = nil
        droppedWidgetsPreview = []
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        self.dropPosition = info.location
        transformWidgetLayout()
        return nil
    }
    
    // calculate the size of new widget if dropping to canvas
    // calculate the new size and position of original dropped widgets afected by the new widget
    func transformWidgetLayout() {
        guard let _ = dropPosition, var widget = draggingWidget else { return }

        if droppedWidgets.isEmpty {
            // no widgets on the canvas so far, new widget fills the whole canvas
            widget.position = CGPoint(x: canvasFrame.midX, y: canvasFrame.midY)
            widget.width = canvasFrame.width
            widget.height = canvasFrame.height
            self.draggingWidget = widget
        } else {
            transformOverlappedWidget()
        }
    }
    
    // check if dragging position falls in any dropped widget - for instance it falls in widget_x
    // calculate the new size & postion of widget_x, and update it to preview list
    // calculate the size & postion of the dragging widget
    // update widget_x to preview array for display
    func transformOverlappedWidget() {
        guard let position = dropPosition, var draggingWidget = draggingWidget else { return }
        
        droppedWidgetsPreview = droppedWidgets
    
        for (i, widget) in droppedWidgets.enumerated() {
            var transformedWidget = widget
            let ratio = settingManager.widgetRatio.info.ratio
            
            if let zone = fallsIn(position: position, widget: widget) {
                switch zone {
                case .top:
                    // transofrm the original widget and move it to the bottom
                    transformedWidget.height = widget.height * ratio / (ratio + 1)
                    let originY = widget.position.y - widget.height / 2
                    transformedWidget.position = CGPoint(x: widget.position.x, y: originY + widget.height - transformedWidget.height / 2)
                    
                    // place the new widget on top
                    draggingWidget.width = widget.width
                    draggingWidget.height = widget.height / (ratio + 1)
                    draggingWidget.position = CGPoint(x: widget.position.x, y: originY + draggingWidget.height / 2)

                case .left:
                    // transofrm the original widget and move it to right
                    transformedWidget.width = widget.width * ratio / (ratio + 1)
                    let originX = widget.position.x - widget.width / 2
                    transformedWidget.position = CGPoint(x: originX + widget.width - transformedWidget.width / 2, y: widget.position.y)
                    
                    // place the new widget on left
                    draggingWidget.width = widget.width / (ratio + 1)
                    draggingWidget.height = widget.height
                    draggingWidget.position = CGPoint(x: originX + draggingWidget.width / 2, y: widget.position.y)

                case .right:
                    // transform the original widget and move it to left
                    transformedWidget.width = widget.width * ratio / (ratio + 1)
                    let originX = widget.position.x - widget.width / 2
                    transformedWidget.position = CGPoint(x: originX + transformedWidget.width / 2, y: widget.position.y)

                    // place the new widget on right
                    draggingWidget.width = widget.width / (ratio + 1)
                    draggingWidget.height = widget.height
                    draggingWidget.position = CGPoint(x: originX + transformedWidget.width + draggingWidget.width / 2, y: widget.position.y)

                case .bottom:
                    // transofrm the original widget and move it to up
                    transformedWidget.height = widget.height * ratio / (ratio + 1)
                    let originY = widget.position.y - widget.height / 2
                    transformedWidget.position = CGPoint(x: widget.position.x, y: originY + transformedWidget.height / 2)

                    // place the new widget at the bottom
                    draggingWidget.width = widget.width
                    draggingWidget.height = widget.height / (ratio + 1)
                    draggingWidget.position = CGPoint(x: widget.position.x, y: originY + widget.height - draggingWidget.height / 2)
                }

                let ratio = settingManager.widgetRatio.info.ratio
                transformedWidget.weight *= ratio / (ratio + 1)
                draggingWidget.weight = widget.weight - transformedWidget.weight
                self.draggingWidget = draggingWidget
                droppedWidgetsPreview[i] = transformedWidget
                return
            }
        }
        
        droppedWidgetsPreview = []
    }
    
    // a widget is divided into 4 zones diagonally, check which zone the postion falls in, return nil if not
    func fallsIn(position: CGPoint, widget: Widget) -> Zone? {
        if (widget.position.x - widget.width / 2...widget.position.x + widget.width / 2).contains(position.x)
            && (widget.position.y - widget.height/2...widget.position.y + widget.height / 2).contains(position.y) {
            
            // (x1,y1) represents top-left corner
            let x1 = widget.position.x - widget.width / 2
            let y1 = widget.position.y - widget.height / 2
            let m1 = (widget.position.y - y1) / (widget.position.x - x1)
            let m2 = (y1 - widget.position.y) / (widget.position.x - x1)
            let c1 = y1 - m1 * x1
            let c2 = widget.position.y - m2 * widget.position.x
            
            if position.y < m1 * position.x + c1 && position.y >  m2 * position.x + c2 {
                return .right
            } else if position.y > m1 * position.x + c1 && position.y < m2 * position.x + c2 {
                return .left
            } else if position.y > m1 * position.x + c1 && position.y > m2 * position.x + c2 {
                return .bottom
            } else {
                return .top
            }
        }
        return nil
    }

}
