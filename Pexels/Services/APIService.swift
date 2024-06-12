//
//  APIService.swift
//  Pexels
//
//  Created by Pavel Alexeev on 07.06.2024.
//

import Foundation
@preconcurrency import OSLog

protocol APIServiceProtocol: Sendable {
	func get<Response: Decodable>(method: String, parameters: [String: CustomStringConvertible]) async throws -> Response
}

final class APIService: APIServiceProtocol {
	private let baseURL = URL(string: "https://api.pexels.com/v1")!
	// TODO: we probably should store API key somewhere outside of the repo
	private let apiKey = "QQecfOrKp7vuyWQZ5ungSdMXHvgnK0YcXuNY6YSwIAG2LJul8K7ed1r1"
	
	private let urlSession = URLSession.shared
	private let logger = Logger()
	
	func get<Response: Decodable>(method: String, parameters: [String: CustomStringConvertible] = [:]) async throws -> Response {
		let url = baseURL.appending(component: method)
		guard var components = URLComponents(url: url, resolvingAgainstBaseURL: false) else { throw URLError(.badURL) }
		components.queryItems = components.queryItems ?? []
		components.queryItems?.append(contentsOf: parameters.map { key, value in
			URLQueryItem(name: key, value: value.description)
		})
		guard let url = components.url else { throw URLError(.badURL) }
		
		logger.info("--> \(url)")
		
		var request = URLRequest(url: url)
		request.setValue(apiKey, forHTTPHeaderField: "Authorization")
		
		let (data, _) = try await urlSession.data(for: request)
		
		logger.info("<-- \(url) \(String(data: data, encoding: .utf8) ?? "[empty]")")
		
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode(Response.self, from: data)
	}
}
