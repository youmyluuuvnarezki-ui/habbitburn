import SwiftUI


struct FireGlowModifier: ViewModifier {
    @State private var isGlowing = false
    let intensity: Double
    
    init(intensity: Double = 1.0) {
        self.intensity = intensity
    }
    
    func body(content: Content) -> some View {
        content
            .shadow(
                color: FireColors.primaryLight.opacity(isGlowing ? 0.6 * intensity : 0.4 * intensity),
                radius: isGlowing ? 15 * intensity : 8 * intensity,
                x: 0,
                y: 0
            )
            .shadow(
                color: FireColors.error.opacity(isGlowing ? 0.4 * intensity : 0.2 * intensity),
                radius: isGlowing ? 25 * intensity : 15 * intensity,
                x: 0,
                y: 0
            )
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isGlowing.toggle()
                }
            }
    }
}

struct PulseAnimationModifier: ViewModifier {
    @State private var isPulsing = false
    let intensity: Double
    let duration: Double
    
    init(intensity: Double = 0.05, duration: Double = 1.5) {
        self.intensity = intensity
        self.duration = duration
    }
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPulsing ? 1.0 + intensity : 1.0)
            .opacity(isPulsing ? 0.8 : 1.0)
            .onAppear {
                withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                    isPulsing.toggle()
                }
            }
    }
}

struct SlideUpModifier: ViewModifier {
    @State private var hasAppeared = false
    let delay: Double
    
    init(delay: Double = 0.0) {
        self.delay = delay
    }
    
    func body(content: Content) -> some View {
        content
            .offset(y: hasAppeared ? 0 : 100)
            .opacity(hasAppeared ? 1 : 0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4).delay(delay)) {
                    hasAppeared = true
                }
            }
    }
}

struct FlameIconModifier: ViewModifier {
    @State private var isFlaming = false
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(isFlaming ? FireColors.accentGold : FireColors.primaryLight)
            .scaleEffect(isFlaming ? 1.2 : 1.0)
            .shadow(
                color: isFlaming ? FireColors.accentGold.opacity(0.8) : FireColors.primaryLight.opacity(0.6),
                radius: isFlaming ? 8 : 4,
                x: 0,
                y: 0
            )
            .animation(.easeInOut(duration: 0.3), value: isFlaming)
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    isFlaming.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    withAnimation(.easeOut(duration: 0.2)) {
                        isFlaming = false
                    }
                }
            }
    }
}


struct FireParticles: View {
    @State private var particles: [FireParticle] = []
    @State private var timer: Timer?
    
    let particleCount: Int
    
    init(particleCount: Int = 20) {
        self.particleCount = particleCount
    }
    
    var body: some View {
        ZStack {
            ForEach(particles.indices, id: \.self) { index in
                Circle()
                    .fill(particles[index].color)
                    .frame(width: particles[index].size, height: particles[index].size)
                    .position(particles[index].position)
                    .opacity(particles[index].opacity)
                    .blur(radius: particles[index].blur)
            }
        }
        .onAppear {
            startParticleSystem()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }
    
    private func startParticleSystem() {
        particles = (0..<particleCount).map { _ in
            FireParticle()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            updateParticles()
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].update()
            
            if particles[i].shouldReset {
                particles[i] = FireParticle()
            }
        }
    }
}

struct FireParticle {
    var position: CGPoint
    var velocity: CGPoint
    var size: CGFloat
    var opacity: Double
    var blur: CGFloat
    var color: Color
    var life: Double
    var shouldReset: Bool = false
    
    init() {
        self.position = CGPoint(
            x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
            y: UIScreen.main.bounds.height + 20
        )
        self.velocity = CGPoint(
            x: CGFloat.random(in: -2...2),
            y: CGFloat.random(in: -8...(-3))
        )
        self.size = CGFloat.random(in: 2...6)
        self.opacity = 1.0
        self.blur = 0
        self.color = [FireColors.primaryLight, FireColors.accentGold, FireColors.warning].randomElement()!
        self.life = 1.0
    }
    
    mutating func update() {
        position.x += velocity.x
        position.y += velocity.y
        
        life -= 0.02
        opacity = life
        blur = (1.0 - life) * 2
        
        if life <= 0 || position.y < -20 {
            shouldReset = true
        }
    }
}


extension View {
    func fireGlow(intensity: Double = 1.0) -> some View {
        self.modifier(FireGlowModifier(intensity: intensity))
    }
    
    func pulseAnimation(intensity: Double = 0.05, duration: Double = 1.5) -> some View {
        self.modifier(PulseAnimationModifier(intensity: intensity, duration: duration))
    }
    
    func slideUpEnter(delay: Double = 0.0) -> some View {
        self.modifier(SlideUpModifier(delay: delay))
    }
    
    func flameIcon() -> some View {
        self.modifier(FlameIconModifier())
    }
}


struct FireAnimations_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 30) {
            
            FireCard {
                Text("Fire Glow Card")
                    .fireHeadingStyle()
            }
            .fireGlow()
            
            
            Image(systemName: "flame.fill")
                .font(.system(size: 40))
                .foregroundColor(FireColors.primaryLight)
                .pulseAnimation()
            
            
            Image(systemName: "flame.fill")
                .font(.system(size: 50))
                .flameIcon()
            
            Text("Slide Up Text")
                .fireHeadingStyle()
                .slideUpEnter(delay: 0.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(FireColors.backgroundGradient)
        .overlay(
            FireParticles(particleCount: 10)
                .allowsHitTesting(false)
        )
    }
}