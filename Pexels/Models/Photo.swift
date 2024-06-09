//
//  Photo.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import Foundation

struct Photo: Identifiable, Hashable {
	let id: Int
	let width: Int
	let height: Int
	let imageUrl: URL
	let thumbnailUrl: URL
	let altText: String?
	
	let photographer: Photographer
	
	var aspectRatio: Double {
		Double(width)/Double(height)
	}
}

extension Photo {
	static let mock: Photo = Photo.mock(id: 0)
	
	static func mock(id: Int) -> Photo {
		Photo(id: id,
			  width: 4000,
			  height: 6000,
			  imageUrl: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg")!,
			  thumbnailUrl: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940")!,
			  altText: "Brown Rocks During Golden Hour",
			  photographer: .mock)
	}
}
