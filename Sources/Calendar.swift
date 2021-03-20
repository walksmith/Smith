import Foundation

extension Calendar {
    var daysLeftMonth: Int {
        component(.day, from: date(byAdding: .day, value: -1, to: dateInterval(of: .month, for: .init())!.end)!) - component(.day, from: .init())
    }
}
