import SwiftUI

struct Rainbow: ViewModifier {
	public static let hueColors = stride(from: 0, to: 1, by: 0.1).map {
		Color(hue: $0, saturation: 1, brightness: 1)
	}

	func body(content: Content) -> some View {
		content
			.overlay(GeometryReader { (proxy: GeometryProxy) in
				ZStack {
					LinearGradient(gradient: Gradient(colors: Rainbow.hueColors),
					               startPoint: .leading,
					               endPoint: .trailing)
						.frame(width: proxy.size.width, height: proxy.size.height)
				}
			})
			.mask(content)
	}
}

extension View {
	func rainbow() -> some View {
		modifier(Rainbow())
	}
}

struct RainbowAnimation: ViewModifier {
	// 1
	@State var isOn: Bool = false
	let hueColors = stride(from: 0, to: 1, by: 0.01).map {
		Color(hue: $0, saturation: 1, brightness: 1)
	}

	// 2
	var duration: Double = 4
	var animation: Animation {
		Animation
			.linear(duration: duration)
			.repeatForever(autoreverses: false)
	}

	func body(content: Content) -> some View {
		// 3
		let gradient = LinearGradient(gradient: Gradient(colors: hueColors + hueColors), startPoint: .leading, endPoint: .trailing)
		return content.overlay(GeometryReader { proxy in
			ZStack {
				gradient
					// 4
					.frame(width: 2 * proxy.size.width)
					// 5
					.offset(x: self.isOn ? -proxy.size.width/2 : proxy.size.width/2)
			}
		})
			// 6
			.onAppear {
				withAnimation(self.animation) {
					self.isOn = true
				}
			}
			.mask(content)
	}
}

extension View {
	func rainbowAnimation() -> some View {
		modifier(RainbowAnimation())
	}
}
