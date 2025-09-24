import SwiftUI

struct BackgroundImageView: View {
    let name: String
    
    init(_ name: String) {
        self.name = name
    }
    
    var body: some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea(.all)
    }
}


