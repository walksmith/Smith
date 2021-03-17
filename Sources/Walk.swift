import Foundation
import Archivable

struct Walk: Equatable, Archivable {
    let date: Date
    let duration: TimeInterval
    
    var active: Bool {
        duration == 0
    }
    
    var end: Self {
        .init(start: date, end: Calendar.current.dateComponents([.hour], from: date, to: .init()).hour! > 9
                ? Calendar.current.date(byAdding: .hour, value: 1, to: date)! : .init())
    }
    
    var data: Data {
        Data()
            .adding(date.timestamp)
            .adding(UInt16(duration))
    }
    
    init() {
        date = .init()
        duration = 0
    }
    
    init(data: inout Data) {
        date = .init(timestamp: data.uInt32())
        duration = .init(data.uInt16())
    }
    
    init(start: Date, end: Date) {
        date = start
        duration = end.timeIntervalSince1970 - start.timeIntervalSince1970
    }
}
