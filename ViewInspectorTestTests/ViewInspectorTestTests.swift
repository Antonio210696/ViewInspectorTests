//
//  ViewInspectorTestTests.swift
//  ViewInspectorTestTests
//
//  Created by Antonio Epifani on 18/05/23.
//

import XCTest
import ViewInspector
import SwiftUI
import Combine
@testable import ViewInspectorTest

final class ViewInspectorTestTests: XCTestCase {

	func testButtonPressChangesStateInsideView() throws {
		let sut = makeSUT()
		
		let exp = sut.inspection.inspect { view in
			try view.vStack().button(0).tap()
			XCTAssertEqual(try? view.find(ViewType.Text.self).string(), "State is false", "Expected state to change on button press")
		}
		
		ViewHosting.host(view: sut)
		
		wait(for: [exp], timeout: 1.0)
	}
	
	private func makeSUT() -> InspectionWrapper<ContentView> {
		return InspectionWrapper { ContentView() }
	}
}

internal final class Inspection<V> {
	
	let notice = PassthroughSubject<UInt, Never>()
	var callbacks = [UInt: (V) -> Void]()
	
	func visit(_ view: V, _ line: UInt) {
		if let callback = callbacks.removeValue(forKey: line) {
			callback(view)
		}
	}
}

extension Inspection: InspectionEmissary { }

struct InspectionWrapper<Content: View>: View {
	let inspection = Inspection<Content>()
	@ViewBuilder var content: Content
	
	var body: some View {
		content
			.onReceive(inspection.notice) { self.inspection.visit(content, $0) }
	}
}
