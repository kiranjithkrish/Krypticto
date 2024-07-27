//
//  XMarkButton.swift
//  Krypticto
//
//  Created by kiranjith on 17/07/2024.
//

import SwiftUI

struct XMarkButton: View {
	@Environment(\.presentationMode) var presentationMode
	
    var body: some View {
		Button(action: {
			
		}, label: {
			Image(systemName: "xmark")
				.font(.headline)
		})
    }
}

#Preview {
    XMarkButton()
}
