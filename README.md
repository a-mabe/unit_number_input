# unit_number_input

A Flutter package for entering minutes and seconds with built-in validation, auto-conversion to total seconds, and input decoration. Originally created for [OpenHIIT](https://github.com/a-mabe/OpenHIIT). Currently only handles minutes and seconds, could be expanded for other values.

---
## Table of Contents

1. [Installation](#installation)
1. [Basic Usage](#basic-usage)
    1. [Example Usage](#example-usage)
1. [Advanced Configuration](#Advanced-Configuration)
1. [Contributing](#Contributing)
    1. [Code of Conduct](#Code-of-Conduct)
1. [Credits](#credits)
1. [License](#license)

---

## Installation

Add `unit_number_input` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  unit_number_input: ^1.0.0
```

## Basic Usage

3. Define a controller:

```dart
final UnitNumberInputController _controller = UnitNumberInputController();
```

4. Create a `UnitNumberInput` widget and pass the controller:

```dart
UnitNumberInput(
  controller: _controller,
  onChanged: (seconds) {
    print("Total seconds: $seconds");
  },
),
```

### Example Usage

Check out the [example](example) directory in this repository for a complete example of how to use `unit_number_input` in a Flutter app.

## Contributing

View the [contributing documentation](./CONTRIBUTING.md). If contributing code changes, please checkout the [testing documentation](./doc/testing.md).

### Code of Conduct

When contributing, please keep the [Code of Conduct](./CODE_OF_CONDUCT.md) in mind.
