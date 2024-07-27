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
	
	init() {
		UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
		UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
	}
    
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                HomeView()
                    .navigationBarHidden(true)
                
            })
            .environmentObject(homeViewModel)
        }
    }
}
