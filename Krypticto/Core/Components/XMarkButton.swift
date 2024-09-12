//
//  XMarkButton.swift
//  Krypticto
//
//  Created by kiranjith on 17/07/2024.
//

import SwiftUI

struct XMarkButton: View {
	@Environment(\.dismiss) private var dismiss
	
    var body: some View {
		Button(action: {
			dismiss()
		}, label: {
			Image(systemName: "xmark")
				.font(.headline)
		})
    }
}

#Preview {
    XMarkButton()
}
