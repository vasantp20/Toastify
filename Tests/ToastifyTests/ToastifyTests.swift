import XCTest
@testable import Toastify

import XCTest
import SwiftUI
@testable import Toastify

class ToastifyTests: XCTestCase {


    func test_showToast_disappearsAfterDuration() {
        // Create an instance of ToastManager
        let toastManager = ToastManager.shared

        // Display a toast with a 2-second duration
        toastManager.showToast(message: "Temporary Toast", duration: 2.0)

        // Wait for 3 seconds (allowing for duration + fade out)
        let expectation = XCTestExpectation(description: "Wait for toast to disappear")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)

        // Assert that the toast is no longer on the screen
        XCTAssertFalse(isToastOnWindow(withMessage: "Temporary Toast"))
    }
    
    // Helper function to check if toast exists in the root window
    private func isToastOnWindow(withMessage message: String) -> Bool {
        let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
        guard let views = keyWindow?.subviews else { return false }

        for view in views {
            if let label = view.subviews.first(where: { $0 is UILabel }) as? UILabel {
                if label.text == message {
                    return true
                }
            }
        }
        return false
    }
}
