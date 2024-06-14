//
//  Mocks.swift
//  Pexels
//
//  Created by Pavel Alexeev on 14.06.2024.
//

import Foundation

class APIServiceCuratedPhotosMock: APIServiceProtocol, @unchecked Sendable {
	func get<Response: Decodable>(method: String, parameters: [String : any CustomStringConvertible]) async throws -> Response {
		return CuratedPhotosResponse(photos: [.mock], nextPageUrl: nil) as! Response
	}
}

class CuratedFeedServiceMock: CuratedFeedServiceProtocol, @unchecked Sendable {
	var nextPageUrl: URL? = URL(string: "https://next.page")
	var thrownError: Error?
	func curatedPhotos(pageSize: Int, page: Int) async throws -> CuratedPhotosResponse {
		if let thrownError {
			throw thrownError
		}
		return CuratedPhotosResponse(photos: (0..<pageSize).map { .mock(id: page * pageSize + $0) },
									 nextPageUrl: nextPageUrl)
	}
}

class CuratedFeedViewModelMock: CuratedFeedViewModelProtocol {
	var photos: [Photo] = (0..<10).map { .mock(id: $0) }
	var isLoading = false
	var error: Error? = nil
	
	func reload() async {
		
	}
	
	func loadNextPage() async {
		
	}
}
