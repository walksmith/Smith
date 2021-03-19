import Foundation
import Archivable

extension Year {
    public struct Month: Hashable {
        public let value: Int
        public let days: [[Day]]
        
        var week: Self {
            .init(value: value, days: days + [[]])
        }
        
        func with(_ day: Day) -> Self {
            .init(value: value, days: days + [day])
        }
    }
}
