//
//  ContentView.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

@MainActor
struct ContentView: View {
	@State private var curatedFeedViewModel = CuratedFeedViewModel(service: CuratedFeedService(apiService: APIService()))

    var body: some View {
		NavigationStack {
			CuratedFeedScreen(viewModel: curatedFeedViewModel)
		}
    }
}

#Preview {
    ContentView()
}
