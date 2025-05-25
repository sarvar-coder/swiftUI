//
//  Home.swift
//  Kavsoft
//
//  Created by Sarvar Boltaboyev on 23/05/25.
//

import SwiftUI

struct Home: View {
    
    @State private var colors: [Color] = [.red, .blue, .green, .orange, .purple, .yellow]
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                ForEach(colors, id: \.self) { color in
                    SwipeActions(cornerRadius: 15, swipeDirections: .rigthToLeft) {
                        CardView(color)
                    } actions: {
                        Actions(tint: .blue, icon: "star.fill", isEnabled: true) {
                            print("Bookmarked")
                        }
                        Actions(tint: .red, icon: "trash.fill", isEnabled: true) {
                            withAnimation {
                                colors.removeAll(where: { $0 == color })
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func CardView(_ color: Color) -> some View {
        HStack(spacing: 12) {
            Circle()
                .fill(color)
                .frame(width: 50, height: 50)
                .shadow(color: .black, radius: 5, x: -5, y: 5)
            VStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 70, height: 3)
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 50, height: 3)
            }
            
            Spacer()
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(color.gradient)
        .cornerRadius(15)
    }
}

#Preview {
    Home()
}

// MARK: - Custom Swipe Action

struct SwipeActions<Content: View>: View{
    var cornerRadius: CGFloat = 0
    var swipeDirections: SwipeDirections = .rigthToLeft
    @ViewBuilder var content: Content
    @ActionsBuilder var actions: [Actions]
    @State private var isEnabled = true
    @State private var scrollOffset: CGFloat = .zero
    //ViewID
    let viewID = UUID()
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView(.horizontal) {
                HStack(spacing: 0) {
                    content
                        .containerRelativeFrame(.horizontal)
                        .background {
                            if let firstAction = actions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOffset == .zero ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOffset = $0
                                    }
                            }
                        }
                    
                    ActionButtons {
                        withAnimation(.snappy) {
                            scrollProxy.scrollTo(viewID, anchor: swipeDirections == .rigthToLeft ? .trailing : .leading)
                        }
                    }
                    .opacity(scrollOffset == .zero ? 0 : 1)
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden )
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let last = actions.last {
                    Rectangle()
                        .fill(last.tint)
                        .opacity(scrollOffset == .zero ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
        }
        .allowsHitTesting(isEnabled)
        .transition(CustomTransation())
    }
    
    @ViewBuilder
    func ActionButtons(resetPositions: @escaping () -> Void) -> some View {
        // each button have 100 width
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: swipeDirections.alignment) {
                HStack(spacing: 0) {
                    ForEach(actions) { btn in
                        Button {
                            Task {
                                isEnabled = false
                                resetPositions()
                                try? await Task.sleep(for: .seconds(0.25))
                                btn.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                                
                            }
                        } label: {
                            Image(systemName: btn.icon)
                                .font(btn.iconFont)
                                .foregroundStyle(btn.iconTinit)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .clipShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .background(btn.tint)
                        
                    }
                }
            }
    }
    
    func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return swipeDirections == .rigthToLeft ? (minX > 0 ? -minX : 0) : (minX < 0 ? -minX : 0)
    }
}

// Action Models

struct Actions: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTinit: Color = .white
    var isEnabled: Bool
    var action: () -> Void
}

@resultBuilder
struct ActionsBuilder {
    static func buildBlock(_ components: Actions...) -> [Actions] {
        return components
    }
}

// Swipe Directions

enum SwipeDirections {
    case leftToRight
    case rigthToLeft
    
    var alignment: Alignment {
        switch self {
        case .leftToRight:
                .leading
        case .rigthToLeft:
                .trailing
        }
    }
}

/// Custom transition
struct CustomTransation: Transition {
    func body(content: Content, phase: TransitionPhase) -> some View {
        content
            .mask {
                GeometryReader {
                    let size = $0.size
                    
                    Rectangle()
                        .offset(y: phase == .identity ? 0 : -size.height)
                }
                .containerRelativeFrame(.horizontal)
            }
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout Value, nextValue: () -> Value) {
        
    }
}
