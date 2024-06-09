//
//  CuratedFeedScreen.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

struct CuratedFeedScreen: View {
	@State private var viewModel = CuratedFeedViewModel()

	var body: some View {
		ScrollView {
			LazyVStack(spacing: 30) {
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
			}
		}
		.task(viewModel.loadNextPage)
		.refreshable(action: viewModel.reload)
		.navigationDestination(for: Photo.self) {
			PhotoDetailsView(photo: $0)
		}
		.navigationTitle("Curated Photos")
	}
}

#Preview {
	NavigationStack {
		CuratedFeedScreen()
	}
}
