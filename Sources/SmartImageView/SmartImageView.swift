// Created By - Madan Kumawat 
// linkedin Profile - https://in.linkedin.com/in/madankumawat
// Topmate - https://topmate.io/madank

import UIKit

/// A protocol that allows a delegate to respond to zooming events in `SmartImageView`.
public protocol SmartImageViewDelegate: AnyObject {
    /// Called when the pinch-to-zoom gesture begins.
    func smartImageViewDidBeginZooming(_ imageView: SmartImageView)
    
    /// Called when the pinch-to-zoom gesture ends and the view returns to its original state.
    func smartImageViewDidEndZooming(_ imageView: SmartImageView)
}

/// A modern, robust `UIImageView` subclass that supports pinch-to-zoom functionality.
/// The image zooms dynamically above other views, mimicking built-in iOS behaviors in Photos or social media apps.
open class SmartImageView: UIImageView {
    
    private var zoomHandler: PinchZoomHandler?
    
    /// The delegate to receive zoom-related events.
    public weak var zoomDelegate: SmartImageViewDelegate? {
        get { return zoomHandler?.delegate }
        set { zoomHandler?.delegate = newValue }
    }
    
    /// The minimum scale factor allowed for zooming. Must be greater than 0. Defaults to 1.0.
    public var minZoomScale: CGFloat {
        get { return zoomHandler?.minZoomScale ?? 1.0 }
        set { zoomHandler?.minZoomScale = max(0.1, newValue) }
    }
    
    /// The maximum scale factor allowed for zooming. Defaults to 3.0.
    public var maxZoomScale: CGFloat {
        get { return zoomHandler?.maxZoomScale ?? 3.0 }
        set { zoomHandler?.maxZoomScale = max(1.0, newValue) }
    }
    
    /// The duration of the reset animation when zooming finishes. Defaults to 0.3 seconds.
    public var resetAnimationDuration: TimeInterval {
        get { return zoomHandler?.resetAnimationDuration ?? 0.3 }
        set { zoomHandler?.resetAnimationDuration = max(0.0, newValue) }
    }
    
    /// Indicates whether the image view is currently being zoomed.
    public var isZoomingActive: Bool {
        return zoomHandler?.isZoomingActive ?? false
    }
    
    // MARK: - Initializations
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupZoomHandler()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image: image, highlightedImage: highlightedImage)
        setupZoomHandler()
    }
    
    public override init(image: UIImage?) {
        super.init(image: image)
        setupZoomHandler()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupZoomHandler()
    }
    
    private func setupZoomHandler() {
        self.isUserInteractionEnabled = true
        zoomHandler = PinchZoomHandler(sourceImageView: self)
    }
}

// MARK: - Private Handler

/// A private helper class that encapsulates the pinch-to-zoom logic for a given image view.
private final class PinchZoomHandler {
    
    // Configurable properties
    var minZoomScale: CGFloat = 1.0
    var maxZoomScale: CGFloat = 3.0
    var resetAnimationDuration: TimeInterval = 0.3
    private(set) var isZoomingActive: Bool = false
    
    weak var delegate: SmartImageViewDelegate?
    weak var sourceImageView: SmartImageView?
    
    // State variables
    private var activeZoomView: UIImageView?
    private var initialRect: CGRect = .zero
    private var zoomImageLastPosition: CGPoint = .zero
    private var lastTouchPoint: CGPoint = .zero
    private var lastNumberOfTouches: Int = 0
    
    /// Initializes the handler with a source image view.
    init(sourceImageView: SmartImageView) {
        self.sourceImageView = sourceImageView
        setupPinchGesture(on: sourceImageView)
    }
    
