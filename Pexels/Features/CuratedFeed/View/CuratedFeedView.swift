//
//  CuratedFeedScreen.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

@MainActor
struct CuratedFeedScreen: View {
	@State private var viewModel = CuratedFeedViewModel(service: CuratedFeedService(apiService: APIService()))

	var body: some View {
		ScrollView {
			LazyVGrid(columns: Array(repeating: .init(), count: 2)) {
				ForEach(viewModel.photos) { photo in
					NavigationLink(value: photo) {
						FeedPhotoCell(photo: photo)
							.task {
								let isLast = photo.id == viewModel.photos.last?.id
								if isLast {
									await viewModel.loadNextPage()
								}
							}
					}
				}
				if viewModel.isLoading {
					FeedPhotoCell(photo: .placeholder)
						.redacted(reason: .placeholder)
				}
				if let error = viewModel.error {
					ErrorView(error: error)
				}
			}
			.padding(.horizontal)
		}
		}
		.task(viewModel.loadNextPage)
		.refreshable(action: viewModel.reload)
		.navigationDestination(for: Photo.self) {
			PhotoDetailsView(photo: $0)
		}
		.navigationTitle("curated_photos_title")
	}
}

#Preview {
	NavigationStack {
		CuratedFeedScreen()
	}
}

#Preview("RTL") {
	NavigationStack {
		CuratedFeedScreen()
	}
	.environment(\.layoutDirection, .rightToLeft)
}

#Preview("Dynamic type") {
	NavigationStack {
		CuratedFeedScreen()
	}
	.environment(\.sizeCategory, .accessibilityLarge)
}
