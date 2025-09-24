import SwiftUI

struct FireColors {
    
    
    static let primaryDark = Color(red: 139/255, green: 0/255, blue: 0/255)      
    static let primaryMedium = Color(red: 178/255, green: 34/255, blue: 34/255)   
    static let primaryLight = Color(red: 255/255, green: 69/255, blue: 0/255)     
    static let accentGold = Color(red: 218/255, green: 165/255, blue: 32/255)     
    static let pureBlack = Color.black                                            
    
    
    static let success = Color(red: 0/255, green: 200/255, blue: 81/255)          
    static let warning = Color(red: 255/255, green: 140/255, blue: 0/255)         
    static let error = Color.red                                                  
    static let info = Color(red: 0/255, green: 102/255, blue: 255/255)           
    
    
    static let primaryText = Color.white                                          
    static let secondaryText = Color.white.opacity(0.7)                          
    static let accentText = Color(red: 255/255, green: 215/255, blue: 0/255)     
    static let inverseText = Color.black                                         
    
    
    static let fireGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: primaryDark, location: 0.0),
            .init(color: primaryMedium, location: 0.25),
            .init(color: primaryLight, location: 0.75),
            .init(color: accentGold, location: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let buttonGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: accentGold, location: 0.0),
            .init(color: warning, location: 0.5),
            .init(color: primaryLight, location: 1.0)
        ]),
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    static let backgroundGradient = LinearGradient(
        gradient: Gradient(stops: [
            .init(color: Color(red: 74/255, green: 0/255, blue: 0/255), location: 0.0),  
            .init(color: primaryDark, location: 1.0)
        ]),
        startPoint: .top,
        endPoint: .bottom
    )
}