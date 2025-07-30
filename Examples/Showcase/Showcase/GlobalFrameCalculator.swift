import SwiftUI
import SwiftUIIntrospect

struct UIKitView: UIViewRepresentable {

	func makeUIView(context: Context) -> UIView {
		let view = UIView()
		view.backgroundColor = .red

		// allow it to expand
		view.translatesAutoresizingMaskIntoConstraints = false
		let widthConstraint = view.widthAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
		widthConstraint.priority = .defaultLow
		widthConstraint.isActive = true

		let heightConstraint = view.heightAnchor.constraint(greaterThanOrEqualToConstant: .greatestFiniteMagnitude)
		heightConstraint.priority = .defaultLow
		heightConstraint.isActive = true

		return view
	}

	func updateUIView(_ uiView: UIView, context: Context) {
		// No updates needed for this example
	}
}

struct GlobalFrameCalculator: ViewModifier {

	@Binding var frame: CGRect?
	var callback: ((CGRect?) -> Void)?

	func body(content: Content) -> some View {
		content
			#if os(iOS)
			.introspect(.view, on: .iOS(.v15, .v16, .v17, .v18)) { view in
				if #available(iOS 17, *) {
					guard let window = view.window else {
						print("Window is nil, cannot calculate global frame.")
						return
					}
					let globalFrame = view.frame(in: window)
					frame = globalFrame
					callback?(globalFrame)
				}
			}
			#endif
	}
}
