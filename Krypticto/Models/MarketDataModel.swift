//
//  MarketDataModel.swift
//  Krypticto
//
//  Created by kiranjith on 16/07/2024.
//

import Foundation

struct MarketGolbalDataModel: Codable {
	let data: MarketDataModel?
}

// MARK: - DateClass
struct MarketDataModel: Codable {
	
	let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]?
	let marketCapChangePercentage24HUsd: Double?
	let updatedAt: Int?
	
	init(totalMarketCap: [String : Double]?, totalVolume: [String : Double]?, marketCapPercentage: [String : Double]?, marketCapChangePercentage24HUsd: Double?, updatedAt: Int) {
		self.totalMarketCap = totalMarketCap
		self.totalVolume = totalVolume
		self.marketCapPercentage = marketCapPercentage
		self.marketCapChangePercentage24HUsd = marketCapChangePercentage24HUsd
		self.updatedAt = updatedAt
	}

	enum CodingKeys: String, CodingKey {
		case totalMarketCap = "total_market_cap"
		case totalVolume = "total_volume"
		case marketCapPercentage = "market_cap_percentage"
		case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
		case updatedAt = "updated_at"
	}
	
	var totalMarketCapUSD: String {
		guard let coin = totalMarketCap?.first(where: { (key, value) in
			key == "usd"
		}) else {
			return ""
		}
		return "$" + coin.value.formattedWithAbbreviations()
	}
	
	var totalVolumeUsd: String {
		guard let coin = totalVolume?.first(where: {
			$0.key == "usd"
		}) else {
			return ""
		}
		return "$" + coin.value.formattedWithAbbreviations()
	}
	
	var bitcoinDominance: String {
		guard let coin = marketCapPercentage?.first(where: {
			$0.key == "btc"
		}) else {
			return ""
		}
		return coin.value.asNumberString()
				
	}
	
	
}


