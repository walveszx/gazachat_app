
[![Stand With Palestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/banner-no-action.svg)](https://thebsd.github.io/StandWithPalestine)

<div align="center">
  <img src="assets/icons/logo_app_black.png" width="120" height="120" alt="Gazachat Logo" />

  
  **Gazachat Decentralized Bluetooth Communication**
  
  *Connect without internet, communicate without limits*

  [![Issues](https://img.shields.io/github/issues/Bloul-Mohamed/gazachat_app?style=for-the-badge&logo=github)](https://github.com/Bloul-Mohamed/gazachat_app/issues)
    [![Closed Issues](https://img.shields.io/github/issues-closed/Bloul-Mohamed/gazachat_app?style=for-the-badge&logo=github)](https://github.com/Bloul-Mohamed/gazachat_app/issues)

  [![Contributors](https://img.shields.io/github/contributors/Bloul-Mohamed/gazachat_app?style=for-the-badge&logo=github)](https://github.com/Bloul-Mohamed/gazachat_app/graphs/contributors)
  [![Forks](https://img.shields.io/github/forks/Bloul-Mohamed/gazachat_app?style=for-the-badge&logo=github)](https://github.com/Bloul-Mohamed/gazachat_app/network/members)
  [![Stars](https://img.shields.io/github/stars/Bloul-Mohamed/gazachat_app?style=for-the-badge&logo=github)](https://github.com/Bloul-Mohamed/gazachat_app/stargazers)
  
![GitHub License](https://img.shields.io/github/license/Bloul-Mohamed/gazachat_app)

</div>

<div align="center">
  
  [![Download from GitHub](https://img.shields.io/badge/Download-GitHub%20Releases-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Bloul-Mohamed/gazachat_app/releases)
  [![Download APK](https://img.shields.io/badge/Download-Firebase%20APK-FF6B35?style=for-the-badge&logo=firebase&logoColor=white)](https://appdistribution.firebase.dev/i/7c5bc8c5617e8400)
  
  <p><em>Get the latest version of Gazachat for your Android device</em></p>
  
</div>


---

## 🚀 What is Gazachat?

Gazachat is a revolutionary **Bluetooth-only communication app** that enables peer-to-peer messaging without requiring internet connectivity. Perfect for areas with limited connectivity, emergency situations, or when you simply want to communicate privately without relying on centralized servers.
> [!WARNING]
> Private messages have not received external security review and may contain vulnerabilities. Do not use for sensitive use cases, and do not rely on its security until it has been reviewed. Now not  uses any security protocol. 

> [!NOTE]
> Gazachat is designed to be a **decentralized** communication tool, meaning it does not rely on any central servers or cloud services. All messages are sent directly between devices using Bluetooth, ensuring your privacy and security.

> [!IMPORTANT]
> Gazachat is currently in **beta**. We are actively working on improving features, fixing bugs, and enhancing the user experience. Your feedback is invaluable!

### ✨ Key Features

- 🔐 **Privacy First** - No servers, no data collection, your messages stay between you and your contacts
- 📡 **Offline Communication** - Works entirely through Bluetooth, no internet required
- 🌍 **Mesh Networking** - Messages can hop through multiple devices to reach their destination
- 💬 **Real-time Messaging** - Instant communication within Bluetooth range
- 🔋 **Battery Optimized** - Efficient Bluetooth usage to preserve device battery
- 🎨 **Modern UI** - Clean, intuitive interface built with Flutter

## 📱 Screenshots

<div align="center">
  
  ### Main Interface & Chat Features
  <table>
    <tr>
      <td><img src="screenshots/flutter_01.png" width="180" alt="Main Interface"/></td>
      <td><img src="screenshots/flutter_11.png" width="180" alt="Chat Screen"/></td>
      <td><img src="screenshots/flutter_12.png" width="180" alt="Message List"/></td>
      <td><img src="screenshots/flutter_14.png" width="180" alt="Contact View"/></td>
      <td><img src="screenshots/flutter_17.png" width="180" alt="Profile Screen"/></td>
      <td><img src="screenshots/flutter_18.png" width="180" alt="Profile Screen"/></td>
    </tr>
  </table>

  ### Device Discovery & Connection
  <table>
    <tr>
      <td><img src="screenshots/flutter_09.png" width="180" alt="Device Discovery"/></td>
      <td><img src="screenshots/flutter_02.png" width="180" alt="Bluetooth Settings"/></td>
      <td><img src="screenshots/flutter_10.png" width="180" alt="Connection Status"/></td>
      <td><img src="screenshots/flutter_04.png" width="180" alt="Pairing Process"/></td>
      <td><img src="screenshots/flutter_03.png" width="180" alt="Connected Devices"/></td>
    </tr>
  </table>

  ### Settings & Configuration
  <table>
    <tr>
      <td><img src="screenshots/flutter_05.png" width="180" alt="App Settings"/></td>
      <td><img src="screenshots/flutter_06.png" width="180" alt="Privacy Settings"/></td>
      <td><img src="screenshots/flutter_07.png" width="180" alt="Notification Settings"/></td>
      <td><img src="screenshots/flutter_08.png" width="180" alt="Theme Options"/></td>
    </tr>
  </table>

  ### Additional Features
  <table>
    <tr>
      <td><img src="screenshots/flutter_15.png" width="180" alt="Help Screen"/></td>
      <td><img src="screenshots/flutter_20.png" width="180" alt="Help Screen"/></td>
    </tr>
  </table>

</div>

## 🛠️ Tech Stack

- **Framework**: Flutter
- **Language**: Dart
- **Connectivity**: Bluetooth Low Energy (BLE)
- **Architecture**: Clean Architecture with BLoC pattern
- **Platform**: Android (IOS support in progress)

## 🚀 Quick Start

### Prerequisites

- Flutter SDK (>=3.0.0)
- Android Studio / VS Code
- Android device with Bluetooth support
- iOS device (for iOS development)

### Installation

```bash
# Clone the repository
git clone https://github.com/Bloul-Mohamed/gazachat_app.git "gazachat"

# Navigate to project directory
cd gazachat

# Install dependencies
flutter pub get

# Run the app
flutter run --flavor development
```


## 🤝 Contributing

We welcome contributions from the community! Gazachat is an open-source project that thrives on collaboration.

### How to Contribute

1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Commit** your changes (`git commit -m 'Add amazing feature'`)
4. **Push** to the branch (`git push origin feature/amazing-feature`)
5. **Open** a Pull Request

### 🐛 Found a Bug?

If you find a bug, please [open an issue](https://github.com/Bloul-Mohamed/gazachat_app/issues/new) with:
- Clear description of the problem
- Steps to reproduce
- Expected vs actual behavior
- Screenshots (if applicable)

### 💡 Feature Requests

Have an idea? We'd love to hear it! [Open a feature request](https://github.com/Bloul-Mohamed/gazachat_app/issues/new) and let's discuss.

## 📋 Roadmap

- [ ] End-to-end encryption
- [ ] File sharing capabilities
- [ ] Group messaging
- [ ] Message persistence
- [ ] Cross-platform desktop support
- [ ] Voice messages
- [ ] Location sharing

## 🏆 Contributors

Thanks to all our amazing contributors who make Gazachat better every day!

### 🌟 All Contributors


### 📊 Contribution Stats

![Contributors](https://contributors-img.web.app/image?repo=Bloul-Mohamed/gazachat_app)

### 🚀 GitHub Contributors Graph

[![GitHub Contributors](https://img.shields.io/github/contributors/Bloul-Mohamed/gazachat_app?style=for-the-badge&logo=github)](https://github.com/Bloul-Mohamed/gazachat_app/graphs/contributors)

<div align="center">
  <em>Click on any contributor image above to see their GitHub profile!</em>
</div>

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Support the Project

If you find Gazachat useful, please consider:

- ⭐ **Starring** the repository
- 🐛 **Reporting** bugs and issues
- 💡 **Suggesting** new features
- 🤝 **Contributing** code
- 📢 **Sharing** with others

## 📞 Contact

- **Project Lead**: [Bloul Mohamed](https://github.com/Bloul-Mohamed)
- **Issues**: [GitHub Issues](https://github.com/Bloul-Mohamed/gazachat_app/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Bloul-Mohamed/gazachat_app/discussions)

---

<div align="center">
  <strong>Built with ❤️ for the resilient people of Gaza</strong>
  
  [![StandWithPalestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/badges/StandWithPalestine.svg)](https://github.com/TheBSD/StandWithPalestine/blob/main/docs/README.md)
</div>
