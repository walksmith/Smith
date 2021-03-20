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
        walks.isEmpty ? .zero : calendar.hits.reduce(Streak.zero) {
            $1 ? $0.hit : $0.miss
        }
    }
    
    public var calendar: [Year] {
        var dates = walks.map(\.date)
        return dates.first.map {
            (DateInterval(start: $0, end: .init()), Calendar.current)
        }
        .map { (interval, calendar) in
            (calendar.component(.year, from: interval.start) ... calendar.component(.year, from: interval.end))
            .map {
                ($0, calendar.dateInterval(of: .year, for: calendar.date(from: .init(year: $0))!)!.intersection(with: interval)!)
            }
            .map { (year, interval) in
                .init(value: year, months:
                        (calendar.component(.month, from: interval.start) ... calendar.component(.month, from: calendar.date(byAdding: .day, value: -1, to: interval.end)!))
                .map {
                    ($0, calendar.dateInterval(of: .month, for: calendar.date(from: .init(year: year, month: $0))!)!)
                }
                .map { (month, interval) in
                    .init(value: month, days: (calendar.component(.weekOfMonth, from: interval.start) ... calendar.component(.weekOfMonth, from: calendar.date(byAdding: .day, value: -1, to: interval.end)!))
                    .map {
                        ($0, calendar.dateInterval(of: .weekOfMonth,
                                                   for: calendar.date(from: .init(year: year, month: month, weekday: 1, weekOfMonth: $0))!)!.intersection(with: interval)!)
                    }
                    .map { (week, interval) in
                        (calendar.component(.day, from: interval.start) ... calendar.component(.day, from: calendar.date(byAdding: .day, value: -1, to: interval.end)!))
                            .map { day in
                                .init(value: day, hit: {
                                    while(!dates.isEmpty && $0 > dates.first!) {
                                        dates.removeFirst()
                                    }
                                    return !dates.isEmpty && calendar.isDate(dates.first!, inSameDayAs: $0)
                                } (calendar.date(from: .init(year: year, month: month, day: day))!))
                            }
                    })
                })
            }
        } ?? []
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
