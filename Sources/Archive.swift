import Foundation
import Archivable

public struct Archive: Archivable {
    public var challenges: Set<Challenge>
    
    public var data: Data {
        Data()
            .adding(UInt8(challenges.count))
            .adding(challenges.flatMap(\.data))
    }
    
    public init() {
        challenges = .init()
    }
    
    public init(data: inout Data) {
        challenges = .init((0 ..< .init(data.removeFirst())).map { _ in
            .init(data: &data)
        })
    }
}
