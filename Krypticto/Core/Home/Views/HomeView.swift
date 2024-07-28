//
//  HomeView.swift
//  Krypticto
//
//  Created by kiranjith on 12/07/2024.
//

import SwiftUI

struct HomeView: View {
    @State private var showPortfolio: Bool = false
	@State private var showMyPortfolioView: Bool = false
	
	@State private var showDetailView: Bool = false
	@State private var selectedCoin: CoinModel? = nil
	
    @EnvironmentObject private var viewModel: HomeViewModel
    
    var body: some View {
		NavigationStack {
			ZStack {
				Color.theme.background.ignoresSafeArea()
					.sheet(isPresented: $showMyPortfolioView, content: {
						PortfolioView()
							.environmentObject(viewModel)
						Text("A sheet")
					})
				
				VStack {
					homeHeader
					HomeStatsView(showPortfolio: $showPortfolio)
					SearchBarView(searchText: $viewModel.searchText)
					columsTitle
					if !showPortfolio {
						allCoinsList
							.transition(.move(edge: .leading))
					} else {
						portfolioCoinsList
							.transition(.move(edge: .trailing))
					}
					Spacer(minLength: 0)
				}
			}
			.navigationDestination(for: CoinModel.self) { coin in
				DetailView(coin: coin)
			}
		}
		
    }
}

extension HomeView {
	
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background {
                    CircleButtonAnimationView(animate: $showPortfolio)
                }
				.onTapGesture {
					showMyPortfolioView.toggle()
				}
                .animation(.none, value: 0)
            Spacer()
            Text(showPortfolio ? "Portfolio" :"Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
                .animation(.smooth(duration: 1.0), value: 0)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(viewModel.allCoins) { coin in
				NavigationLink(value: coin) {
					CoinRowView(coin: coin, showHoldingsColums: false)
						.listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
				}
               
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(viewModel.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingsColums: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
					.onTapGesture {
						//segue(coin: coin)
					}
            }
        }
        .listStyle(.plain)
    }
	
	private func segue(coin: CoinModel) {
		self.selectedCoin = coin
	}
    
    private var columsTitle: some View {
        HStack {
			HStack {
				Text("Coin")
				Image(systemName: "chevron.down")
					.opacity((viewModel.sort == .rank || viewModel.sort == .rankReversed) ? 1.0 : 0.0)
					.rotationEffect(Angle(degrees: viewModel.sort == .rank ? 0 : 180))
			}
			.onTapGesture {
				withAnimation(.default) {
					viewModel.sort = viewModel.sort == .rank ? .rankReversed : .rank
				}
			}
			
            Spacer()
			
            if showPortfolio {
				HStack {
					Text("Holdings")
					Image(systemName: "chevron.down")
						.opacity((viewModel.sort == .holdings || viewModel.sort == .holdingsReversed) ? 1.0 : 0.0)
						.rotationEffect(Angle(degrees: viewModel.sort == .holdings ? 0 : 180))
				}
				.onTapGesture {
					withAnimation(.default) {
						viewModel.sort = viewModel.sort == .rank ? .rankReversed : .rank
					}
				}
            }
			
			HStack {
				Text("Price")
				Image(systemName: "chevron.down")
					.opacity((viewModel.sort == .price || viewModel.sort == .priceReversed) ? 1.0 : 0.0)
					.rotationEffect(Angle(degrees: viewModel.sort == .price ? 0 : 180))
			}
			.frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
			.onTapGesture {
				withAnimation(.default) {
					viewModel.sort = viewModel.sort == .price ? .priceReversed : .price
				}
				
			}
			
			Button(action: {
				withAnimation(.linear(duration: 2.0)) {
					viewModel.reloadData()
				}
			}, label: {
				Image(systemName: "goforward")
			})
			.rotationEffect(Angle(degrees: viewModel.isLoading ? 360 : 0))
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .padding(.horizontal)
    }
}

//struct LazyView<Content: View>: View {
//	let build: () -> Content
//	init(_ build: @autoclosure @escaping () -> Content) {
//		self.build = build
//	}
//	var body: Content {
//		build()
//	}
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(content: {
            HomeView()
                
        })
        .environmentObject(dev.homeVM)
    }
}

