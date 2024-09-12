//
//  HomeViewModel.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import Foundation
import Combine


class HomeViewModel: ObservableObject {
	
	@Published var statistics: [StatisticsModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
	@Published var searchText: String = ""
	@Published var sort: SortOption = .holdings
	@Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
	private let marketDataServie = MarketDataService()
	private let portfolioDataService = PortfolioDataService()
	
    private var cancellebles = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
	
	enum SortOption {
		case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
	}
    
    func addSubscribers() {
		$searchText
			.combineLatest(coinDataService.$allCoins, $sort)
			.debounce(for: .seconds(1 ), scheduler: DispatchQueue.main)
			.map(filterAndSortCoins)
			.sink { [weak self] coins in
				self?.allCoins = coins
			}
			.store(in: &cancellebles)
		
		$allCoins.combineLatest(portfolioDataService.$savedEntities)
			.map(mapAllCoinsToPortfolioCoins)
			.sink { [weak self] returnedCoins in
				guard let self = self else {
					return
				}
				self.portfolioCoins = self.sortPortfolioCoinsIfNeeded(coins: returnedCoins)
			}
			.store(in: &cancellebles)

		marketDataServie.$marketData
			.combineLatest($portfolioCoins)
			.map(mapGlobalMarketData)
			.sink { [weak self] in
				self?.statistics = $0
				self?.isLoading = false
			}
			.store(in: &cancellebles)
		
		
    }
	
	func updateHoldings(coin: CoinModel, amount: Double) {
		portfolioDataService.updatePortfolio(entity: coin, amount: amount)
	}
	
	func reloadData() {
		isLoading = true
		HapticManager.notification(type: .success)
		coinDataService.getCoins()
		marketDataServie.getMarketData()
	}
	
	private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioEntities: [PortfolioEntity]) -> [CoinModel] {
		allCoins.compactMap { coin -> CoinModel? in
			portfolioEntities.first(where: { $0.coinId == coin.id}).map {
				return coin.updateCurrentHoldings(amount: $0.amount)
			}
		}
	}
	
	private func mapGlobalMarketData(data: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticsModel] {
		var stats: [StatisticsModel] = []
		
		guard let data = data else {
			return stats
		}
		let marketCap = StatisticsModel(title: "Market Cap", value: data.totalMarketCapUSD, percentageChange: data.marketCapChangePercentage24HUsd)
		let volume = StatisticsModel(title: "24h Volume", value: data.totalVolumeUsd)
		let portfolioValue = portfolioCoins
			.map { $0.currentHoldingsValue }
			.reduce(0, +)
		
		let previousPortfolioValue = portfolioCoins.map { (coin) -> Double in
			let currentValue = coin.currentHoldingsValue
			guard let priceChange = coin.priceChangePercentage24H else {
				return currentValue
			}
			let previousValue = currentValue/(1+(priceChange/100))
			return previousValue
		}
		.reduce(0, +)
		
		let percentageChange = ((portfolioValue-previousPortfolioValue)/previousPortfolioValue)
		
		let portfolio = StatisticsModel(title: "Portfolio Value", value: "\(portfolioValue.asCurrencyWith2Decimals())", percentageChange: percentageChange)
		let btcDominance = StatisticsModel(title: "BTC Dominance", value: data.bitcoinDominance)
		
		stats.append(contentsOf: [marketCap, volume, portfolio, btcDominance])
		return stats
	}
	private func filterAndSortCoins(text: String, coins: [CoinModel], sort: SortOption) -> [CoinModel] {
		var updatedCoins = filterCoins(text: text, coins: coins)
		sortCoins(filteredCoins: &updatedCoins, sort: sort)
		return updatedCoins
	}
	
	private func sortCoins(filteredCoins:inout [CoinModel], sort: SortOption) {
		switch sort {
		case .rank, .holdings:
			filteredCoins.sort(by: { $0.rank < $1.rank})
		case .rankReversed, .holdingsReversed:
			filteredCoins.sort(by: { $0.rank > $1.rank})
			
		case .price:
			 filteredCoins.sort(by: { $0.currentPrice > $1.currentPrice})
			
		case .priceReversed:
			 filteredCoins.sort(by: { $0.currentPrice < $1.currentPrice})
			
		}
	}
	
	private func sortPortfolioCoinsIfNeeded(coins: [CoinModel]) -> [CoinModel] {
		switch sort {
		case .holdings:
			return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue})
		case .holdingsReversed:
			return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue})
		default:
			return coins
		}
	}
	
	private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
		guard !searchText.isEmpty else {
			return coins
		}
		let lowerCasedSearchText = searchText.lowercased()
		return coins.filter { (coin) -> Bool in
			return coin.name.lowercased().contains(lowerCasedSearchText) ||
			coin.id.contains(lowerCasedSearchText) ||
			coin.symbol.contains(lowerCasedSearchText)
		}
	}
		
	

}
