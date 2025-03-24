# Localizator

A tool for simplifying iOS app localization with `.xcstrings` string catalogs.

## Overview

Localizator helps iOS developers efficiently manage and localize their applications using Apple's modern string catalog approach. With Localizator, you can:

- Generate translations for your `.xcstrings` files using OpenAI
- Manage translations across multiple languages
- Streamline the localization workflow

## String Catalog Benefits

Apple's string catalog (`.xcstrings`) approach offers several advantages over traditional `.strings` files:

- Centralized management of all localizable content
- Built-in validation for missing translations
- Support for string variations (plurals, device types, etc.)
- Easy tracking of translation states ("translated", "needs review", etc.)

## Getting Started

### Prerequisites

- Xcode 15 or newer
- macOS Ventura or newer
- Your iOS project
- OpenAI API key

### Installation

```bash
# Clone the repository
git clone https://github.com/ooodin/Localizator.git
cd Localizator

# Run using Swift
swift run localizator <OpenAI_API_key> <file_path> <language_codes>
```

### Example Usage

```bash
# Localize a string catalog file to French, German, Spanish, and Japanese
swift run localizator sk-1234yourOpenAIkeyABCD path/to/Localizable.xcstrings fr de es jp
```

## Usage

### Setting Up Automatic String Catalog Generation in Xcode

Xcode 15+ can automatically extract localizable strings from your code and generate a string catalog:

1. Select your project file in Xcode
2. Select the target you want to localize
3. Go to "Build Settings" tab
4. Search for "string catalog"
5. Configure these settings:
   - Set "Generate String Catalog during Build" to "Yes"
   - Set "Localized String Macro Names" to include `NSLocalizedString`, `CFCopyLocalizedString` and any other macros you use

This will generate a `.xcstrings` file containing all localizable strings from your codebase when you build your app.

### Extracting Strings from Your Code

Here are the modern Swift approaches to mark text for localization:

#### 1. Using SwiftUI Text Views

```swift
// Simple text will be automatically extracted
Text("Hello, World!")

// String with interpolation
Text("Hello, \(name)")
```

#### 2. Using String(localized:)

```swift
// Basic usage
let message = String(localized: "Hello, World!")

// With format
let formatted = String(localized: "Hello, \(username)")
```

### Localizing with Localizator

Once you've created your string catalog and added your strings:

```bash
# Run the localization process
swift run localizator <OpenAI_API_key> <file_path> <language_codes>

# Example with multiple languages
swift run localizator sk-yourapikey123 ./Localizable.xcstrings fr de es jp
```

The tool will automatically:
1. Parse your string catalog
2. Identify untranslated strings
3. Generate translations using OpenAI
4. Update your string catalog with the translated content

## Example Structure

A typical `.xcstrings` file structure looks like:

```json
{
  "strings" : {
    "Welcome to the app" : {
      "localizations" : {
        "fr" : {
          "stringUnit" : {
            "state" : "translated",
            "value" : "Bienvenue dans l'application"
          }
        },
        "es" : {
          "stringUnit" : {
            "state" : "needs_review",
            "value" : "Bienvenido a la aplicación"
          }
        }
      }
    }
  },
  "sourceLanguage" : "en"
}
```

## Advanced Features

### String Variations

String catalogs support variations for different contexts:

```swift
// Basic string with format specifier
let greeting = String(localized: "Welcome \(username)")

// In Localizable.xcstrings
"Welcome %@" : {
  "localizations" : {
    "en" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Welcome %@"
      }
    },
    "es" : {
      "stringUnit" : {
        "state" : "translated",
        "value" : "Bienvenido %@"
      }
    }
  }
}
```

### Markdown Support

String catalogs support markdown formatting:

```swift
// In code - markdown is preserved across translations
let message = String(localized: "**Bold** and *italic* text")

// In SwiftUI
Text("**Bold** and *italic* text")
```

## Resources

- [Apple Documentation: Localization](https://developer.apple.com/documentation/Xcode/localization)
- [Apple Documentation: Localizing with String Catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog#Localize-your-apps-text)
- [Apple Documentation: Exporting Localizations](https://developer.apple.com/documentation/xcode/exporting-localizations)
- [WWDC23: Internationalize your app](https://developer.apple.com/videos/play/wwdc2023/10155/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
