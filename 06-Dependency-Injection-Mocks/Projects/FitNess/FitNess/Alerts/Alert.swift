import Foundation

// note: no AlertTests because alert is a pure data object
class Alert {
    
    enum Severity { case good, bad }
    
    let text: String
    let severity: Severity
    var cleared: Bool = false
    
    
    init(_ text: String, severity: Severity = .bad) {
        self.text = text
        self.severity = severity
    }
}

extension Alert {
    static var caughtByNessie = Alert("Caught By Nessie!")
    static var reachedGoal = Alert("You reached your goal!", severity: .good)
    static var noPedometer = Alert("Pedometer is not available. You won't be able to use this app.")
    static var notAuthorized = Alert("Motion recording has been blocked. Fix in Settings")
    static var milestone25Percent = Alert("You are 25% to goal. Keep going!", severity: .good)
    static var milestone50Percent = Alert("Woohoo! You're halfway there!", severity: .good)
    static var milestone75Percent = Alert("Almost there, you can do it!", severity: .good)
    static var goalComplete = Alert("Amazing, you did it! Have some 🥧.", severity: .good)
    static var nessie50Percent = Alert("Nessie catching up halfway 🦕.")
    static var nessie90Percent = Alert("Nessie almost has you 🦕!")
}

extension Alert: Equatable {
    static func == (lhs: Alert, rhs: Alert) -> Bool {
        return lhs.text == rhs.text
    }
}

extension Alert: CustomStringConvertible {
    var description: String {
        return "Alert: '\(text)'"
    }
}
