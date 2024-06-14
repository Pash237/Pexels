//
//  CuratedFeedScreen.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

@MainActor
struct CuratedFeedScreen: View {
	let viewModel: CuratedFeedViewModelProtocol

	var body: some View {
		ScrollView {
			LazyVGrid(columns: Array(repeating: .init(), count: 2)) {
				ForEach(viewModel.photos) { photo in
					NavigationLink(value: photo) {
						FeedPhotoCell(photo: photo)
							.onAppear {
								Task {
									let isLast = photo.id == viewModel.photos.last?.id
									if isLast {
										await viewModel.loadNextPage()
									}
								}
							}
					}
				}
				if viewModel.isLoading {
					ForEach(0..<6) {
						FeedPhotoCell(photo: .mock(id: $0))
					}
					.redacted(reason: .placeholder)
				}
				if let error = viewModel.error {
					ErrorView(error: error)
				}
			}
			.padding(.horizontal)
		}
		.onAppear {
			Task {
				await viewModel.loadNextPage()
			}
		}
		.refreshable(action: viewModel.reload)
		.navigationDestination(for: Photo.self) {
			PhotoDetailsView(photo: $0)
		}
		.navigationTitle("curated_photos_title")
	}
}

#Preview {
	NavigationStack {
		CuratedFeedScreen(viewModel: CuratedFeedViewModelMock())
	}
}

#Preview("RTL") {
	NavigationStack {
		CuratedFeedScreen(viewModel: CuratedFeedViewModelMock())
	}
	.environment(\.layoutDirection, .rightToLeft)
}

#Preview("Dynamic type") {
	NavigationStack {
		CuratedFeedScreen(viewModel: CuratedFeedViewModelMock())
	}
	.environment(\.sizeCategory, .accessibilityLarge)
}

#Preview("Loading") {
	NavigationStack {
		let viewModel: CuratedFeedViewModelMock = {
			let viewModel = CuratedFeedViewModelMock()
			viewModel.photos = []
			viewModel.isLoading = true
			return viewModel
		}()
		CuratedFeedScreen(viewModel: viewModel)
	}
}
