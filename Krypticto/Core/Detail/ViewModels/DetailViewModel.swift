//
//  DetailViewModel.swift
//  Krypticto
//
//  Created by kiranjith on 27/07/2024.
//

import Foundation
import Combine


class CoinDetailViewModel: ObservableObject {
	let detailService: CoinDetailDataService
	
	@Published var overviewStats: [StatisticsModel] = []
	@Published var additionalStats: [StatisticsModel] = []
	
	@Published var coin: CoinModel
	
	var cancellables = Set<AnyCancellable>()
	
	init(coin: CoinModel) {
		self.coin = coin
		self.detailService = CoinDetailDataService(coin: coin)
		addSubscribers()
		
	}
	
	var coinOverView: (CoinModel) -> [StatisticsModel] = { (coinModel) -> [StatisticsModel] in
		let price = coinModel.currentPrice.asCurrencyWith2Decimals()
		let pricePercentChange = coinModel.priceChangePercentage24H
		let priceStat = StatisticsModel(title: "Current Price", value: price, percentageChange: pricePercentChange)
		
		let marketCap = "$" + (coinModel.marketCap?.formattedWithAbbreviations() ?? "")
		let marketcapChange = coinModel.marketCapChangePercentage24H
		let marketcapStat = StatisticsModel(title: "Market Capitalization", value: marketCap, percentageChange: marketcapChange)
		
		let rank = "\(coinModel.rank)"
		let rankStat = StatisticsModel(title: "Rank", value: rank)
		
		let volume = "$" + (coinModel.totalVolume?.formattedWithAbbreviations() ?? "")
		let volumestat = StatisticsModel(title: "Voume", value: volume)
		
		let overviewInfo: [StatisticsModel] = [priceStat, marketcapStat, rankStat, volumestat]
		return overviewInfo
	}
	
	var additionInfo: (CoinModel, CoinDetailModel?) -> [StatisticsModel] = { (coinModel, coinDetails) -> [StatisticsModel] in
		
		let high = coinModel.high24H?.asCurrencyWith2Decimals() ?? "n/a"
		let highStat = StatisticsModel(title: "24H High", value: high)
		
		let low = coinModel.low24H?.asCurrencyWith2Decimals() ?? "n/a"
		let lowStat = StatisticsModel(title: "24H Low", value: low)
		
		let priceChange = coinModel.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
		let pricePercentChange2 = coinModel.priceChangePercentage24H
		let percentChangeStat = StatisticsModel(title: "24H Price Change", value: priceChange, percentageChange: pricePercentChange2)
		
		let marketCapChange = "$" + (coinModel.marketCapChange24H?.formattedWithAbbreviations() ?? "")
		let marketcapPercentChange = coinModel.marketCapChangePercentage24H
		let marketcapChangeStat = StatisticsModel(title: "24H Market Cap Change", value: marketCapChange, percentageChange: marketcapPercentChange)
		
		let blockTime = String(coinDetails?.blockTimeInMinutes ?? 0)
		let blockStat = StatisticsModel(title: "Block Time", value: blockTime)
		
		let hashing = coinDetails?.hashingAlgorithm ?? "n/a"
		let hashingStat = StatisticsModel(title: "Hashing Algorithm", value: hashing)
		
		let additionalDetails: [StatisticsModel] = [highStat, lowStat, percentChangeStat, marketcapChangeStat, blockStat, hashingStat]
		return additionalDetails
	}
	
	private func mapCoinDetailsToStats(coinDetails: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticsModel], additionalInfo: [StatisticsModel]) {
		return (coinOverView(coinModel),additionInfo(coinModel, coinDetails) )
	}
	
	func addSubscribers() {
		self.detailService.$coinDetails
			.combineLatest($coin)
			.map (mapCoinDetailsToStats)
			.sink { [weak self] (overview, additionalInfo) in
				self?.overviewStats = overview
				self?.additionalStats = additionalInfo
			}
			.store(in: &cancellables)
	}
}
