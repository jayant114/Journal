import Foundation

struct JournalEntry: Identifiable, Codable {
    let id = UUID()
    var content: String
    var date: Date
    
    var formattedDate: String {
        date.formatted(.custom("EEEE, dd MMMM, YYYY"))
    }
} 