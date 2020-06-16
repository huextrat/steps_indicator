# steps_indicator

[![pub package](https://img.shields.io/pub/v/steps_indicator.svg?style=for-the-badge&color=blue)](https://pub.dartlang.org/packages/steps_indicator)

A simple steps indicator widget

## Installation

Add `steps_indicator: ^1.0.0` in your `pubspec.yaml` dependencies. And import it:

```dart
import 'package:steps_indicator/steps_indicator.dart';
```

## How to use

Simply create a `StepsIndicator` widget and pass the required params:

```dart
StepsIndicator(
  selectedStep: 1,
  nbSteps: 4
)
```

Do not forget to check that the selectedStep is not lower than 0 and is not higher than the total number of steps (nbSteps).

## Params

```dart
StepsIndicator(
  selectedStep: 1,
  nbSteps: 4,
  selectedStepColorOut: Colors.blue,
  selectedStepColorIn: Colors.white,
  doneStepColor: Colors.blue,
  unselectedStepColor: Colors.red,
  doneLineColor: Colors.blue,
  undoneLineColor: Colors.red,
  isHorizontal: true,
  lineLength: 40,
  lineThickness: 1,
  doneStepSize: 10,
  unselectedStepSize: 10,
  selectedStepSize: 14,
  selectedStepBorderSize: 1,
  doneStepWidget: Container(), // Custom Widget 
  unselectedStepWidget: Container(), // Custom Widget 
  selectedStepWidget: Container(), // Custom Widget 
  lineLengthCustomStep: [
    StepsIndicatorCustomLine(nbStep: 3, lenght: 80)
  ]
)
```

For a more detail example please take a look at the `example` folder.

## Example

Steps indicator:

<img src="https://raw.githubusercontent.com/huextrat/steps_indicator/master/example/screenshot.png" width="400" height="790">

## -

If something is missing, feel free to open a ticket or contribute!
