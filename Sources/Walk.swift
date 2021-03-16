import Foundation
import Archivable

public struct Walk: Equatable, Archivable {
    public let date: Date
    public let duration: TimeInterval
    
    public var data: Data {
        Data()
            .adding(date.timestamp)
            .adding(UInt16(duration))
    }
    
    public var end: Self {
        .init(start: date, end: .init())
    }
    
    public init() {
        date = .init()
        duration = 0
    }
    
    public init(data: inout Data) {
        date = .init(timestamp: data.uInt32())
        duration = .init(data.uInt16())
    }
    
    init(start: Date, end: Date) {
        date = start
        duration = end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
}
