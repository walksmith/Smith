import Foundation

extension Array where Element == Year {
    public var streak: Streak {
        isEmpty
            ? .zero
            : flatMap(\.months)
                .flatMap(\.days)
                .flatMap { $0 }
                .map(\.hit)
                .dropLast(Calendar.current.daysLeftMonth + 1).reduce(.zero) {
                    $1 ? $0.hit : $0.miss
                }
    }
}
