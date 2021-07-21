import Foundation

/** The Fitness Monster */
class Nessie {
    var distance: Double = 0
    
    let velocity: Double = 9.5 // m/s
    var timer: Timer?
    
    func startSwimming() {
        timer = Timer(timeInterval: 1, target: self, selector: #selector(incrementDistance), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: RunLoop.Mode.default)
    }
    
    func stopSwimming() {
        timer?.invalidate()
    }
    
    @objc func incrementDistance() {
    }
    
    deinit {
        timer?.invalidate()
    }
}
