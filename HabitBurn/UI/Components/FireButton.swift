import SwiftUI

enum FireButtonStyle {
    case primary
    case secondary
    case round
}

struct FireButton: View {
    let title: String
    let style: FireButtonStyle
    let action: () -> Void
    let icon: String?
    let minHeight: CGFloat?
    
    @State private var isPressed = false
    
    init(_ title: String, style: FireButtonStyle = .primary, icon: String? = nil, minHeight: CGFloat? = nil, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
        self.icon = icon
        self.minHeight = minHeight
    }
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: FireSpacing.sm) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .bold))
                }
                
                if style != .round {
                    Text(title)
                        .font(FireFonts.button())
                        .textCase(.uppercase)
                }
            }
            .foregroundColor(foregroundColor)
            .frame(minWidth: minWidth, minHeight: buttonMinHeight)
            .fireButtonPadding()
            .background(backgroundView)
            .overlay(borderView)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, perform: {
            isPressed = true
        }, onPressingChanged: { pressing in
            isPressed = pressing
        })
    }
    
    private var buttonMinHeight: CGFloat {
        return minHeight ?? FireSpacing.minTouchTarget
    }
    
    private var backgroundView: some View {
        Group {
            switch style {
            case .primary, .round:
                FireColors.buttonGradient
            case .secondary:
                FireColors.accentGold.opacity(0.1)
            }
        }
    }
    
    private var borderView: some View {
        Group {
            switch style {
            case .primary:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(FireColors.primaryText.opacity(0.8), lineWidth: 2)
            case .secondary:
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(FireColors.accentGold, lineWidth: 2)
            case .round:
                Circle()
                    .stroke(FireColors.primaryText, lineWidth: 3)
            }
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary, .round:
            return FireColors.primaryText
        case .secondary:
            return FireColors.accentGold
        }
    }
    
    private var minWidth: CGFloat? {
        switch style {
        case .primary, .secondary:
            return 120
        case .round:
            return nil
        }
    }
    
    private var cornerRadius: CGFloat {
        switch style {
        case .primary, .secondary:
            return FireSpacing.buttonRadius
        case .round:
            return FireSpacing.fabSize / 2
        }
    }
    
    private var shadowColor: Color {
        switch style {
        case .primary, .round:
            return FireColors.primaryLight.opacity(0.4)
        case .secondary:
            return FireColors.accentGold.opacity(0.2)
        }
    }
    
    private var shadowRadius: CGFloat {
        switch style {
        case .primary:
            return 4
        case .secondary:
            return 2
        case .round:
            return 6
        }
    }
    
    private var shadowOffset: CGFloat {
        return isPressed ? 2 : 4
    }
}

struct FireButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FireButton("CONTINUE", style: .primary) { }
            FireButton("SKIP", style: .secondary) { }
            FireButton("+", style: .round, icon: "plus") { }
        }
        .fireScreenPadding()
        .background(FireColors.backgroundGradient)
        .previewLayout(.sizeThatFits)
    }
}