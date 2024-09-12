//
//  ChartView.swift
//  Krypticto
//
//  Created by kiranjith on 28/07/2024.
//

import SwiftUI

struct ChartView: View {
	
	private let data: [Double]
	private let maxY: Double
	private let minY: Double
	private let lineColor: Color
	private let startingDate: Date
	private let endingDate: Date
	@State private var percentage: CGFloat = 0.0
	
	init(coin: CoinModel) {
		self.data = coin.sparklineIn7D?.price ?? []
		maxY = self.data.max() ?? 0
		minY = self.data.min() ?? 0
		let priceChange = (data.last ?? 0) - (data.first ?? 0)
		lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
		endingDate = Date(coinGeckoString: coin.lastUpdated ?? "what")
		startingDate = endingDate.addingTimeInterval(-7*24*60*60)
	}
    var body: some View {
		VStack {
			chartView
			.frame(height: 200)
			.background(chartBackground)
			.overlay(
				chartAxis, alignment: .leading
			)
			dateInfo
		
		}
		.font(.caption)
		.foregroundStyle(Color.theme.secondaryText)
		.onAppear {
			DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
				withAnimation(.linear(duration: 2)) {
					percentage = 1.0
				}
				
				
			}
		}
			
    }
}


struct ChartView_Previews: PreviewProvider {
	
	static var previews: some View {
		ChartView(coin: dev.coin)
	}
}


extension ChartView {
	
	private var chartView: some View {
		GeometryReader { geometry in
			Path({ path in
				for index in data.indices {
					let xPostion = (geometry.size.width/CGFloat(data.count)) * CGFloat(index+1)
					let yAxis = maxY-minY
					let yPosition = CGFloat(1-(data[index] - minY)/yAxis) * geometry.size.height
					if index == 0 {
						path.move(to: CGPoint(x: xPostion, y: yPosition))
					}
					path.addLine(to: CGPoint(x: xPostion, y: yPosition))
				}
			})
			.trim(from: 0, to: percentage)
			.stroke(lineColor ,style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round) )
			.shadow(color: lineColor, radius: 10, x: 0, y: 10)
			.shadow(color: lineColor.opacity(0.4), radius: 10, x: 0, y: 10)
			.shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 10)
		}
	}
	
	private var chartBackground: some View {
		VStack {
			Divider()
			Spacer()
			Divider()
			Spacer()
			Divider()
		}
	}
	
	private var chartAxis: some View {
		VStack {
			Text(maxY.formattedWithAbbreviations())
			Spacer()
			Text(((minY+maxY)/2).formattedWithAbbreviations())
			Spacer()
			Text(minY.formattedWithAbbreviations())
		}
	}
	
	private var dateInfo: some View {
		HStack {
			Text(startingDate.asShortDateFormat())
			Spacer()
			Text(endingDate.asShortDateFormat())
		}
	}
}
