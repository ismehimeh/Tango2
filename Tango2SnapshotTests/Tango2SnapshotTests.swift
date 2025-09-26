//
//  Tango2SnapshotTests.swift
//  Tango2SnapshotTests
//
//  Created by Sergei Vasilenko on 21.09.2025.
//

import SnapshotTesting
import SwiftUI
import Testing
@testable import Tango2

struct Tango2SnapshotTests {

    @MainActor
    @Test func tutorialFirstStage() async throws {
        withSnapshotTesting(diffTool: .default) {
            let view = TutorialView()
            assertSnapshot(of: view, as: .image(drawHierarchyInKeyWindow: true,
                                                layout: .device(config: .iPhone12)))
        }
    }
}

extension SnapshotTestingConfiguration.DiffTool {
  static let compare = Self {
    "compare \"\($0)\" \"\($1)\" png: | open -f -a Preview.app"
  }
}
