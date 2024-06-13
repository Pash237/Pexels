//
//  CuratedFeedTests.swift
//  Pexels
//
//  Created by Pavel Alexeev on 10.06.2024.
//

import XCTest
@testable import Pexels

final class CuratedFeedTests: XCTestCase {
	
	let decoder: JSONDecoder = {
		var decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return decoder
	}()
	
	let photoJson = """
	{
	   "id": 2880507,
		"width": 4000,
		"height": 6000,
		"photographer": "Deden Dicky Ramdhani",
		"photographer_url": "https://www.pexels.com/@drdeden88",
		"photographer_id": 1378810,
		"avg_color": "#7E7F7B",
		"src": {
		  "original": "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg",
		  "large2x": "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
		},
		"alt": "Brown Rocks During Golden Hour"
	}
	"""
	
	func testPhotoParsing() throws {
		let json = photoJson
		let expectedPhoto = Photo.mock
		let actualPhoto = try decoder.decode(Photo.self, from: json.data(using: .utf8)!)
		
		XCTAssertEqual(actualPhoto, expectedPhoto)
	}
	
	func testPhotoParsingNoAltText() throws {
		let json = """
		{
			"id": 2880507,
			 "width": 4000,
			 "height": 6000,
			 "photographer": "Deden Dicky Ramdhani",
			 "photographer_url": "https://www.pexels.com/@drdeden88",
			 "photographer_id": 1378810,
			 "avg_color": "#7E7F7B",
			 "src": {
			   "original": "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg",
			   "large2x": "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
			 },
			 "liked": false
		}
		"""
		
		let expectedPhotographer = Photographer(id: 1378810,
												name: "Deden Dicky Ramdhani",
												url: URL(string: "https://www.pexels.com/@drdeden88")!)
		let expectedPhoto = Photo(id: 2880507,
								  width: 4000,
								  height: 6000,
								  imageUrl: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg")!,
								  thumbnailUrl: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940")!,
								  altText: nil,
								  photographer: expectedPhotographer)
		
		let actualPhoto = try decoder.decode(Photo.self, from: json.data(using: .utf8)!)
		
		XCTAssertEqual(actualPhoto, expectedPhoto)
	}
	
	func testPhotoParsingFail() throws {
		let json = """
		{
			"id": 2880507,
			 "width": 4000,
			 "height": 6000,
			 "photographer": "Deden Dicky Ramdhani",
			 "photographer_url": "https://www.pexels.com/@drdeden88",
			 "photographer_id": 1378810,
			 "avg_color": "#7E7F7B"
		}
		"""
		
		XCTAssertThrowsError(try decoder.decode(Photo.self, from: json.data(using: .utf8)!))
	}
	
	func testCuratedFeedParsing() throws {
		let json = """
			{
			  "photos": [
				\(photoJson)
			  ],
			  "next_page": "https://api.pexels.com/v1/curated/?page=2&per_page=1"
			}
		"""
		let expectedResponse = CuratedPhotosResponse(photos: [.mock], nextPageUrl: URL(string: "https://api.pexels.com/v1/curated/?page=2&per_page=1"))
		let actualResponse = try decoder.decode(CuratedPhotosResponse.self, from: json.data(using: .utf8)!)
//		let feedService = CuratedFeedService(apiService: APIServiceCuratedPhotosMock())
		
		XCTAssertEqual(actualResponse, expectedResponse)
		XCTAssertTrue(actualResponse.hasMore)
	}
	
	func testCuratedFeedParsingNoMorePages() throws {
		let json = """
			{
			  "photos": [
				\(photoJson)
			  ]
			}
		"""
		let expectedResponse = CuratedPhotosResponse(photos: [.mock], nextPageUrl: nil)
		let actualResponse = try decoder.decode(CuratedPhotosResponse.self, from: json.data(using: .utf8)!)
		
		XCTAssertEqual(actualResponse, expectedResponse)
		XCTAssertFalse(actualResponse.hasMore)
	}
	
	func testCuratedFeedService() async throws {
		let feedService = CuratedFeedService(apiService: APIServiceCuratedPhotosMock())
		let actualResponse = try await feedService.curatedPhotos(pageSize: 1, page: 1)
		let expectedResponse = CuratedPhotosResponse(photos: [.mock], nextPageUrl: nil)
		XCTAssertEqual(actualResponse, expectedResponse)
	}
	
	@MainActor
	func testCuratedFeedViewModelPaginate() async {
		let viewModel = CuratedFeedViewModel(service: CuratedFeedServiceMock())
		await viewModel.loadNextPage()
		XCTAssertEqual(viewModel.photos.count, 3)
		await viewModel.loadNextPage()
		XCTAssertEqual(viewModel.photos.count, 6)
	}
	
	@MainActor
	func testCuratedFeedViewModelNoPagesLeft() async {
		let feedService = CuratedFeedServiceMock()
		let viewModel = CuratedFeedViewModel(service: feedService)
		await viewModel.loadNextPage()
		XCTAssertEqual(viewModel.photos.count, 3)
		feedService.nextPageUrl = nil
		await viewModel.loadNextPage()
		XCTAssertEqual(viewModel.photos.count, 6)
		await viewModel.loadNextPage()
		XCTAssertEqual(viewModel.photos.count, 6)
	}
	
	@MainActor
	func testCuratedFeedViewModelError() async {
		let feedService = CuratedFeedServiceMock()
		feedService.thrownError = URLError(.badServerResponse)
		let viewModel = CuratedFeedViewModel(service: feedService)
		await viewModel.loadNextPage()
		XCTAssertNotNil(viewModel.error)
	}
}

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
