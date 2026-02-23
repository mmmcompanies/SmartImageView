> Created By - **Madan Kumawat**  
> 🔗 [LinkedIn](https://in.linkedin.com/in/madankumawat) | 🗣️ [Topmate](https://topmate.io/madank)

# SmartImageView

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
[![Platforms](https://img.shields.io/badge/Platforms-iOS_16.0+-blue?style=flat-square)](https://img.shields.io/badge/Platforms-iOS_16.0+-blue?style=flat-square)
[![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat-square)](https://img.shields.io/badge/Swift-5.9+-orange.svg?style=flat-square)

`SmartImageView` is a modern, robust, and highly optimized Swift Package that brings seamless pinch-to-zoom capabilities to your iOS applications, directly mimicking the immersive, bounce-back behavior seen in native iOS Photos or social media apps.

Born as a modern successor and significant improvement over libraries like `EEZoomableImageView`, `SmartImageView` brings **first-class SwiftUI support**, eliminates annoying edge-case crashes (like NaNs), and strictly utilizes the latest declarative paradigms for SwiftUI while maintaining top-tier `UIKit` compatibility.

## 🌟 Features

- **Seamless Pinch-to-Zoom**: Zooms beautifully above all other views by dynamically utilizing the `UIWindow`.
- **Spring-back Animation**: Releasing the gesture elegantly snaps the image back to its original position using physics-based spring animations.
- **SwiftUI Support**: Includes a simple, intuitive declarative wrapper (`SmartZoomableImage`) for iOS 16+.
- **Highly Configurable**: Easily tweak `minZoomScale`, `maxZoomScale`, and reset animations.
- **Robustness**: Extensively guarded against common gesture recognizer pitfalls (infinite scales, NaN values, simultaneous touches).

---

## 📦 Installation

### Swift Package Manager (SPM)

`SmartImageView` is exclusively available through Swift Package Manager for maximum integration simplicity.

1. Open your project in Xcode.
2. Go to **File > Add Package Dependencies...**
3. Paste the repository URL: `https://github.com/your-username/SmartImageView.git` (replace with actual URL when deployed).
4. Select the version or branch you wish to use.
5. Add it to your target.

---

## 💻 Usage

### SwiftUI

The package provides a `SmartZoomableImage` component that behaves identically to standard SwiftUI image views but includes magic zooming capabilities.

```swift
import SwiftUI
import SmartImageView

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Try pinching the image below!")
                .font(.headline)
            
            SmartZoomableImage(
                image: UIImage(named: "example")!,
                contentMode: .scaleAspectFill,
                minZoomScale: 1.0,
                maxZoomScale: 4.0
            )
            .frame(width: 300, height: 300)
            .cornerRadius(12)
        }
    }
}
```

### UIKit

If your app is built using UIKit, you can use `SmartImageView` straight away as a drop-in replacement for `UIImageView`.

```swift
import UIKit
import SmartImageView

class ViewController: UIViewController, SmartImageViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Initialize
        let zoomableView = SmartImageView(image: UIImage(named: "example"))
        zoomableView.frame = CGRect(x: 50, y: 100, width: 250, height: 250)
        zoomableView.contentMode = .scaleAspectFill
        zoomableView.clipsToBounds = true
        
        // 2. Configure (Optional)
        zoomableView.minZoomScale = 1.0
        zoomableView.maxZoomScale = 3.5
        zoomableView.resetAnimationDuration = 0.4
        zoomableView.zoomDelegate = self
        
        view.addSubview(zoomableView)
    }
    
    // MARK: - SmartImageViewDelegate
    
    func smartImageViewDidBeginZooming(_ imageView: SmartImageView) {
        print("Zoom started!")
    }
    
    func smartImageViewDidEndZooming(_ imageView: SmartImageView) {
        print("Zoom ended, image snapped back.")
    }
}
```

---

## 🛠 Requirements

- **iOS 16.0** or later.
- **Swift 5.9** or later.
- **Xcode 15.0** or later.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page. 

## 📝 License

Distributed under the MIT License. See `LICENSE` for more information.
