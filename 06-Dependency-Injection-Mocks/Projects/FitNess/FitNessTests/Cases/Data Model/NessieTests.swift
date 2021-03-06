import XCTest
@testable import FitNess

class NessieTests: XCTestCase {
    
    var sut: Nessie!
    
    override func setUp() {
        super.setUp()
        sut = Nessie()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testNessie_whenUpdated_incrementsDistance() {
        // when
        sut.incrementDistance()
        
        // then
        XCTAssertEqual(sut.distance, sut.velocity)
    }
}
