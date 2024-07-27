//
//  CoinImageView.swift
//  Krypticto
//
//  Created by kiranjith on 13/07/2024.
//

import SwiftUI




struct CoinImageView: View {
	let coin: CoinModel
	@StateObject var viewModel: CoinImageViewModel
	
	init(coin: CoinModel) {
		self.coin = coin
		_viewModel = StateObject(wrappedValue: CoinImageViewModel(coinImageUrl: coin.image, coinName: coin.name))
	}
	
    var body: some View {
	    ZStack {
		    if let image = viewModel.image {
			Image(uiImage: image)
				    .resizable()
				    .scaledToFit()
		    } else if viewModel.isLoading {
			    ProgressView()
		    } else {
			    Image(systemName: "questionmark")
				    .foregroundColor(Color.theme.secondaryText)
		    }
	    }
    }
}

struct CoinImageView_Previews: PreviewProvider {
	static var previews: some View {
		CoinImageView(coin: dev.coin)
	}
}
