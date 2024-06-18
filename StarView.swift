//
//  StarView.swift
//  Padua
//
//  Created by Berke Demirbaş on 22.05.2024.
//

import SwiftUI

struct StarView: View {
    @Binding var rating: Int
    var shape: String

    var label = ""

    var maximumRating = 5

    var offImage: Image?
    var onImage: Image {
        shape == "star" ? Image(systemName: "star.fill") : Image(systemName: "turkishlirasign.circle.fill")
    }
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
            offImage ?? onImage
        } else {
            onImage
        }
    }
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            }
                        
            ForEach(1..<maximumRating + 1, id: \.self) { number in
                if shape == "lira" {
                    Spacer()
                }
                Button {
                    rating = number
                } label: {
                    image(for: number)
                        .foregroundStyle(number > rating ? offColor : onColor)
                }
                
            }
        }
    }
}

#Preview {
    StarView(rating: .constant(3), shape: "star")
}
