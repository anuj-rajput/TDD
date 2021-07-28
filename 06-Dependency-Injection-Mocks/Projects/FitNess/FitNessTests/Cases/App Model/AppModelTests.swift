import XCTest
@testable import FitNess

class AppModelTests: XCTestCase {
    
    var sut: AppModel!
    var mockPedometer: MockPedometer!
    
    override func setUp() {
        super.setUp()
        mockPedometer = MockPedometer()
        sut = AppModel(pedometer: mockPedometer)
    }
    
    override func tearDown() {
        AlertCenter.instance.clearAlerts()
        sut.stateChangedCallback = nil
        sut = nil
        super.tearDown()
    }
    
    // MARK: - Given
    func givenGoalSet() {
        sut.dataModel.goal = 1000
    }
    
    func givenInProgress() {
        givenGoalSet()
        try! sut.start()
    }
    
    func givenCompleteReady() {
        sut.dataModel.setToComplete()
    }
    
    func givenCaughtReady() {
        sut.dataModel.setToCaught()
    }
    
    // MARK: - Lifecycle
    func testAppModel_whenInitialized_isInNotStartedState() {
        let initialState = sut.appState
        XCTAssertEqual(initialState, AppState.notStarted)
    }
    
    // MARK: - Start
    func testAppModel_whenStarted_isInInProgressState() {
        // given
        givenGoalSet()
        
        // when started
        try? sut.start()
        
        // then it is in inProgress
        let newState = sut.appState
        XCTAssertEqual(newState, AppState.inProgress)
    }
    
    func testModelWithNoGoal_whenStarted_throwsError() {
        XCTAssertThrowsError(try sut.start())
    }
    
    func testStart_withGoalSet_doesNotThrow() {
        // given
        givenGoalSet()
        
        // then
        XCTAssertNoThrow(try sut.start())
    }
    
    // MARK: - Pause
    func testAppModel_whenPaused_isInPausedState() {
        // given
        givenInProgress()
        
        // when
        sut.pause()
        
        // then
        XCTAssertEqual(sut.appState, .paused)
    }
    
    // MARK: - Terminal States
    func testModel_whenCompleted_isInCompletedState() {
        // given
        givenCompleteReady()
        
        // when
        try? sut.setCompleted()
        
        // then
        XCTAssertEqual(sut.appState, .completed)
    }
    
    func testModelNotCompleteReady_whenCompleted_throwsError() {
        XCTAssertThrowsError(try sut.setCompleted())
    }
    
    func testModelCompleteReady_whenCompleted_doesNotThrow() {
        // given
        givenCompleteReady()
        
        // then
        XCTAssertNoThrow(try sut.setCompleted())
    }
    
    func testModel_whenCaught_isInCaughtState() {
        // given
        givenCaughtReady()
        
        // when started
        try? sut.setCaught()
        
        // then
        XCTAssertEqual(sut.appState, .caught)
    }
    
    func testModelNotCaughtReady_whenCaught_throwsError() {
        XCTAssertThrowsError(try sut.setCaught())
    }
    
    func testModelCaughtReady_whenCaught_doesNotThrow() {
        // given
        givenCaughtReady()
        
        // then
        XCTAssertNoThrow(try sut.setCaught())
    }
    
    // MARK: - Restart
    func testAppModel_whenReset_isInNotStartedState() {
        // given
        givenInProgress()
        
        // when
        sut.restart()
        
        // then
        XCTAssertEqual(sut.appState, .notStarted)
    }
    
    func testAppModel_whenRestarted_restartsDataModel() {
        // given
        givenInProgress()
        
        // when
        sut.restart()
        
        // then
        XCTAssertNil(sut.dataModel.goal)
    }
    
    // MARK: - State Changes
    func testAppModel_whenStateChanges_executesCallback() {
        // given
        givenInProgress()
        var observedState = AppState.notStarted
        
        let expected = expectation(description: "callback happened")
        sut.stateChangedCallback = { model in
            observedState = model.appState
            expected.fulfill()
        }
        
        // when
        sut.pause()
        
        // then
        wait(for: [expected], timeout: 1)
        XCTAssertEqual(observedState, .paused)
    }
    
    // MARK: - Pedometer

    func testPedometerNotAvailable_whenStarted_doesNotStart() {
        // given
        givenGoalSet()
        mockPedometer.pedometerAvailable = false
        
        // when
        try! sut.start()
        
        // then
        XCTAssertEqual(sut.appState, .notStarted)
    }

    func testAppModel_whenStarted_startsPedometer() {
        // given
        givenGoalSet()
        
        // when
        try! sut.start()
        
        // then
        XCTAssertTrue(mockPedometer.started)
    }
    
    func testPedometerNotAvailable_whenStarted_generatesAlert() {
        // given
        givenGoalSet()
        mockPedometer.pedometerAvailable = false
        let exp = expectation(forNotification: AlertNotification.name, object: nil, handler: alertHandler(.noPedometer))
        
        // when
        try! sut.start()
        
        // then
        wait(for: [exp], timeout: 1)
    }
    
    func testPedometerNotAuthorized_whenStarted_doesNotStart() {
        // given
        givenGoalSet()
        mockPedometer.permissionDeclined = true
        
        // when
        try! sut.start()
        
        // then
        XCTAssertEqual(sut.appState, .notStarted)
    }
    
    func testPedometerNotAuthorized_whenStarted_generatesAlert() {
        // given
        givenGoalSet()
        mockPedometer.permissionDeclined = true
        let exp = expectation(forNotification: AlertNotification.name, object: nil, handler: alertHandler(.notAuthorized))
        
        // when
        try! sut.start()
        
        // then
        wait(for: [exp], timeout: 1)
    }
}
