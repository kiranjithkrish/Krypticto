//
//  NetworkingManager.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import Foundation
import Combine


class NetworkingManager {
	
	enum NetworkingError: LocalizedError {
		case badUrlResponse(url: URL)
		case unknown
		case urlMissing
		
		
		var errorDescription: String? {
			switch self {
			case .badUrlResponse(let url):
				return "Please check the url [🔥]"
			case .unknown:
				return "Unknown error [‼️]"
			case .urlMissing:
				return "Url is missing [‼️]"
			}
		}
	}
	
	static func download(request: URL) ->  AnyPublisher<Data, Error> {
		var request = URLRequest(url: request)
		request.httpMethod = "GET"
		request.setValue("CG-GWvPtSF2sC16Ax1oqHmjr2pK", forHTTPHeaderField: "Authorization")
		
		return URLSession.shared.dataTaskPublisher(for: request)
			.subscribe(on: DispatchQueue.global(qos: .default))
			.tryMap {
				try handleURLResponse(output: $0, url: request.url!)
			}
			.receive(on: DispatchQueue.main)
			.eraseToAnyPublisher()
	}
	
	private static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL)  throws -> Data {
		guard let response = output.response as? HTTPURLResponse, response.statusCode >= 200 && response.statusCode <= 300 else {
			throw NetworkingError.badUrlResponse(url: url)
		}
		return output.data
	}
	
	static func handleCompletion(completion: Subscribers.Completion<Error>) {
		switch completion {
		case .finished:
		    break
		case .failure(let error):
		    print("API failed to load", error.localizedDescription)
		}
	}
}
