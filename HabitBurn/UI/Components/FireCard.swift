import SwiftUI

struct FireCard<Content: View>: View {
    let content: Content
    let glowEffect: Bool
    
    @State private var isGlowing = false
    
    init(glowEffect: Bool = false, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.glowEffect = glowEffect
    }
    
    var body: some View {
        content
            .fireCardPadding()
            .background(cardBackground)
            .overlay(cardBorder)
            .clipShape(RoundedRectangle(cornerRadius: FireSpacing.cardRadius))
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
            .onAppear {
                if glowEffect {
                    startGlowAnimation()
                }
            }
    }
    
    private var cardBackground: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: FireColors.primaryDark.opacity(0.9), location: 0.0),
                .init(color: FireColors.primaryMedium.opacity(0.9), location: 1.0)
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .background(.ultraThinMaterial)
    }
    
    private var cardBorder: some View {
        RoundedRectangle(cornerRadius: FireSpacing.cardRadius)
            .stroke(FireColors.accentGold.opacity(0.3), lineWidth: 1)
    }
    
    private var shadowColor: Color {
        if glowEffect && isGlowing {
            return FireColors.primaryLight.opacity(0.8)
        }
        return Color.black.opacity(0.4)
    }
    
    private var shadowRadius: CGFloat {
        if glowEffect && isGlowing {
            return 25
        }
        return 8
    }
    
    private var shadowOffset: CGFloat {
        return glowEffect && isGlowing ? 0 : 4
    }
    
    private func startGlowAnimation() {
        withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
            isGlowing.toggle()
        }
    }
}

struct FireCard_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FireCard {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Read Books")
                        .fireHeadingStyle()
                    Text("Track your daily reading habit")
                        .fireCaptionStyle()
                }
            }
            
            FireCard(glowEffect: true) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Drink Water")
                        .fireHeadingStyle()
                    Text("Stay hydrated every day")
                        .fireCaptionStyle()
                }
            }
        }
        .fireScreenPadding()
        .background(FireColors.backgroundGradient)
        .previewLayout(.sizeThatFits)
    }
}