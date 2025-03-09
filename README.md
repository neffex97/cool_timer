# Create the README.md file content

A customizable, animated countdown timer for Flutter, inspired by Airbnb’s home page countdown timer for discount house rentals.

---

## 🎯 Features

- ✅ Fully customizable countdown timer
- ✅ Multiple animation effects (**Scale, Fade, Slide, Rotate**)
- ✅ Option to **show/hide hours, minutes, and seconds**
- ✅ Customizable **text style, background color, and blur effect**
- ✅ `onTick` callback for **real-time countdown updates**
- ✅ Supports **countdown** and **count-up** modes
- ✅ Smooth **digit transition animations**
- ✅ Lightweight and **easy to integrate**

---

## 📦 Installation

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
  cool_timer: latest_version
```

Then, run:

```sh
flutter pub get
```

---

## 🚀 Usage

### **Basic Countdown Timer**

```dart
import 'package:cool_timer/cool_timer.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: ClockWidget(
            duration: Duration(hours: 2, minutes: 30, seconds: 45),
            selectedAnimation: AnimationType.fade,
            onEnd: () => print("Time's up!"),
          ),
        ),
      ),
    );
  }
}
```

---

## 🎨 Customization Options

### **1️⃣ Control Visibility of Time Units**

```dart
ClockWidget(
  duration: Duration(minutes: 10),
  showHours: false,  // Hide hours if not needed
  showSeconds: false, // Hide seconds if not needed
  onEnd: () => print("Timer finished!"),
)
```

### **2️⃣ Customize Text Style & Colors**

```dart
ClockWidget(
  textStyle: TextStyle(fontSize: 40, color: Colors.red),
  backgroundColor: Colors.black,
  dividerColor: Colors.orange,
)
```

### **3️⃣ Blur Effect for Background**

```dart
ClockWidget(
  isBlur: true,
  blurStrength: 15.0,  // Adjust blur intensity
)
```

### **4️⃣ Animated Digit Transitions**

```dart
ClockWidget(
  selectedAnimation: AnimationType.slide,  // Options: fade, scale, slide, rotate
  digitAnimationDuration: Duration(milliseconds: 300),
)
```

### **5️⃣ Count Up Timer (Instead of Countdown)**

```dart
ClockWidget(
  isReversed: true,  // Starts from 00:00 and counts up
)
```

### **6️⃣ Real-Time Updates with `onTick`**

```dart
ClockWidget(
  duration: Duration(minutes: 5),
  onTick: (remainingTime) {
    print('Remaining time: $remainingTime');
  },
)
```

## 📢 Contributions Welcome!

🎉 **We'd love your feedback and contributions!**  
If you have ideas, improvements, or bug fixes, feel free to open a **pull request** or an **issue**. Your contributions make this package better for everyone.

If you like this package, **please star ⭐ the repo** and share your feedback!

---

### 🙌 Thanks for checking out Cool Timer!

If you find this package useful, consider supporting us with a **GitHub star ⭐** or contributing via PRs! 🚀😊
