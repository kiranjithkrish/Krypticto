//
//  LaunchView.swift
//  Krypticto
//
//  Created by kiranjith on 30/07/2024.
//

import SwiftUI

struct LaunchView: View {
	
	@State private var loadingText: String = "Loading your portfolio..."
	@State private var showLoadingText: Bool = false
	
	private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
	
	@State private var counter = 0
	
	@Binding var showLaunchView: Bool
	
    var body: some View {
		ZStack {
			Color.theme.background
				.ignoresSafeArea()
			VStack {
				Image("logo-transparent")
					.resizable()
					.frame(width: 100, height: 100, alignment: .center)
				
					Text(loadingText)
					.font(.headline)
					.fontWeight(.heavy)
					.foregroundStyle(Color.launchAccent)
			}
			
			
		}
		.onAppear {
			showLoadingText.toggle()
		}
		.onReceive(timer, perform: { _ in
			counter += 1
			if counter > 5 {
				showLaunchView = false
			}
		})
    }
}

#Preview {
	LaunchView(showLaunchView: .constant(true))
}
