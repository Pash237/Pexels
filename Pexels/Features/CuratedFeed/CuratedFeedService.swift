//
//  CuratedFeedService.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import Foundation

protocol CuratedFeedServiceProtocol: Sendable {
	func curatedPhotos(pageSize: Int, page: Int) async throws -> CuratedPhotosResponse
}

struct CuratedFeedService: CuratedFeedServiceProtocol {
	let apiService: APIServiceProtocol
	
	func curatedPhotos(pageSize: Int = 3, page: Int = 1) async throws -> CuratedPhotosResponse {
		try await apiService.get(
			method: "curated",
			parameters: [
				"page": page,
				"per_page": pageSize
			])
	}
}

struct CuratedPhotosResponse: Decodable, Equatable {
	let photos: [Photo]
	let nextPageUrl: URL?
	
	enum CodingKeys: String, CodingKey {
		case photos
		case nextPageUrl = "nextPage"
	}
	
	var hasMore: Bool {
		nextPageUrl != nil
	}
}

extension Photo: Decodable {
	enum CodingKeys: String, CodingKey {
		case id
		case width
		case height
		case photographerName = "photographer"
		case photographerUrl
		case photographerId
		case imageUrls = "src"
		case alt
		
		case original
		case large2x
	}
	
	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		id = try values.decode(Int.self, forKey: .id)
		width = try values.decode(Int.self, forKey: .width)
		height = try values.decode(Int.self, forKey: .height)
		photographer = Photographer(
			id: try values.decode(Int.self, forKey: .photographerId),
			name: try values.decode(String.self, forKey: .photographerName),
			url: try values.decode(URL.self, forKey: .photographerUrl)
		)
		altText = try? values.decode(String?.self, forKey: .alt)
		
		let imageUrls = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .imageUrls)
		imageUrl = try imageUrls.decode(URL.self, forKey: .original)
		thumbnailUrl = (try? imageUrls.decode(URL.self, forKey: .large2x)) ?? imageUrl
	}
}
