//
//  CoinImageViewModel.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
	@Published var image: UIImage? = nil
	@Published var isLoading: Bool = false
	
	private let dataService: CoinImageService
	private var cancellebles = Set<AnyCancellable>()
	
	init(coinImageUrl: String, coinName: String) {
		self.dataService = CoinImageService(urlString: coinImageUrl, imageName: coinName)
		addSubscribers()
	}
	
	func addSubscribers() {
		 self.dataService.$image
			.sink(receiveCompletion: { [weak self] (_) in
				self?.isLoading = false
			},receiveValue: { [weak self] image in
				self?.image = image
			})
			.store(in: &cancellebles)
	}
}
