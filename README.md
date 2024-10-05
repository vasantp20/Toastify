# Toastify

# **Toastify Documentation**

## **Overview**

**Toastify** is a lightweight SwiftUI framework designed to display customizable toast messages across the app. It supports persistent toasts that stay visible even when navigating between screens. This framework makes it easy to add non-intrusive, brief notifications that enhance user interaction without disrupting the app's flow.

---

## **Installation**

### 1. **Using Swift Package Manager**
You can add **Toastify** to your project by using Swift Package Manager:

1. Open your Xcode project.
2. Go to `File > Swift Packages > Add Package Dependency`.
3. Enter the repository URL for **Toastify** (e.g., `https://github.com/YourUserName/Toastify.git`).
4. Follow the prompts to add the package.

### 2. **Manual Installation**
To manually add **Toastify** to your project:
1. Clone the repository.
2. Drag the `Toastify` folder into your Xcode project.
3. Ensure that `Toastify` is listed under the `Link Binary with Libraries` section in your target's settings.

---

## **Usage**

### **Basic Toast**

You can display a simple toast message with the `showToast` function:

```swift
import Toastify

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Toast") {
                ToastManager.shared.showToast(message: "Hello, World!")
            }
        }
    }
}
```

### **Customizing the Toast**

You can also customize the appearance of the toast by passing additional parameters such as background color, text color, and font:

```swift
ToastManager.shared.showToast(
    message: "Custom Toast",
    backgroundColor: .blue,
    textColor: .white,
    duration: 3.0,
    font: .headline
)
```

#### Parameters:
- `message`: The message text displayed in the toast.
- `backgroundColor`: The background color of the toast (default is `.black.opacity(0.8)`).
- `textColor`: The color of the message text (default is `.white`).
- `duration`: How long the toast will be visible (default is 2 seconds).
- `font`: The font used for the message (default is `.body`).

---

## **Toast Behavior**

### **Persistent Toasts**
Toastify displays toasts globally by attaching them to the root window of the app, ensuring they remain visible across different view controllers or navigation transitions.

### **Manually Dismissing a Toast**
You can allow users to manually dismiss the toast by tapping on it. The `onTapGesture` can be added within the `ToastView`:

```swift
ToastManager.shared.showToast(message: "Tap to dismiss!") {
    print("Toast dismissed!")
}
```

### **Example with Navigation**

Even during navigation, toasts persist at the window level. You can display a toast before navigating to a new screen, and the message will remain visible:

```swift
Button("Navigate and Toast") {
    ToastManager.shared.showToast(message: "Navigating!")
    // Navigate to the next view
    let nextVC = UIHostingController(rootView: NextView())
    UIApplication.shared.windows.first?.rootViewController?.present(nextVC, animated: true)
}
```

---

## **Customization**

### **ToastView**

To create your own toast view, you can customize the `ToastView` provided in the framework:

```swift
import SwiftUI

public struct ToastView: View {
    public var message: String
    public var backgroundColor: Color
    public var textColor: Color
    public var cornerRadius: CGFloat

    public init(message: String,
                backgroundColor: Color = .black.opacity(0.8),
                textColor: Color = .white,
                cornerRadius: CGFloat = 8.0) {
        self.message = message
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        Text(message)
            .foregroundColor(textColor)
            .padding()
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 40)
            .shadow(radius: 10)
    }
}
```

### **Appearance**

Toasts can have flexible appearances by modifying properties like corner radius, background color, and shadow. Here’s how you can adjust these properties:

```swift
ToastManager.shared.showToast(
    message: "Styled Toast",
    backgroundColor: .green,
    textColor: .black,
    cornerRadius: 12.0
)
```

---

## **Advanced**

### **Handling Orientation Changes**

To ensure the toast stays correctly positioned during orientation changes, **Toastify** listens for orientation change notifications and adjusts the constraints of the toast view dynamically:

```swift
NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)

@objc private func handleOrientationChange() {
    // Update toast constraints if needed
}
```

### **Persistence Across Transitions**

The framework attaches the toast at the root window level, which ensures that the toast remains visible during view transitions and modal presentations. This provides a persistent messaging system that isn’t tied to individual view controllers.

---

## **Contributing**

We welcome contributions to **Toastify**! Feel free to submit pull requests, report issues, or suggest new features. Before contributing, please review the [contribution guidelines](CONTRIBUTING.md).

---

## **License**

**Toastify** is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

By following these steps, you’ll be able to integrate **Toastify** into your project and customize it to meet your app’s notification needs.
