import Foundation
import Archivable

public struct Year: Hashable {
    public let value: Int
    public let months: [Month]

    func with(_ month: Month) -> Self {
        .init(value: value, months: months + month)
    }
}
