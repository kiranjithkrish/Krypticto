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
	
	@State var showDescription: Bool = false
	
	private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
	
	private let spacing: CGFloat = 30
	
	init(coin: CoinModel) {
		self.coin = coin
		_viewModel  = StateObject(wrappedValue: CoinDetailViewModel(coin: coin))
	}
	
    var body: some View {
		ScrollView {
			
			VStack(spacing: 20) {
				ChartView(coin: viewModel.coin)
				overviewView
				additionalView
			}
			.padding()
		}
		.navigationTitle(coin.name)
		.toolbar(content: {
			ToolbarItem(placement: .navigationBarTrailing) {
				navigationBarTrailingItems
			}
		})
    }
}

struct DetailView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			DetailView(coin: dev.coin)
		}
	}
}


extension DetailView {
	
	private var overviewView: some View {
		VStack {
			Text("Overview")
				.font(.title)
				.bold()
				.foregroundStyle(Color.theme.accent)
				.frame(maxWidth: .infinity, alignment: .leading)
			
			Divider()
			descriptionSection
			LazyVGrid(columns: columns,
					  alignment: .leading,
					  spacing: spacing,
					  content: {
				ForEach(viewModel.overviewStats) { stat  in
					StatisticView(stat: stat)
				}
			})
		}
	}
	
	private var additionalView: some View {
		VStack {
			
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
			websiteSection
		}
	}
	
	private var navigationBarTrailingItems: some View {
		HStack {
			Text(viewModel.coin.symbol.uppercased())
				.font(.headline)
				.foregroundStyle(Color.theme.secondaryText)
			CoinImageView(coin: viewModel.coin)
				.frame(width: 25, height: 25)
		}
	}
	
	private var websiteSection: some View {
		VStack(alignment: .leading) {
			if let website = viewModel.websiteUrl, let url = URL(string: website) {
				Link(destination: url, label: {
					Text("Website")
				})
			}
			if let subreddit  = viewModel.subredditUrl, let url = URL(string: subreddit) {
				Link(destination: url, label: {
					Text("Subreddit")
				})
			}
		}
		.tint(.blue)
		.frame(maxWidth: .infinity, alignment: .leading)
		.font(.headline)
	}
	
	private var descriptionSection: some View {
		ZStack {
			if let coinDescription = viewModel.coinDescription, !coinDescription.isEmpty {
				VStack(alignment: .leading) {
					Text(coinDescription)
						.lineLimit(showDescription ? nil : 3)
						.font(.callout)
						.foregroundStyle(Color.theme.secondaryText)
					Button(action: {
						showDescription.toggle()
					}, label: {
						Text(showDescription ? "Less" : "Read more..")
							.font(.caption)
							.fontWeight(.bold)
							.padding(.vertical, 5)
					})
					.tint(.blue)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				
			}
		}
	}
}
