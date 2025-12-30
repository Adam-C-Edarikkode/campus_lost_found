# Campus Lost & Found 

A Flutter application designed to help students and staff report and track lost and found items on campus. Built with a clean architecture and offline-first approach using Hive.

##  Features

- **Report Items**: Easily report lost or found items with details like title, description, category, and photo.
- **Search & Filter**: Quickly find items by searching keywords or filtering by category (Electronics, Clothing, Books, etc.) and status (Lost/Found).
- **Categories**: Organized reporting with predefined categories.
- **Dark/Light Mode**: Toggle between themes for better visibility.
- **Offline Storage**: Uses Hive to persist data locally on the device.
- **Modern UI**: Clean and responsive Material 3 design.

##  Tech Stack

- **Framework**: Flutter
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Local Database**: [Hive](https://pub.dev/packages/hive)
- **Image Handling**: [image_picker](https://pub.dev/packages/image_picker)
- **Utilities**: [intl](https://pub.dev/packages/intl), [uuid](https://pub.dev/packages/uuid)

##  Project Structure

The project follows a clean architecture pattern:

- `lib/core`: Core utilities and theme configuration.
- `lib/data`: Data models and persistence logic.
- `lib/logic`: State management (Providers).
- `lib/presentation`: UI components, screens, and widgets.

##  Getting Started

### Prerequisites

- Flutter SDK (^3.10.4)
- Dart SDK

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Adam-C-Edarikkode/campus_lost_found
   cd lostandfound
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```
