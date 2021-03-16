import Foundation

extension FileManager {
    #if DEBUG
        static let url = root.appendingPathComponent("walksmith.debug.archive")
    #else
        static let url = root.appendingPathComponent("walksmith.archive")
    #endif
    
    static var archive: Archive? {
        get {
            try? Data(contentsOf: url).mutating(transform: Archive.init(data:))
        }
        set {
            try? newValue!.data.write(to: url, options: .atomic)
        }
    }
    
    private static let root = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
