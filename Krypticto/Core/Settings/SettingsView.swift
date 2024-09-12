//
//  SettingsView.swift
//  Krypticto
//
//  Created by kiranjith on 29/07/2024.
//

import SwiftUI

struct SettingsView: View {
	let defaultUrl = URL(string: "www.google.com")!
	
    var body: some View {
		NavigationView(content: {
			List {
				Section {
					Text("Header")
					Text("Header")
					
				} header: {
					Text("Header")
				}

			}
			.listStyle(.grouped)
			.navigationTitle("Settings")
			.toolbar(content: {
				ToolbarItem(placement: .topBarLeading) {
					XMarkButton()
				}
			})
		})
    }
}

#Preview {
    SettingsView()
}