    private func setupPinchGesture(on view: UIView) {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch(_:)))
        pinchGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        guard let sourceView = sourceImageView, let window = sourceView.window else { return }
        
        switch gesture.state {
        case .began:
            // Ensure not already zooming and the gesture is actually zooming in.
            guard !isZoomingActive, gesture.scale >= minZoomScale else { return }
            
            // Get the view's absolute frame in window coordinates.
            guard let convertedPoint = sourceView.superview?.convert(sourceView.frame.origin, to: window) else { return }
            initialRect = CGRect(origin: convertedPoint, size: sourceView.bounds.size)
            
            lastTouchPoint = gesture.location(in: sourceView)
            
            // Create a temporary view to handle the zoom visual.
            let zoomView = UIImageView(image: sourceView.image)
            zoomView.contentMode = sourceView.contentMode
            zoomView.clipsToBounds = sourceView.clipsToBounds
            zoomView.frame = initialRect
            
            // Adjust anchor point so zooming pivots around the touch location.
            let anchorX = lastTouchPoint.x / max(initialRect.width, 1)
            let anchorY = lastTouchPoint.y / max(initialRect.height, 1)
            zoomView.layer.anchorPoint = CGPoint(x: anchorX, y: anchorY)
            
            // Setting anchor point alters geometry, adjust center and frame to keep it visually stable.
            zoomView.center = window.convert(lastTouchPoint, from: sourceView)
            zoomView.frame = initialRect
            
            // Hide the original view while zooming.
            sourceView.alpha = 0.0
            window.addSubview(zoomView)
            
            self.activeZoomView = zoomView
            self.zoomImageLastPosition = zoomView.center
            self.isZoomingActive = true
            self.lastNumberOfTouches = gesture.numberOfTouches
            
            delegate?.smartImageViewDidBeginZooming(sourceView)
            
        case .changed:
            guard let zoomView = activeZoomView else { return }
            
            // If the number of fingers changes (e.g. lift one finger), update the touch point natively to avoid jumps
            let isNumberOfTouchesChanged = gesture.numberOfTouches != lastNumberOfTouches
            if isNumberOfTouchesChanged {
                lastTouchPoint = gesture.location(in: sourceView)
            }
            
            // Calculate scale
            let currentScale = zoomView.bounds.width == 0 ? 1.0 : zoomView.frame.size.width / initialRect.size.width
            let newScale = currentScale * gesture.scale
            
            // Protect against NaN crashes
            if currentScale.isNaN || currentScale.isInfinite || newScale.isNaN || newScale.isInfinite {
                return
            }
            
            // Constrain scaling limits
            let boundedScale = min(max(newScale, minZoomScale), maxZoomScale)
            
            zoomView.frame = CGRect(
                x: zoomView.frame.origin.x,
                y: zoomView.frame.origin.y,
                width: initialRect.size.width * boundedScale,
                height: initialRect.size.height * boundedScale
            )
            
            // Handle panning combined with zooming
            let currentTouchLocation = gesture.location(in: sourceView)
            let centerXDif = lastTouchPoint.x - currentTouchLocation.x
            let centerYDif = lastTouchPoint.y - currentTouchLocation.y
            
            zoomView.center = CGPoint(x: zoomImageLastPosition.x - centerXDif, y: zoomImageLastPosition.y - centerYDif)
            gesture.scale = 1.0
            
            // Update last state values
            lastNumberOfTouches = gesture.numberOfTouches
            zoomImageLastPosition = zoomView.center
            lastTouchPoint = currentTouchLocation
            
        case .ended, .cancelled, .failed:
            resetZoom()
            
        default:
            break
        }
    }
    
    private func resetZoom() {
        guard let zoomView = activeZoomView, let sourceView = sourceImageView else { return }
        
        // Disable interaction during reset
        sourceView.isUserInteractionEnabled = false
        
        UIView.animate(withDuration: resetAnimationDuration,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.5,
                       options: [.curveEaseOut],
                       animations: {
            zoomView.frame = self.initialRect
        }, completion: { _ in
            zoomView.removeFromSuperview()
            sourceView.alpha = 1.0
            sourceView.isUserInteractionEnabled = true
            
            self.activeZoomView = nil
            self.initialRect = .zero
            self.lastTouchPoint = .zero
            self.isZoomingActive = false
            
            self.delegate?.smartImageViewDidEndZooming(sourceView)
        })
    }
}
