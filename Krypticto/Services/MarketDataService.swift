//
//  CoinDataService.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import Foundation
import Combine

class MarketDataService {
	@Published var marketData: MarketDataModel? = nil
	var cancellables = Set<AnyCancellable>()
	var marketDataSubscription: AnyCancellable?
	
	init() {
		getMarketData()
	}
	
	 func getMarketData() {
		guard let marketUrl = URL(string:"https://api.coingecko.com/api/v3/global") else {
			return
		}
		
		marketDataSubscription =
		NetworkingManager.download(request: marketUrl)
			.decode(type: MarketGolbalDataModel.self, decoder: JSONDecoder())
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] global in
				self?.marketData = global.data
				self?.marketDataSubscription?.cancel()
			})
	}
}
