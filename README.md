# Localizator

A tool for simplifying iOS app localization with `.xcstrings` string catalogs.

## Overview

Localizator helps iOS developers efficiently manage and localize their applications using Apple's modern string catalog approach. With Localizator, you can:

- Generate `.xcstrings` files from your codebase
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

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/Localizator.git
cd Localizator

# Install dependencies (if applicable)
# ...
```

## Usage

### Generating a New String Catalog

1. In Xcode, go to File > New > File
2. Select "String Catalog" under "Resource"
3. Name it "Localizable" (or your preferred name)
4. Add it to your target(s)

### Finding Strings to Localize

Scan your project for localizable strings:

```bash
# Example command
./localizator scan --project YourProject.xcodeproj --output strings_to_localize.json
```

### Adding Strings to Your Catalog

1. Open your `.xcstrings` file in Xcode
2. Click the "+" button to add a new string
3. Enter the string key and value

Or use Localizator to batch-add strings:

```bash
# Example command
./localizator import --input strings_to_localize.json --catalog path/to/Localizable.xcstrings
```

### Adding New Languages

1. In Xcode, select your project file
2. Go to "Info" > "Localizations"
3. Click "+" to add supported languages
4. Select the resources to localize

### Managing Translations with Localizator

```bash
# Export for translation
./localizator export --catalog path/to/Localizable.xcstrings --output translations.xlsx

# Import completed translations
./localizator import --translations translations.xlsx --catalog path/to/Localizable.xcstrings
```

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
// In code
Text("Welcome \(username)", tableName: nil)

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
// In code
Text("**Bold** and *italic* text", tableName: nil)

// In Localizable.xcstrings with preserved formatting across languages
```

## Resources

- [Apple Documentation: Localizing with String Catalogs](https://developer.apple.com/documentation/xcode/localizing-and-varying-text-with-a-string-catalog)
- [WWDC23: Internationalize your app](https://developer.apple.com/videos/play/wwdc2023/10155/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 