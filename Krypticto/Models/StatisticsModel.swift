//
//  StatisticsModel.swift
//  Krypticto
//
//  Created by kiranjith on 14/07/2024.
//

import Foundation


struct StatisticsModel: Identifiable {
	let id = UUID()
	let title: String
	let value: String
	let percentageChange: Double?
	
	init(title: String, value: String, percentageChange: Double? = nil) {
		self.title = title
		self.value = value
		self.percentageChange = percentageChange
	}
}
