import SwiftUI

struct FireFonts {
    
    
    static func display(_ size: CGFloat = 32) -> Font {
        return Font.custom("SF Pro Display", size: size).weight(.black)
    }
    
    
    static func heading(_ size: CGFloat = 24) -> Font {
        return Font.custom("SF Pro Display", size: size).weight(.bold)
    }
    
    
    static func body(_ size: CGFloat = 16) -> Font {
        return Font.custom("SF Pro Text", size: size).weight(.regular)
    }
    
    
    static func bodyBold(_ size: CGFloat = 16) -> Font {
        return Font.custom("SF Pro Text", size: size).weight(.semibold)
    }
    
    
    static func caption(_ size: CGFloat = 12) -> Font {
        return Font.custom("SF Pro Text", size: size).weight(.medium)
    }
    
    
    static func button(_ size: CGFloat = 16) -> Font {
        return Font.custom("SF Pro Display", size: size).weight(.bold)
    }
}


extension Text {
    func fireDisplayStyle() -> some View {
        self
            .font(FireFonts.display())
            .foregroundColor(FireColors.accentText)
            .shadow(color: .black.opacity(0.8), radius: 3, x: 0, y: 3)
            .textCase(.uppercase)
    }
    
    func fireHeadingStyle() -> some View {
        self
            .font(FireFonts.heading())
            .foregroundColor(FireColors.primaryText)
            .shadow(color: .black.opacity(0.6), radius: 2, x: 0, y: 2)
    }
    
    func fireBodyStyle() -> some View {
        self
            .font(FireFonts.body())
            .foregroundColor(FireColors.primaryText)
    }
    
    func fireCaptionStyle() -> some View {
        self
            .font(FireFonts.caption())
            .foregroundColor(FireColors.secondaryText)
            .textCase(.uppercase)
    }
}