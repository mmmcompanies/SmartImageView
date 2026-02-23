// Created By - Madan Kumawat 
// linkedin Profile - https://in.linkedin.com/in/madankumawat
// Topmate - https://topmate.io/madank

import SwiftUI

/// A SwiftUI wrapper for `SmartImageView`.
/// Bridges the UIKit view into the declarative SwiftUI paradigm.
public struct SmartZoomableImage: UIViewRepresentable {
    
    private let image: UIImage
    private let contentMode: UIView.ContentMode
    private let minZoomScale: CGFloat
    private let maxZoomScale: CGFloat
    
    /// Initializes a `SmartZoomableImage` with the given `UIImage` and parameters.
    public init(
        image: UIImage,
        contentMode: UIView.ContentMode = .scaleAspectFit,
        minZoomScale: CGFloat = 1.0,
        maxZoomScale: CGFloat = 3.0
    ) {
        self.image = image
        self.contentMode = contentMode
        self.minZoomScale = minZoomScale
        self.maxZoomScale = maxZoomScale
    }
    
    public func makeUIView(context: Context) -> SmartImageView {
        let imageView = SmartImageView(image: image)
        imageView.contentMode = contentMode
        imageView.minZoomScale = minZoomScale
        imageView.maxZoomScale = maxZoomScale
        imageView.clipsToBounds = true
        return imageView
    }
    
    public func updateUIView(_ uiView: SmartImageView, context: Context) {
        uiView.image = image
        uiView.contentMode = contentMode
        uiView.minZoomScale = minZoomScale
        uiView.maxZoomScale = maxZoomScale
    }
}
