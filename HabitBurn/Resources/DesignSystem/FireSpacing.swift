import SwiftUI

struct FireSpacing {
    
    
    static let xs: CGFloat = 4      
    static let sm: CGFloat = 8      
    static let md: CGFloat = 16     
    static let lg: CGFloat = 24     
    static let xl: CGFloat = 32     
    static let xxl: CGFloat = 48    
    
    
    static let buttonPadding: EdgeInsets = EdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
    static let cardPadding: EdgeInsets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
    static let screenPadding: EdgeInsets = EdgeInsets(top: md, leading: md, bottom: md, trailing: md)
    
    
    static let cornerRadius: CGFloat = 12
    static let buttonRadius: CGFloat = 8
    static let cardRadius: CGFloat = 12
    
    
    static let minTouchTarget: CGFloat = 44
    static let fabSize: CGFloat = 60
}


extension View {
    func fireScreenPadding() -> some View {
        self.padding(FireSpacing.screenPadding)
    }
    
    func fireCardPadding() -> some View {
        self.padding(FireSpacing.cardPadding)
    }
    
    func fireButtonPadding() -> some View {
        self.padding(FireSpacing.buttonPadding)
    }
}