//
//  CoinRowView.swift
//  Krypticto
//
//  Created by kiranjith on 12/07/2024.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingsColums: Bool
    
    var body: some View {
        HStack {
            leftColum
            Spacer()
            if showHoldingsColums {
               middleColums
            }
            rightColums
            
            
        }
    }
}

extension CoinRowView {
    private var leftColum: some View {
        HStack {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            .frame(minWidth: 30)
			CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
        }
    }
    
    private var middleColums: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
    }
    
    private var rightColums: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor( coin.priceChangePercentage24H ?? 0 >= 0 ? Color.theme.green : Color.theme.red)
        }
        .frame(width: UIScreen.main.bounds.width/3, alignment: .trailing)
    }
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CoinRowView(coin: dev.coin, showHoldingsColums: true )
                .previewLayout(.sizeThatFits)
            CoinRowView(coin: dev.coin, showHoldingsColums: true )
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
        }
    }

}
