//
//  HomeStatsView.swift
//  Krypticto
//
//  Created by kiranjith on 14/07/2024.
//

import SwiftUI

struct HomeStatsView: View {
	
	@Binding var showPortfolio: Bool
	
	@EnvironmentObject private var viewModel: HomeViewModel
	
    var body: some View {
		HStack {
			ForEach(viewModel.statistics) { stat in
				StatisticView(stat: stat)
					.frame(width: UIScreen.main.bounds.width/3)
			}
		}
		.frame(width: UIScreen.main.bounds.width, alignment: showPortfolio ? .leading : .trailing)
    }
}


struct HomeStatsView_Previews: PreviewProvider {
	static var previews: some View {
		HomeStatsView(showPortfolio: .constant(false))
			.environmentObject(dev.homeVM)
	}
}
