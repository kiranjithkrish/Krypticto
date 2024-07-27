//
//  PortfolioView.swift
//  Krypticto
//
//  Created by kiranjith on 17/07/2024.
//

import SwiftUI

struct PortfolioView: View {
	
	@EnvironmentObject private var viewModel: HomeViewModel
	@State private var selectedCoin: CoinModel?
	@State private var quantityText: String = ""
	@State private var showCheckmark: Bool = false
	
    var body: some View {
		NavigationView(content: {
			ScrollView {
				VStack(alignment: .leading, spacing: 0, content: {
					SearchBarView(searchText: $viewModel.searchText)
					coinLogoList
					if selectedCoin != nil {
						portfolioInfo
					}
				})
				
			}
			.navigationTitle("Edit Portfolio")
			.toolbar(content: {
				ToolbarItem(placement: .navigationBarLeading) {
					XMarkButton()
				}
				ToolbarItem(placement: .topBarTrailing) {
					trailingNavbarButtons
				}
			})
			.onChange(of: viewModel.searchText) { value in
				if value == "" {
					removeButtonPressed()
				}
			}
		})
    }
}


struct PortfolioView_Previews: PreviewProvider {
	
	static var previews: some View {
		PortfolioView()
			.environmentObject(dev.homeVM)
	}
}


extension PortfolioView {
	private var coinLogoList: some View {
		ScrollView(.horizontal, showsIndicators: false) {
			LazyHStack(spacing: 10) {
				ForEach(viewModel.searchText == "" ? viewModel.portfolioCoins : viewModel.allCoins) { coin in
					CoinLogoView(coin: coin)
						.frame(width: 75)
						.padding()
						.onTapGesture {
							updatePortfolioView(coin: coin)
						}
						.background(
							RoundedRectangle(cornerRadius: 10.0)
								.stroke(selectedCoin?.id == coin.id ?  Color.theme.green : Color.clear , lineWidth: 1)
						)
				}
			}
			.padding(.vertical, 4)
			.padding(.leading)
		}
	}
	
	private func updatePortfolioView(coin: CoinModel) {
		selectedCoin  = coin
		if let entity = viewModel.portfolioCoins.first(where: { $0.id == coin.id }), let amount = entity.currentHoldings {
			quantityText = "\(amount)"
		} else {
			quantityText = ""
		}
		
	}
	
	private func getCurrentValue() -> Double {
		if let quantity = Double(quantityText) {
			return quantity * (selectedCoin?.currentPrice ?? 0)
		}
		return 0.0
	}
	
	private var portfolioInfo: some View {
		VStack(spacing: 20, content: {
			HStack(content: {
				Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
				Spacer()
				Text(selectedCoin?.currentPrice.asCurrencyWith2Decimals() ?? "")
			})
			Divider()
			HStack(content: {
				Text("Current Holdings:")
				Spacer()
				TextField("Ex: 1.4", text: $quantityText)
					.multilineTextAlignment(.trailing)
					.keyboardType(.decimalPad)
				
			})
			Divider()
			HStack(content: {
				Text("Current value:")
				Spacer()
				Text(getCurrentValue().asCurrencyWith2Decimals())
			})
		})
		.animation(.none, value: 0)
		.padding()
		.font(.headline)
	}
	
	private var trailingNavbarButtons: some View {
		HStack {
			Image(systemName: "checkmark")
				.opacity(showCheckmark ? 1.0: 0.0)
			Button(action: {
				saveButtonPressed()
			}, label: {
				Text("SAVE")
			})
			.opacity((selectedCoin != nil && selectedCoin?.currentHoldings != Double(quantityText)) ? 1.0 : 0.0)
		}
		.font(.headline)
	}
	
	private func saveButtonPressed() {
		guard let coin = selectedCoin, let amount = Double(quantityText) else {
			return
		}
		viewModel.updateHoldings(coin: coin, amount: amount)
		withAnimation(.easeIn) {
			showCheckmark = true
			removeButtonPressed()
		}
		
		UIApplication.shared.endEditing()
		DispatchQueue.main.asyncAfter(deadline: .now()+2.0, execute: {
			withAnimation(.easeOut) {
				showCheckmark = false
			}
		})
	}
	
	private func removeButtonPressed() {
		selectedCoin = nil
		viewModel.searchText = ""
	}
}
