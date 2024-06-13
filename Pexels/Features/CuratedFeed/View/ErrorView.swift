//
//  ErrorView.swift
//  Pexels
//
//  Created by Pavel Alexeev on 13.06.2024.
//

import SwiftUI

struct ErrorView: View {
	let error: Error
	
    var body: some View {
		VStack {
			Text("😔")
			Text(error.localizedDescription)
				.multilineTextAlignment(.center)
		}
		.frame(minHeight: 150)
    }
}

#Preview {
	ErrorView(error: URLError(.badServerResponse))
}
