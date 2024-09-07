import XCTest
import SwiftUI
@testable import BitflyerAssignment

final class BitflyerAssignmentTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDroppingWidgets() throws {
        var droppedWidgets: [Widget] = []
        let droppedWidgetsBinding = Binding(
            get: { droppedWidgets },
            set: { droppedWidgets = $0 }
        )
        
        var draggingWidget: Widget?
        let draggingWidgetBinding = Binding(
            get: { draggingWidget },
            set: { draggingWidget = $0}
        )
        
        var dropPosition: CGPoint?
        let dropPositionBinding = Binding(
            get: { dropPosition },
            set: { dropPosition = $0}
        )
        
        var settingManager = SettingManager()
        settingManager.widgetRatio = .one
        
        var droppedWidgetsPreview: [Widget] = []
        let droppedWidgetsPreviewBinding = Binding(
            get: { droppedWidgetsPreview },
            set: { droppedWidgetsPreview = $0}
        )
        
        let canvas = CGRectMake(0, 0, 300, 300)
        
        let delegate = DropWidgetDelegate(droppedWidgets: droppedWidgetsBinding, droppedWidgetsPreview: droppedWidgetsPreviewBinding, draggingWidget: draggingWidgetBinding, dropPosition: dropPositionBinding, settingManager: settingManager, canvasFrame: canvas)
        
        
        // nothing in the canvas so far
        // drop at (20,20)
        draggingWidget = Widget(position: CGPointZero, width: 10, height: 10, color: .black)
        dropPosition = CGPoint(x: 20, y: 20)
        
        delegate.transformWidgetLayout()
        XCTAssertEqual(draggingWidget?.height, canvas.height)
        XCTAssertEqual(draggingWidget?.width, canvas.width)
        XCTAssertEqual(draggingWidget?.position, CGPoint(x: 150, y: 150))
        droppedWidgets = droppedWidgetsPreview
        droppedWidgets.append(draggingWidget!)
        
        
        // a widget in the canvas
        // drop on top of it
        draggingWidget = Widget(position: CGPointZero, width: 10, height: 10, color: .black)
        dropPosition = CGPoint(x: 150, y: 20)
        delegate.transformWidgetLayout()
        XCTAssertEqual(draggingWidget?.height, 150)
        XCTAssertEqual(draggingWidget?.width, 300)
        XCTAssertEqual(draggingWidget?.position, CGPoint(x: 150, y: 75))
        
        droppedWidgets = droppedWidgetsPreview
        droppedWidgets.append(draggingWidget!)
        
        // 2 widgets in the canvas
        // drop on the left of the bottom widget
        draggingWidget = Widget(position: CGPointZero, width: 10, height: 10, color: .black)
        dropPosition = CGPoint(x: 20, y: 225)
        delegate.transformWidgetLayout()
        XCTAssertEqual(draggingWidget?.height, 150)
        XCTAssertEqual(draggingWidget?.width, 150)
        XCTAssertEqual(draggingWidget?.position, CGPoint(x: 75, y: 225))
        droppedWidgets = droppedWidgetsPreview
        droppedWidgets.append(draggingWidget!)
        
        // 3 widgets in the canvas
        // drop on right of the top widget
        draggingWidget = Widget(position: CGPointZero, width: 10, height: 10, color: .black)
        dropPosition = CGPoint(x: 200, y: 75)
        delegate.transformWidgetLayout()
        XCTAssertEqual(draggingWidget?.height, 150)
        XCTAssertEqual(draggingWidget?.width, 150)
        XCTAssertEqual(draggingWidget?.position, CGPoint(x: 225, y: 75))
        droppedWidgets = droppedWidgetsPreview
        droppedWidgets.append(draggingWidget!)
        
        // should have 4 widgets on the canvas now
        XCTAssertEqual(droppedWidgets.count, 4)
    }

}
