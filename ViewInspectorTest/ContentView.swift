//
//  ContentView.swift
//  ViewInspectorTest
//
//  Created by Antonio Epifani on 18/05/23.
//

import SwiftUI

struct ContentView: View {
	@State var someState: Bool = true
	
    var body: some View {
		VStack {
			Button("Change state") {
				someState.toggle()
			}
			if someState {
				Text("State is true")
			} else {
				Text("State is false")
			}
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
