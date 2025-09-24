import SwiftUI



extension View {
    func staticFireGlow(intensity: Double = 1.0) -> some View {
        self
            .shadow(
                color: FireColors.primaryLight.opacity(0.4 * intensity),
                radius: 8 * intensity,
                x: 0,
                y: 0
            )
            .shadow(
                color: FireColors.error.opacity(0.2 * intensity),
                radius: 15 * intensity,
                x: 0,
                y: 0
            )
    }
}