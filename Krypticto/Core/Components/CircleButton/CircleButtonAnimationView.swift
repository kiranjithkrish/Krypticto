//
//  CircleButtonAnimationView.swift
//  Krypticto
//
//  Created by kiranjith on 12/07/2024.
//

import SwiftUI

struct CircleButtonAnimationView: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 5.0)
            .scale(animate ? 1.0 : 0.0)
            .opacity(animate ? 0.0 : 1.0)
            .animation( animate ? Animation.easeOut(duration: 0.5) : .none, value: animate ? 1.0 : 0.0)
            
    }
}

struct CircleButtonAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimationView(animate: .constant(true))
            .background(Color.theme.background)

    }
}

