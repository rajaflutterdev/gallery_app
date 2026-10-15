# Flutter Unsplash Image Search

A Flutter application that allows users to search and explore photos using the Unsplash API. The app uses Dio for HTTP requests and displays image results with photographer names and descriptions.

## Features

- Search photos by keyword.
- Fetch images using the Unsplash API.
- Display results in a two-column grid.
- View image details, photographer names, and descriptions.
- Loading indicator while fetching images.
- Error handling for API failures and empty results.
- Null-safe JSON model parsing.
- Dismiss the keyboard when searching.
- Cross-platform support for Android and iOS.

## Tech Stack

- **Flutter** — UI development
- **Dart** — Programming language
- **Dio** — HTTP client
- **Unsplash API** — Image search and photo data

## Project Structure

```text
lib/
├── main.dart
├── core/
│   └── constant
|          └── constant.dart
|          └── string_values.dart
|   └── exception
|          └── exception.dart
├── features/
│   └── gallery 
|         └── bloc
|         └── data
|                └── model
|                └── repository 
|         └── presentation
|   └── splash
|        └── splash.dart
└── screens/
    └── image_search_screen.dart
```

## Prerequisites

Install the following before running the project:

- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Android emulator, iOS simulator, or a physical device
- An Unsplash developer account

## Installation

### 1. Clone the repository

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
cd YOUR_PROJECT_DIRECTORY
```

Replace the placeholders with your GitHub repository URL and project directory name.

### 2. Install dependencies

```bash
flutter pub get
```

If Dio is not already included in `pubspec.yaml`, run:

```bash
flutter pub add dio
```

## API-Key Configuration

### 1. Create an Unsplash application

Visit the Unsplash Developers website:

https://unsplash.com/developers

Register an application and obtain your Access Key.

### 2. Configure the Access Key

The API service uses the following endpoint:

```text
https://api.unsplash.com/search/photos
```

For local development, replace `YOUR_ACCESS_KEY` in `unsplash_service.dart`:

```dart
headers: {
  'Authorization': 'Client-ID YOUR_ACCESS_KEY',
  'Accept-Version': 'v1',
},
```

Alternatively, if your service passes the key as a query parameter, use:

```dart
queryParameters: {
  'client_id': accessKey,
  'query': query,
  'per_page': 20,
  'page': 1,
},
```

Use one authentication approach consistently. Do not commit a real Access Key to a public repository.

**Production security:** A key included in a Flutter application can be extracted from the app, even if it is obfuscated or stored locally. For production, consider routing requests through a backend that holds the credential securely.

## Run the Application

Start an emulator or connect a device, then run:

```bash
flutter run
```

To build an Android APK:

```bash
flutter build apk --release
```

For an iOS release build, use macOS with Xcode installed:

```bash
flutter build ios --release
```

## How to Use

1. Launch the application.
2. Enter a keyword, such as `nature`, `cars`, `people`, or `mountains`.
3. Tap the Search button or press Enter.
4. Browse the returned photos.
5. Tap a photo to view its details.

## Error Handling

The application handles common situations:

- Invalid or missing API key
- Internet connection failures
- Empty search results
- Missing photographer names or descriptions
- Images that fail to load

For `401 Unauthorized`, verify the Access Key. For rate-limit errors, check your Unsplash API quota and application limits.

## API Response

Unsplash search responses contain a `results` array. Each photo can include fields such as:

- `id`
- `description`
- `alt_description`
- `urls`
- `user`

The app uses `urls.regular` to display photos and `user.name` for the photographer name.

## Useful Links

- Unsplash API documentation: https://unsplash.com/documentation
- Unsplash Developers: https://unsplash.com/developers
- Flutter documentation: https://docs.flutter.dev/
- Dio package: https://pub.dev/packages/dio

## License and Attribution

Follow the Unsplash API Terms and Guidelines when displaying or using photos. Implement any required photographer attribution and links, and review the API's current usage requirements before publishing the application.

---

**Developed with Flutter and the Unsplash API.**
