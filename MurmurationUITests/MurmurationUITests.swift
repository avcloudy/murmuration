import XCTest

final class murmurationUITests: XCTestCase {

  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  @MainActor
  func testExample() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()
    app.activate()
    let window = app.windows.element(boundBy: 0)
    XCTAssertTrue(window.waitForExistence(timeout: 5), "The main window failed to launch.")
    let toggle = window.toolbars.checkBoxes["ControlBarToggle"]
    XCTAssertTrue(toggle.exists, "The toolbar toggle was not found.")
    toggle.click()
    let controlBar = window.descendants(matching: .any)["ControlBarIdentifier"]

    let exists = controlBar.waitForExistence(timeout: 3)
    XCTAssertTrue(exists, "Control bar should be visible after toggling.")
  }

  @MainActor
  func testLaunchPerformance() throws {
    // This measures how long it takes to launch your application.
    measure(metrics: [XCTApplicationLaunchMetric()]) {
      XCUIApplication().launch()
    }
  }
}
