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
	
	enum Size {
		case thumbnail
		case full
	}
}

extension Photo {
	static let mock: Photo = Photo.mock(id: 2880507)
	static let placeholder: Photo = Photo.mock(id: 2880507)
	
	static func mock(id: Int) -> Photo {
		Photo(id: id,
			  width: 4000,
			  height: 6000,
			  imageUrl: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg")!,
			  thumbnailUrl: URL(string: "https://images.pexels.com/photos/2880507/pexels-photo-2880507.jpeg?auto=compress&cs=tinysrgb&h=350")!,
			  altText: "Brown Rocks During Golden Hour",
			  photographer: .mock)
	}
}
