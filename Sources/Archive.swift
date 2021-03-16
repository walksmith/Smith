import Foundation
import Archivable

public struct Archive: Comparable, Archivable {
    public internal(set) var challenges: Set<Challenge>
    public internal(set) var walks: [Walk]
    var date: Date
    
    public var data: Data {
        Data()
            .adding(date.timestamp)
            .adding(UInt8(challenges.count))
            .adding(challenges.flatMap(\.data))
            .adding(UInt8(walks.count))
            .adding(walks.flatMap(\.data))
    }
    
    public init() {
        walks = []
        challenges = .init()
        date = .init()
    }
    
    public init(data: inout Data) {
        date = .init(timestamp: data.uInt32())
        challenges = .init((0 ..< .init(data.removeFirst())).map { _ in
            .init(data: &data)
        })
        walks = (0 ..< .init(data.removeFirst())).map { _ in
            .init(data: &data)
        }
    }
    
    public static func < (lhs: Archive, rhs: Archive) -> Bool {
        lhs.date < rhs.date
    }
}
