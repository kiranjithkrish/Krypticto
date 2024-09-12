//
//  String.swift
//  Krypticto
//
//  Created by kiranjith on 29/07/2024.
//

import Foundation


extension String {
	
	var removeHTML: String {
		do {
				let regex = try NSRegularExpression(pattern: "<[^>]+>", options: .caseInsensitive)
				return regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "")
			} catch {
				print("Error creating regex: \(error)")
				return self
			}
	}
}
