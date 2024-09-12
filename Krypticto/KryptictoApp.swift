//
//  KryptictoApp.swift
//  Krypticto
//
//  Created by kiranjith on 09/07/2024.
//

import SwiftUI

@main
struct KryptictoApp: App {
    
    @StateObject private var homeViewModel = HomeViewModel()
	@State private var showLaunchView = true
	
	init() {
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
	}
    
    var body: some Scene {
        WindowGroup {
			ZStack {
				NavigationStack {
					HomeView()
						.navigationBarHidden(true)
					
				} 
				.environmentObject(homeViewModel)
				
				ZStack {
					if showLaunchView {
						LaunchView(showLaunchView: $showLaunchView)
							.transition(.move(edge: .leading))
					}
				}
				.zIndex(2.0)
				
				
			}
           
        }
    }
}
