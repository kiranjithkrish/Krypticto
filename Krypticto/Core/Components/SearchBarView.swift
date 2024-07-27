//
//  SearchBarView.swift
//  Krypticto
//
//  Created by kiranjith on 14/07/2024.
//

import SwiftUI

struct SearchBarView: View {
	
	
@Binding var searchText: String
	
    var body: some View {
	    HStack {
		  Image(systemName: "magnifyingglass")
			    .foregroundColor(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
		  TextField("Search by name of symbol", text: $searchText)
			    .foregroundColor(Color.theme.accent)
			    .disableAutocorrection(true)
			    .overlay(alignment: .trailing) {
				    Image(systemName: "xmark.circle.fill")
					    .foregroundColor(Color.theme.accent)
					    .padding()
					    .offset(x: 10.0)
					    .opacity(searchText.isEmpty ? 0.0 : 1.0)
					    .onTapGesture {
						    searchText = ""
							UIApplication.shared.endEditing()
					    }
				     
			    }
			    
		    
	    }
	    .padding()
	    .font(.headline)
	    .background {
		    RoundedRectangle(cornerRadius: 25)
			    .fill(Color.theme.background)
			    .shadow(color: Color.theme.accent.opacity(0.15), radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/, x: 0, y: 0)
	    }
	    .padding()
      
    }
}



struct SearchBarView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			SearchBarView(searchText: .constant(""))
				.previewLayout(.sizeThatFits)
				.preferredColorScheme(.dark)
			
			SearchBarView(searchText: .constant(""))
				.previewLayout(.sizeThatFits)
				.preferredColorScheme(.light)
		}
		
	}
}
