//
//  CuratedFeedViewModel.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

@Observable
final class CuratedFeedViewModel {
	var photos: [Photo] = []
	var isLoading = false
	var error: Error?
	
	private let service = CuratedFeedService()
	private var nextPage: Int? = 1
	
	func reload() async {
		photos = []
		nextPage = 1
		await loadNextPage()
	}
	
	func loadNextPage() async {
		error = nil
		isLoading = true
		guard let page = nextPage else { return }
		
		do {
			let response = try await service.curatedPhotos(page: page)
			// manually avoid repeating photos in the feed — page index addressing has no prevention of that
			photos = (photos + response.photos).uniqued()
			nextPage = response.hasMore ? page + 1 : nil
			isLoading = false
		} catch {
			print("\(error)")
			self.error = error
		}
	}
}
