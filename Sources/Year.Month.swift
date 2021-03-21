import Foundation
import Archivable

extension Year {
    public struct Month: Equatable {
        public let value: Int
        public let days: [[Day]]
    }
}
