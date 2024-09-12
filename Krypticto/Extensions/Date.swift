//
//  Date.swift
//  Krypticto
//
//  Created by kiranjith on 28/07/2024.
//

import Foundation


extension Date {
	
	init(coinGeckoString: String) {
		let formatter = DateFormatter()
		formatter.dateFormat = "2021-03-13T23:18:10.268Z"
		let date = formatter.date(from: coinGeckoString) ?? Date() 
		self.init(timeInterval: 0, since: date)
	}
	
	private var shortFormatter: DateFormatter {
		let formatter = DateFormatter()
		formatter.dateStyle = .short
		return formatter
	}
	
	func asShortDateFormat() -> String {
		return shortFormatter.string(from: self)
	}
}
