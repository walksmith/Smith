import Foundation

extension Array where Element == Year {
    var hits: [Bool] {
        flatMap(\.months)
            .flatMap(\.days)
            .flatMap { $0 }
            .map(\.hit)
            .dropLast(Calendar.current.daysLeftMonth + 1)
    }
}
