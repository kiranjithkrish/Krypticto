//
//  ContentView.swift
//  Krypticto
//
//  Created by kiranjith on 09/07/2024.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack {
                Color.theme.background.ignoresSafeArea()
                VStack {
                    Text("Accent Color")
                        .foregroundColor(Color.theme.red)
                    Text("Red Color")
                        .foregroundColor(Color.theme.green)
                }
                .font(.headline)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
