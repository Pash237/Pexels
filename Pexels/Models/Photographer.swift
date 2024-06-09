//
//  Photographer.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import Foundation

struct Photographer: Identifiable, Hashable {
	let id: Int
	let name: String
	let url: URL
}

extension Photographer {
	static let mock: Photographer = Photographer.mock(id: 0)
	
	static func mock(id: Int) -> Photographer {
		Photographer(
			id: id,
			name: "Deden Dicky Ramdhani",
			url: URL(string: "https://www.pexels.com/@drdeden88")!
		)
	}
}
