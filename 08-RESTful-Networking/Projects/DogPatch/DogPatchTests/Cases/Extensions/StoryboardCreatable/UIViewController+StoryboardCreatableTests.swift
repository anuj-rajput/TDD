@testable import DogPatch
import XCTest

class UIViewController_StoryboardCreatableTests: XCTestCase {
  
  func test_storyboard_returnsExpected() {
    // when
    let storyboard = TestViewController.storyboard
    let viewController = storyboard.instantiateViewController(withIdentifier: "TestViewController")
    
    // then
    XCTAssertTrue(viewController is TestViewController)
  }
  
  func test_storyboardBundle_returnsExpected() {
    // given
    let expected = Bundle(for: TestViewController.self)
    
    // when
    let actual = TestViewController.storyboardBundle
    
    // then
    XCTAssertEqual(actual, expected)
  }
  
  func test_storyboardBundle_canBeOverriden() {
    // given
    class TestViewController: UIViewController {
      override class var storyboardBundle: Bundle? { return nil }
    }
    
    // when
    let actual = TestViewController.storyboardBundle
    
    // then
    XCTAssertNil(actual)
  }
  
  func test_storyboardName_returnsExpected() {
    // given
    let expected = "Main"
    
    // when
    let actual = TestViewController.storyboardName
    
    // then
    XCTAssertEqual(actual, expected)
  }
  
  func test_storyboardName_canBeOverriden() {
    // given
    let expected = "SomethingElse"
    class TestViewController: UIViewController {
      override class var storyboardName: String { return "SomethingElse" }
    }
    
    // when
    let actual = TestViewController.storyboardName
    
    // then
    XCTAssertEqual(actual, expected)
  }
  
  func test_storyboardIdentifier_returnsExpected() {
    // given
    let expected = "\(TestViewController.self)"
    
    // when
    let actual = TestViewController.storyboardIdentifier
    
    // then
    XCTAssertEqual(actual, expected)
  }
  
  func test_storyboardIdentifier_canBeOverriden() {
    // given
    let expected = "SomethingElse"
    class TestViewController: UIViewController {
      override class var storyboardIdentifier: String { return "SomethingElse" }
    }
    
    // when
    let actual = TestViewController.storyboardIdentifier
    
    // then
    XCTAssertEqual(actual, expected)
  }
  
  func test_instanceFromStoryboard_returnsExpected() {
    // when
    let actual = TestViewController.instanceFromStoryboard() as UIViewController
    
    // then
    XCTAssertTrue(actual is TestViewController)
  }
}
