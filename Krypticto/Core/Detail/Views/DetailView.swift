//
//  DetailView.swift
//  Krypticto
//
//  Created by kiranjith on 27/07/2024.
//

import SwiftUI

struct DetailView: View {
	
	let coin: CoinModel
	
	@StateObject var viewModel: CoinDetailViewModel
	
	private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
	
	private let spacing: CGFloat = 30
	
	init(coin: CoinModel) {
		self.coin = coin
		_viewModel  = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
	}
	
    var body: some View {
		ScrollView {
			VStack(spacing: 20) {
				Text(coin.name)
					.frame(height: 150)
				Text("Overview")
					.font(.title)
					.bold()
					.foregroundStyle(Color.theme.accent)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				Divider()
				
				LazyVGrid(columns: columns,
						  alignment: .leading,
						  spacing: spacing,
						  content: {
					ForEach(viewModel.overviewStats) { stat  in
						StatisticView(stat: stat)
					}
				})
				
				Text("Additional Details")
					.font(.title)
					.bold()
					.foregroundStyle(Color.theme.accent)
					.frame(maxWidth: .infinity, alignment: .leading)
				
				LazyVGrid(columns: columns,
						  alignment: .leading,
						  spacing: spacing,
						  content: {
					ForEach(viewModel.additionalStats) { stat in
						StatisticView(stat: stat)
					}
				})
			}
			.padding()
		}
		.navigationTitle(coin.name)
		
    }
}

struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			DetailView(coin: dev.coin)
		}
	}
}
