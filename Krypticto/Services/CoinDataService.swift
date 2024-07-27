//
//  CoinDataService.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import Foundation
import Combine

class CoinDataService {
    @Published var allCoins: [CoinModel] = []
    var cancellables = Set<AnyCancellable>()
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
	func getCoins() {
		guard let coinUrl = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=gbp&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h") else {
			return
		}
		
		coinSubscription =
		NetworkingManager.download(request: coinUrl)
			.decode(type: [CoinModel].self, decoder: JSONDecoder())
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coins in
				self?.allCoins = coins
				self?.coinSubscription?.cancel()
			})
	}
}
