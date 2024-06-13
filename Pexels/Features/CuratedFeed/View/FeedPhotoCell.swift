//
//  FeedPhotoCell.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI
import NukeUI

struct PhotoAsyncImage: View {
	let photo: Photo
	let size: Photo.Size
	
	var body: some View {
		LazyImage(url: size == .full ? photo.imageUrl : photo.thumbnailUrl) { state in
			if let image = state.image {
				image
					.resizable()
					.scaledToFill()
			} else if let error = state.error {
				ErrorView(error: error)
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					.background(Color.secondary.opacity(0.2))
			} else {
				if size == .full {
					// use thumbnail as a placeholder while full photo is loading
					PhotoAsyncImage(photo: photo, size: .thumbnail)
				} else {
					ZStack {
						Color.black.opacity(0.05)
						ProgressView()
					}
				}
			}
		}
		.accessibilityLabel(photo.altText ?? "photo_generic_accessibility_label")
		.accessibilityIdentifier("photo")
	}
}

struct FeedPhotoCell: View {
	let photo: Photo
	
	@Environment(\.redactionReasons) private var redactionReasons
	
	var body: some View {
		ZStack(alignment: .bottomLeading) {
			if redactionReasons.contains(.placeholder) {
				Color.black.opacity(0.05).aspectRatio(2, contentMode: .fill)
			} else {
				PhotoAsyncImage(photo: photo, size: .thumbnail)
					.aspectRatio(max(1/1.5, photo.aspectRatio), contentMode: .fill)
					.clipped()
			}
			
			Rectangle()
				.fill(Gradient(colors: [.black.opacity(0), .black.opacity(0.4)]))
				.frame(height: 100)
			Text(photo.photographer.name)
				.foregroundStyle(.white)
				.padding()
				.accessibilityIdentifier("photographer_name")
		}
		.clipShape(.rect(cornerRadius: 8))
		.padding(.horizontal)
		.shadow(color: .black.opacity(0.2), radius: 20)
		.accessibilityElement(children: .combine)
		.accessibilityLabel(photo.altText ?? String(localized: "photo_generic_accessibility_label"))
		.accessibilityIdentifier("photo_cell")
	}
}

#Preview {
	VStack {
		FeedPhotoCell(photo: Photo.mock(id: 0))
		FeedPhotoCell(photo: Photo.mock(id: 1))
		FeedPhotoCell(photo: Photo.mock(id: 2))
	}
}
