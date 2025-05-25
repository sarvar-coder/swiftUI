//
//  CardView.swift
//  Kavsoft
//
//  Created by Sarvar Boltaboyev on 24/05/25.
//

import SwiftUI

struct CardView: View {
    
    var body: some View {
        VStack {
            RecipeImageView()
            
            VStack(alignment: .leading) {
                HStack {
                    Text("Name")
                }
                Divider()
                HStack {
                    Text("country")
                }
                
                HStack {
                    Text("type")
                }
            }
        }
        .background(.gray.opacity(0.19))
        .cornerRadius(10)
            
    }
       
    @ViewBuilder
    func RecipeImageView() -> some View {
       
            Image("dog")
                .resizable()
                .frame(height: 300)
                .frame(width: 360)
                .cornerRadius(10)
//                .border(Color.black, width: 2)
                .cornerRadius(10)
//                .shadow(radius: 5, x: -0, y: 5)
                
                
    }
}


#Preview {
    CardView()
}
