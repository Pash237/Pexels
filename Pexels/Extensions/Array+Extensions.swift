//
//  Array+Extensions.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import Foundation

extension Sequence where Element: Identifiable {
	func uniqued() -> [Element] {
		var set = Set<Element.ID>()
		return filter { set.insert($0.id).inserted }
	}
}
