import XCTest
@testable import CapacitorChooseVideoPlugin

class CapacitorChooseVideoPluginTests: XCTestCase {

    func testPluginMetadata() {
        let plugin = CapacitorChooseVideo()

        XCTAssertEqual(plugin.identifier, "CapacitorChooseVideo")
        XCTAssertEqual(plugin.jsName, "CapacitorChooseVideo")
        XCTAssertEqual(
            Set(plugin.pluginMethods.map(\.name)),
            ["echo", "getVideo", "requestFilesystemAccess"]
        )
    }
}
