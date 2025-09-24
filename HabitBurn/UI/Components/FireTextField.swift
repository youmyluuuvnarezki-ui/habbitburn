import SwiftUI

struct FireTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let isSecure: Bool
    
    @FocusState private var isFocused: Bool
    
    init(_ title: String, text: Binding<String>, placeholder: String = "", isSecure: Bool = false) {
        self.title = title
        self._text = text
        self.placeholder = placeholder
        self.isSecure = isSecure
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: FireSpacing.xs) {
            if !title.isEmpty {
                Text(title)
                    .fireCaptionStyle()
            }
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(FireFonts.body())
            .foregroundColor(FireColors.primaryText)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .frame(minHeight: FireSpacing.minTouchTarget)
            .background(fieldBackground)
            .overlay(fieldBorder)
            .clipShape(RoundedRectangle(cornerRadius: FireSpacing.buttonRadius))
            .focused($isFocused)
        }
    }
    
    private var fieldBackground: some View {
        Color.black.opacity(0.5)
    }
    
    private var fieldBorder: some View {
        RoundedRectangle(cornerRadius: FireSpacing.buttonRadius)
            .stroke(
                isFocused ? FireColors.accentGold : FireColors.accentGold.opacity(0.3),
                lineWidth: isFocused ? 2 : 1
            )
            .shadow(
                color: isFocused ? FireColors.accentGold.opacity(0.2) : .clear,
                radius: isFocused ? 3 : 0,
                x: 0,
                y: 0
            )
    }
}

struct FireTextField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            FireTextField("Habit Name", text: .constant(""), placeholder: "Enter habit name")
            FireTextField("Your Name", text: .constant("John"), placeholder: "Enter your name")
            FireTextField("Password", text: .constant(""), placeholder: "Enter password", isSecure: true)
        }
        .fireScreenPadding()
        .background(FireColors.backgroundGradient)
        .previewLayout(.sizeThatFits)
    }
}