//
//  PhotoDetailsView.swift
//  Pexels
//
//  Created by Pavel Alexeev on 08.06.2024.
//

import SwiftUI

struct PhotoDetailsView: View {
	let photo: Photo
	
	var body: some View {
		VStack(alignment: .leading) {
			PhotoAsyncImage(url: photo.thumbnailUrl)
				.aspectRatio(photo.aspectRatio, contentMode: .fit)
				.accessibilityLabel(photo.altText ?? "photo_generic_accessibility_label")
			
			VStack(alignment: .leading) {
				Text(photo.photographer.name)
				if let altText = photo.altText {
					Text(altText)
						.foregroundStyle(.secondary)
				}
			}
			.padding(.horizontal)
			
			Spacer()
		}
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStack {
		PhotoDetailsView(photo: .mock)
	}
}
