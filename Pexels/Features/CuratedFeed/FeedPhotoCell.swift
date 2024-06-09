//
//  FeedPhotoCell.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

struct PhotoAsyncImage: View {
	let url: URL
	
	var body: some View {
		Color.clear
			.background {
				AsyncImage(url: url) { phase in
					if let image = phase.image {
						image
							.resizable()
							.scaledToFill()
					} else if let error = phase.error {
						VStack {
							Text("😔")
							Text(error.localizedDescription)
						}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.background(Color.secondary.opacity(0.2))
					} else {
						ProgressView()
					}
				}
			}
	}
}

struct FeedPhotoCell: View {
	let photo: Photo
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			PhotoAsyncImage(url: photo.thumbnailUrl)
				.aspectRatio(max(1/1.5, photo.aspectRatio), contentMode: .fill)
				.clipped()
				.accessibilityLabel(photo.altText ?? "Photo")
			
			Rectangle()
				.fill(Gradient(colors: [.black.opacity(0), .black.opacity(0.4)]))
				.frame(height: 100)
			Text(photo.photographer.name)
				.foregroundStyle(.white)
				.padding()
		}
		.clipShape(.rect(cornerRadius: 8))
		.padding(.horizontal)
		.shadow(color: .black.opacity(0.2), radius: 20)
	}
}

#Preview {
	VStack {
		FeedPhotoCell(photo: Photo.mock(id: 0))
		FeedPhotoCell(photo: Photo.mock(id: 1))
		FeedPhotoCell(photo: Photo.mock(id: 2))
	}
}
