# steps_indicator

A simple steps indicator widget

## Installation

Add `steps_indicator: ^0.1.0+1` in your `pubspec.yaml` dependencies. And import it:

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
  undoneLineColor: Colors.red
)
```

For a more detail example please take a look at the `example` folder.

## Example

Steps indicator:

<img src="https://raw.githubusercontent.com/huextrat/steps_indicator/master/example/screenshot.png" width="400" height="790">

## -

If something is missing, feel free to open a ticket or contribute!
