//
//  ContentView.swift
//  Kavsoft
//
//  Created by Sarvar Boltaboyev on 23/05/25.
//

import SwiftUI

struct StackCardView: View {
    var images = ["1", "2", "3", "4", "5", "6", "7", "8"]
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(images, id: \.self) { image in
                        let index = Double(images.firstIndex(where: { $0 == image }) ?? 0)
                        GeometryReader {
                            let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                            Image(image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width - 30, height: size.height)
                                .clipShape(.rect(cornerRadius: 25))
                            /// Type: 3
                                .scrollTransition(.interactive, axis: .horizontal) { content, phase in
                                    content
                                        .blur(radius: phase == .identity ? 0 : 2, opaque: false)
                                        .scaleEffect(phase == .identity ? 1 : 0.9, anchor: .bottom)
                                        .offset(y: phase == .identity ? 0 : -10)
                                        .rotationEffect(.init(degrees: phase == .identity ? 0 : phase.value * 5), anchor: .bottomTrailing)
                                        .offset(x: minX < 0 ? minX / 2 : -minX)
                                }
                                
                        }
                        .frame(width: 300)
                        .zIndex(-index)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollClipDisabled()
            .scrollTargetBehavior(.viewAligned(limitBehavior: .always))
            .safeAreaPadding(.horizontal, (size.width - (size.width - 30)) / 2)
        }
        .frame(height: 400)
    }
}

#Preview {
    StackCardView()
}

