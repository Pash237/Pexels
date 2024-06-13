//
//  CuratedFeedViewModel.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import SwiftUI

@Observable
@MainActor
final class CuratedFeedViewModel {
	var photos: [Photo] = []
	var isLoading = false
	var error: Error?
	
	private let service: CuratedFeedServiceProtocol
	private let pageSize = 3
	private var nextPage: Int? = 1
	
	init(service: CuratedFeedServiceProtocol) {
		self.service = service
		self.nextPage = nextPage
	}
	
	@Sendable func reload() async {
		photos = []
		nextPage = 1
		error = nil
		await loadNextPage()
	}
	
	@Sendable func loadNextPage() async {
		guard let page = nextPage, error == nil, !isLoading else { return }
		
		error = nil
		isLoading = true
		do {
			let response = try await service.curatedPhotos(pageSize: pageSize, page: page)
			// manually avoid repeating photos in the feed — page index addressing has no prevention of that
			photos = (photos + response.photos).uniqued()
			nextPage = response.hasMore ? page + 1 : nil
			isLoading = false
		} catch {
			self.error = error
			self.isLoading = false
		}
	}
}
