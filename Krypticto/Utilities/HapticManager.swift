//
//  HapticManager.swift
//  Krypticto
//
//  Created by kiranjith on 25/07/2024.
//

import Foundation
import SwiftUI

class HapticManager {
	static private let generator = UINotificationFeedbackGenerator()
	
	static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
		generator.notificationOccurred(type)
	}
}
