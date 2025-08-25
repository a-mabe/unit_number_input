# unit_number_input

A Flutter package for entering minutes and seconds with built-in validation, auto-conversion to total seconds, and input decoration. Originally created for [OpenHIIT](https://github.com/a-mabe/OpenHIIT). Currently only handles minutes and seconds, could be expanded for other values.

<div align="center">
  <img src="https://github.com/user-attachments/assets/92326bcd-de2b-4a4b-b7fe-13cd4b7bdde2" alt="unit_number_input GIF" width="400"/>
</div>

---
## Table of Contents

1. [Installation](#installation)
1. [Basic Usage](#basic-usage)
    1. [Example Usage](#example-usage)
1. [Contributing](#Contributing)
    1. [Code of Conduct](#Code-of-Conduct)
1. [License](#license)

---

## Installation

Add `unit_number_input` to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  unit_number_input: ^0.1.0
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

## License

`unit_number_input` is open-source software released under the [MIT License](https://opensource.org/licenses/MIT). You are free to modify and distribute the application under the terms of this license. See the `LICENSE` file for more information.

Please note that this README file is subject to change as the application evolves. Refer to the latest version of this file in the repository for the most up-to-date information.
