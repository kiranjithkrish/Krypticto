//
//  CoinDetailDataService.swift
//  Krypticto
//
//  Created by kiranjith on 27/07/2024.
//


import Foundation
import Combine

class CoinDetailDataService {
	@Published var coinDetails: CoinDetailModel?  = nil
	var cancellables = Set<AnyCancellable>()
	var coinDetailSubscription: AnyCancellable?
	
	let coin: CoinModel
	
	init(coin: CoinModel) {
		self.coin = coin
		getCoins()
	}
	
	func getCoins() {
		guard let coinUrl = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else {
			return
		}
		
		coinDetailSubscription =
		NetworkingManager.download(request: coinUrl)
			.decode(type: CoinDetailModel.self, decoder: JSONDecoder())
			.receive(on: DispatchQueue.main)
			.sink(receiveCompletion: NetworkingManager.handleCompletion, receiveValue: { [weak self] coin in
				self?.coinDetails  = coin
				self?.coinDetailSubscription?.cancel()
			})
	}
}
