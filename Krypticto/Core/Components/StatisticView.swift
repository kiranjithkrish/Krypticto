//
//  StatisticView.swift
//  Krypticto
//
//  Created by kiranjith on 14/07/2024.
//

import SwiftUI

struct StatisticView: View {
	let stat: StatisticsModel
    var body: some View {
		VStack {
			Text(stat.title)
				.font(.caption)
				.foregroundColor(Color.theme.secondaryText)
			Text(stat.value)
				.font(.headline)
				.foregroundColor(Color.theme.accent)
			
			HStack {
				Image(systemName: "triangle.fill")
					.font(.caption2)
					.rotationEffect(Angle(degrees: stat.percentageChange ?? 0 >= 0 ? 0 : 180))
				Text(stat.percentageChange?.asPercentString() ?? "")
					.font(.caption)
					.bold()
			}
			.foregroundColor(stat.percentageChange ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
			.opacity(stat.percentageChange == nil ? 0.0 : 1.0)
			
		}
    }
}


struct StatisticView_Preview: PreviewProvider {
	static var previews: some View {
		Group  {
			StatisticView(stat: dev.staticsModel)
				.previewLayout(.sizeThatFits)
			StatisticView(stat: dev.staticsModel2)
				.previewLayout(.sizeThatFits)
			StatisticView(stat: dev.staticsModel3)
				.previewLayout(.sizeThatFits)
		}
		
	}
}
