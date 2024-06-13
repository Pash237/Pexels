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
			PhotoAsyncImage(photo: photo, size: .full)
				.aspectRatio(photo.aspectRatio, contentMode: .fit)
			
			VStack(alignment: .leading) {
				Text(photo.photographer.name)
					.accessibilityIdentifier("photographer_name")
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
