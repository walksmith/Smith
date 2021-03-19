import Foundation
import Archivable

public struct Archive: Comparable, Archivable {
    var walks: [Walk]
    var challenges: Set<Challenge>
    var date: Date
    
    public var status: Status {
        walks.last.flatMap {
            $0.active ? .walking(-$0.date.timeIntervalSinceNow) : nil
        } ?? .none
    }
    
    public var last: Date? {
        walks.last.map {
            $0.date.addingTimeInterval($0.duration)
        }
    }
    
    public var streak: Streak {
        walks.reduce((Streak.zero, walks.first?.date ?? .distantPast)) {
            (Calendar.current.isDate($0.1, inSameDayAs: $1.date) ? $0.0.hit : $0.0.miss.hit, $1.date)
        }.0
    }
    
    public var calendar: [Year] {
        walks.map(\.date).first.map {
            ($0, Date(), Calendar.current)
        }.map { (start, now, calendar) in
            (calendar.component(.year, from: start) ... calendar.component(.year, from: now))
                .map {
                    ($0, calendar.dateInterval(of: .year, for: calendar.date(from: .init(year: $0))!)!)
                }
                .map { (year, interval) in
                    (calendar.component(.month, from: interval.start) ... calendar.component(.month, from: calendar.date(byAdding: .day, value: -1, to: interval.end)!))
                        .map {
                            ($0, calendar.dateInterval(of: .month, for: calendar.date(from: .init(month: $0))!)!)
                        }
                        .map { (month, interval) in
                            (calendar.component(.day, from: interval.start) ... calendar.component(.day, from: calendar.date(byAdding: .day, value: -1, to: interval.end)!))
                                .reduce(into: [Year(value: year, months: [.init(value: month, days: [])])]) { result, day in
                                    if result.last!.value != year {
                                        result.append(Year(value: year, months: [.init(value: month, days: [[]])]))
                                    }
                                    if result.last!.months.last!.value != month {
                                        result = result.last {
                                            $0.with(.init(value: month, days: [[]]))
                                        }
                                    }
                                    
                                    if calendar.component(.weekday, from: calendar.date(from: .init(year: year, month: month, day: day))!) == 7 {
                                        result = result.last {
                                            $0.months = $0.months.last {
                                                $0.week
                                            }
                                        }
                                    }
                                }
                        }
                }
        }
        
        return []
        
        
        
        //        selected = calendar.dateComponents([.year, .month, .day], from: date)
        //        year.stringValue = yearer.string(from: date)
        //        month.stringValue = monther.string(from: date)
        //        contentView!.subviews.filter { $0 is Day }.forEach { $0.removeFromSuperview() }
        //
        //        let span = calendar.dateInterval(of: .month, for: date)!
        //        let start = calendar.dateComponents([.weekday, .day], from: span.start)
        //        var weekday = start.weekday!
        //        var top = CGFloat(70)
        //        var left = ((.init(weekday) - 0.5) * column) + margin
        //        (start.day! ... calendar.component(.day, from: calendar.date(byAdding: .day, value: -1, to: span.end)!)).forEach {
        //            let day = Day($0, self)
        //            day.selected = $0 == selected.day!
        //            contentView!.addSubview(day)
        //
        //            day.topAnchor.constraint(equalTo: month.bottomAnchor, constant: top).isActive = true
        //            day.centerXAnchor.constraint(equalTo: contentView!.leftAnchor, constant: left).isActive = true
        //
        //            if weekday == 7 {
        //                weekday = 1
        //                top += column
        //                left = (0.5 * column) + margin
        //            } else {
        //                weekday += 1
        //                left += column
        //            }
        //        }
    }
    
    public var list: [Walk.Listed] {
        walks
            .map(\.duration)
            .filter {
                $0 > 0
            }
            .max()
            .map { duration in
                walks.map {
                    .init(date: $0.date, duration: $0.duration, percent: $0.duration / duration)
                }
            }?.reversed() ?? []
    }
    
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
    
    public mutating func start() {
        guard case .none = status else { return }
        
        walks.append(.init())
        save()
    }
    
    public mutating func cancel() {
        guard case .walking = status else { return }
        
        walks.removeLast()
        save()
    }
    
    public mutating func end(steps: Int = 0, meters: Int = 0, tiles: Int = 0) {
        guard
            case let .walking(duration) = status,
            duration > 0
        else { return }
        
        walks = walks.mutating(index: walks.count - 1) {
            $0.end(steps: steps, meters: meters, tiles: tiles)
        }
        save()
    }
    
    public mutating func start(_ challenge: Challenge) {
        challenges.insert(challenge)
        save()
    }
    
    public mutating func stop(_ challenge: Challenge) {
        challenges.remove(challenge)
        save()
    }
    
    public func enrolled(_ challenge: Challenge) -> Bool {
        challenges.contains(challenge)
    }
    
    public static func < (lhs: Archive, rhs: Archive) -> Bool {
        lhs.date < rhs.date
    }
    
    private mutating func save() {
        date = .init()
        Memory.shared.save.send(self)
    }
}
