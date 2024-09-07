import SwiftUI

// appearance of widget on canvas
enum WidgetTheme: String, CaseIterable, Identifiable {
    case rectangle
    case circle
    
    var id: String { self.rawValue }
}

// ratio between the transformed widgetd and the new dropped widget
enum WidgetRatio: String, CaseIterable, Identifiable {
    case half
    case one
    case two
    
    var id: String { self.rawValue }
    
    var info: (ratio: CGFloat, description: String) {
        switch self {
        case .half:
            return (0.5, "1 : 2")
        case .one:
            return (1.0, "1 : 1")
        case .two:
            return (2.0, "2 : 1")
        }
    }
}

struct Widget: Identifiable, Hashable {
    var id = UUID().uuidString
    var width: CGFloat
    var height: CGFloat
    var position: CGPoint
    var color: Color
    var weight: CGFloat

    init(position: CGPoint, width: CGFloat, height: CGFloat, color: Color, weight: CGFloat = 100.0) {
        self.position = position
        self.width = width
        self.height = height
        self.color = color
        self.weight = weight
    }
}
