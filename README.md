# **Toastify Documentation**

## **Overview**

**Toastify** is a lightweight SwiftUI framework designed to display customizable toast messages across the app. It supports persistent toasts that stay visible even when navigating between screens. This framework makes it easy to add non-intrusive, brief notifications that enhance user interaction without disrupting the app's flow.

---

## **Installation**

### 1. **Using Swift Package Manager**
You can add **Toastify** to your project by using Swift Package Manager:

1. Open your Xcode project.
2. Go to `File > Swift Packages > Add Package Dependency`.
3. Enter the repository URL for **Toastify** (e.g., `https://github.com/vasantp20/Toastify.git`).
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
Toastify now supports customizable toast views, allowing developers to pass in their own SwiftUI views for toast messages. This new functionality provides more flexibility for designing toast messages, making it easier to adapt Toastify for different use cases.

---

## **New `showToast` Method**

### **Purpose**
The new `showToast` method allows you to display a custom view that conforms to the `ToastViewProtocol`. This gives you full control over the design and behavior of the toast while using the Toastify framework to manage the display and dismissal.

---

## **Method Signature**

```swift
public func showToast<V: ToastViewProtocol>(
    toastView: V,
    duration: TimeInterval = 2.0
)
```

### **Parameters**
- `toastView`: A SwiftUI view conforming to the `ToastViewProtocol` that will be displayed as the toast message.
- `duration`: The time (in seconds) for which the toast will be visible. Defaults to `2.0` seconds.

### **Usage Example**

```swift
struct CustomToastView: ToastViewProtocol {
    var message: String
    
    var body: some View {
        Text(message)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .shadow(radius: 10)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Show Custom Toast") {
                let customToast = CustomToastView(message: "This is a custom toast!")
                ToastManager.shared.showToast(toastView: customToast, duration: 3.0)
            }
        }
    }
}
```

---

## **Creating Custom Toast Views**

### **Conforming to `ToastViewProtocol`**
To create a custom toast view, your view must conform to the `ToastViewProtocol`, which is essentially a protocol for SwiftUI views.

Example:

```swift
struct CustomToastView: ToastViewProtocol {
    var message: String

    var body: some View {
        Text(message)
            .font(.headline)
            .padding()
            .background(Color.red.opacity(0.8))
            .cornerRadius(12)
            .shadow(radius: 10)
    }
}
```

In this example:
- `CustomToastView` defines a toast with a red background and rounded corners.
- You can customize this view further by adding images, icons, or other UI elements as needed.

---

## **How It Works**

The `showToast(toastView:)` method does the following:
1. **Adds a custom SwiftUI view** to the app’s root window, ensuring it stays visible even during navigation.
2. **Handles animations** for showing and dismissing the toast.
3. **Supports time-based dismissal**, automatically removing the toast after the specified duration.

---

## **Additional Notes**
- The custom toast view will always appear on top of the app's content, even during navigation.
- The animation ensures a smooth fade-in and fade-out effect, providing an intuitive user experience.

---

## **Conclusion**

This new `showToast` method provides the flexibility to create a wide range of toast messages using your custom views. By conforming to the `ToastViewProtocol`, you can now fully customize the UI, making **Toastify** adaptable to your app’s specific needs while still benefiting from Toastify's simplified toast management.


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
