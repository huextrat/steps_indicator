library steps_indicator;

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:steps_indicator/linear_painter.dart';
import 'package:steps_indicator/step_widget.dart';

/// Custom StepsIndicator to display a line with different kind of steps
class StepsIndicator extends StatefulWidget {
  /// Selected step [default = 0]
  final int selectedStep;

  /// Number of total Steps
  final int nbSteps;

  /// Border color for selected step [default = Colors.blue]
  final Color selectedStepColorOut;

  /// Background color for selected step [default = Colors.white]
  final Color selectedStepColorIn;

  /// Background color for done step [default = Colors.blue]
  final Color doneStepColor;

  /// Border color for unselected step [default = Colors.blue]
  final Color unselectedStepColorOut;

  /// Background color for unselected step [default = Colors.blue]
  final Color unselectedStepColorIn;

  /// Color for done line [default = Colors.blue]
  final Color doneLineColor;

  /// Color for undone line [default = Colors.blue]
  final Color undoneLineColor;

  /// Make it horizontal or vertical [default = true]
  final bool isHorizontal;

  /// Length for each line [default = 40]
  final double lineLength;

  /// Line thickness for done line [default = 1]
  final double doneLineThickness;

  /// Line thickness for undone line [default = 1]
  final double undoneLineThickness;

  /// Done step size [default = 10]
  final double doneStepSize;

  /// Unselected step size [default = 10]
  final double unselectedStepSize;

  /// Selected step size [default = 14]
  final double selectedStepSize;

  /// Selected step border size [default = 14]
  final double selectedStepBorderSize;

  /// Unselected step border size [default = 14]
  final double unselectedStepBorderSize;
  final Widget doneStepWidget;
  final Widget unselectedStepWidget;
  final Widget selectedStepWidget;
  final List<StepsIndicatorCustomLine> lineLengthCustomStep;

  /// Enable line animation [default = false]
  final bool enableLineAnimation;

  /// Enable step animation [default = false]
  final bool enableStepAnimation;

  const StepsIndicator(
      {this.selectedStep = 0,
      this.nbSteps = 4,
      this.selectedStepColorOut = Colors.blue,
      this.selectedStepColorIn = Colors.white,
      this.doneStepColor = Colors.blue,
      this.unselectedStepColorOut = Colors.blue,
      this.unselectedStepColorIn = Colors.blue,
      this.doneLineColor = Colors.blue,
      this.undoneLineColor = Colors.blue,
      this.isHorizontal = true,
      this.lineLength = 40,
      this.doneLineThickness = 1,
      this.undoneLineThickness = 1,
      this.doneStepSize = 10,
      this.unselectedStepSize = 10,
      this.selectedStepSize = 14,
      this.selectedStepBorderSize = 1,
      this.unselectedStepBorderSize = 1,
      this.doneStepWidget,
      this.unselectedStepWidget,
      this.selectedStepWidget,
      this.lineLengthCustomStep,
      this.enableLineAnimation = false,
      this.enableStepAnimation = false});

  @override
  _StepsIndicatorState createState() => _StepsIndicatorState();
}

class _StepsIndicatorState extends State<StepsIndicator>
    with TickerProviderStateMixin {
  /// Previous boolean, use for pick the right animation (line & step)
  bool _isPreviousLine = false;
  bool _isPreviousStep = false;

  /// Line animation
  AnimationController _animationControllerToNext;
  Animation _animationToNext;
  double _percentToNext = 0;

  AnimationController _animationControllerToPrevious;
  Animation _animationToPrevious;
  double _percentToPrevious = 1;

  /// Step animation
  AnimationController _animationControllerSelectedStep;
  AnimationController _animationControllerDoneStep;
  AnimationController _animationControllerUnselectedStep;

  /// Init all animation controller
  @override
  void initState() {
    super.initState();
    _animationControllerToNext = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animationControllerToPrevious = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animationControllerSelectedStep = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animationControllerDoneStep = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _animationControllerUnselectedStep = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
  }

  /// Dispose all animation controller
  @override
  void dispose() {
    _animationControllerToNext.dispose();
    _animationControllerToPrevious.dispose();
    _animationControllerSelectedStep.dispose();
    _animationControllerDoneStep.dispose();
    _animationControllerUnselectedStep.dispose();
    super.dispose();
  }

  /// All the logic for activating animations when the widget is updated
  @override
  void didUpdateWidget(StepsIndicator oldWidget) {
    if (widget.enableStepAnimation) {
      _animationControllerSelectedStep.reset();
      _animationControllerDoneStep.reset();
      _animationControllerUnselectedStep.reset();

      if (widget.selectedStep < oldWidget.selectedStep) {
        setState(() {
          _isPreviousStep = true;
        });
      } else {
        setState(() {
          _isPreviousStep = false;
        });
      }
    }

    if (widget.enableLineAnimation) {
      if (widget.selectedStep > oldWidget.selectedStep) {
        _animationControllerToNext.reset();
        setState(() {
          _animationToNext = Tween(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: _animationControllerToNext, curve: Curves.linear),
          )..addListener(() {
              setState(() {
                _percentToNext = _animationToNext.value;
              });
            });
          _animationControllerToNext.forward();
        });
      } else if (widget.selectedStep < oldWidget.selectedStep) {
        _animationControllerToPrevious.reset();
        setState(() {
          _isPreviousLine = true;
          _animationToPrevious = Tween(begin: 1.0, end: 0.0).animate(
            CurvedAnimation(
                parent: _animationControllerToPrevious, curve: Curves.linear),
          )..addListener(() {
              setState(() {
                _percentToPrevious = _animationToPrevious.value;
              });
              if (_animationControllerToPrevious.isCompleted) {
                _isPreviousLine = false;
              }
            });
          _animationControllerToPrevious.forward();
        });
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  /// Build the complete StepsIndicator widget
  @override
  Widget build(BuildContext context) {
    if (widget.isHorizontal) {
      // Display in Row
      return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: [
          widget.selectedStepSize,
          widget.doneStepSize,
          widget.unselectedStepSize
        ].reduce(max)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < widget.nbSteps; i++) stepBuilder(i),
          ],
        ),
      );
    } else {
      // Display in Column
      return ConstrainedBox(
        constraints: BoxConstraints(
            minWidth: [
          widget.selectedStepSize,
          widget.doneStepSize,
          widget.unselectedStepSize
        ].reduce(max)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < widget.nbSteps; i++) stepBuilder(i),
          ],
        ),
      );
    }
  }

  /// A function to return the right widget according to the index [i]
  Widget stepBuilder(int i) {
    if (widget.isHorizontal) {
      // Display in Row
      return widget.selectedStep == i
          ? Row(
              children: <Widget>[
                stepSelectedWidget(i),
                widget.selectedStep == widget.nbSteps
                    ? stepLineDoneWidget(i)
                    : Container(),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : widget.selectedStep > i
              ? Row(
                  children: <Widget>[
                    stepDoneWidget(i),
                    i < widget.nbSteps - 1
                        ? stepLineDoneWidget(i)
                        : Container(),
                  ],
                )
              : Row(
                  children: <Widget>[
                    stepUnselectedWidget(i),
                    i != widget.nbSteps - 1
                        ? stepLineUndoneWidget(i)
                        : Container()
                  ],
                );
    } else {
      // Display in Column
      return widget.selectedStep == i
          ? Column(
              children: <Widget>[
                stepSelectedWidget(i),
                widget.selectedStep == widget.nbSteps
                    ? stepLineDoneWidget(i)
                    : Container(),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : widget.selectedStep > i
              ? Column(
                  children: <Widget>[
                    stepDoneWidget(i),
                    i < widget.nbSteps - 1
                        ? stepLineDoneWidget(i)
                        : Container(),
                  ],
                )
              : Column(
                  children: <Widget>[
                    stepUnselectedWidget(i),
                    i != widget.nbSteps - 1
                        ? stepLineUndoneWidget(i)
                        : Container()
                  ],
                );
    }
  }

  /// A function to return the unselected step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepUnselectedWidget(int i) {
    if (widget.selectedStep == i - 1 &&
        _isPreviousStep &&
        widget.enableStepAnimation &&
        widget.unselectedStepWidget == null) {
      _animationControllerUnselectedStep.forward();

      return AnimatedBuilder(
        animation: _animationControllerUnselectedStep,
        builder: (BuildContext context, Widget child) {
          final size = widget.unselectedStepSize *
              _animationControllerUnselectedStep.value;
          return Container(
            width: size,
            height: size,
            child: widget.unselectedStepWidget ??
                StepWidget().generateSelectedStepWidget(
                    colorIn: widget.unselectedStepColorIn,
                    colorOut: widget.unselectedStepColorOut,
                    stepSize: widget.unselectedStepSize,
                    borderSize: widget.unselectedStepBorderSize),
          );
        },
      );
    }

    return widget.unselectedStepWidget ??
        StepWidget().generateSelectedStepWidget(
            colorIn: widget.unselectedStepColorIn,
            colorOut: widget.unselectedStepColorOut,
            stepSize: widget.unselectedStepSize,
            borderSize: widget.unselectedStepBorderSize);
  }

  /// A function to return the selected step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepSelectedWidget(int i) {
    if (widget.selectedStep == i &&
        (i != 0 || _isPreviousStep) &&
        widget.enableStepAnimation &&
        widget.selectedStepWidget == null) {
      _animationControllerSelectedStep.forward();

      return AnimatedBuilder(
        animation: _animationControllerSelectedStep,
        builder: (BuildContext context, Widget child) {
          final size =
              widget.selectedStepSize * _animationControllerSelectedStep.value;
          return Container(
            width: size,
            height: size,
            child: widget.selectedStepWidget ??
                StepWidget().generateSelectedStepWidget(
                    colorIn: widget.selectedStepColorIn,
                    colorOut: widget.selectedStepColorOut,
                    stepSize: widget.selectedStepSize,
                    borderSize: widget.selectedStepBorderSize),
          );
        },
      );
    }

    return widget.selectedStepWidget ??
        StepWidget().generateSelectedStepWidget(
            colorIn: widget.selectedStepColorIn,
            colorOut: widget.selectedStepColorOut,
            stepSize: widget.selectedStepSize,
            borderSize: widget.selectedStepBorderSize);
  }

  /// A function to return the done step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepDoneWidget(int i) {
    if (widget.selectedStep - 1 == i &&
        !_isPreviousStep &&
        widget.enableStepAnimation &&
        widget.doneStepWidget == null) {
      _animationControllerDoneStep.forward();

      return AnimatedBuilder(
        animation: _animationControllerDoneStep,
        builder: (BuildContext context, Widget child) {
          final size = widget.doneStepSize * _animationControllerDoneStep.value;
          return Container(
            width: size,
            height: size,
            child: widget.doneStepWidget ??
                StepWidget().generateSimpleStepWidget(
                    color: widget.doneStepColor, size: widget.doneStepSize),
          );
        },
      );
    }

    return widget.doneStepWidget ??
        StepWidget().generateSimpleStepWidget(
            color: widget.doneStepColor, size: widget.doneStepSize);
  }

  /// A function to return the line done widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepLineDoneWidget(int i) {
    return Container(
      height: widget.isHorizontal ? widget.doneLineThickness : getLineLength(i),
      width: widget.isHorizontal ? getLineLength(i) : widget.doneLineThickness,
      child: CustomPaint(
        painter: LinearPainter(
          progress: widget.selectedStep == i + 1 && widget.enableLineAnimation
              ? _percentToNext
              : 1,
          progressColor: widget.doneLineColor,
          backgroundColor: widget.undoneLineColor,
          lineThickness:
              widget.isHorizontal ? widget.doneLineThickness : getLineLength(i),
        ),
      ),
    );
  }

  /// A function to return the line undone widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepLineUndoneWidget(int i) {
    if (_isPreviousLine &&
        widget.selectedStep == i &&
        widget.enableLineAnimation) {
      return Container(
        height:
            widget.isHorizontal ? widget.undoneLineThickness : getLineLength(i),
        width:
            widget.isHorizontal ? getLineLength(i) : widget.undoneLineThickness,
        child: CustomPaint(
          painter: LinearPainter(
            progress: _percentToPrevious,
            progressColor: widget.doneLineColor,
            backgroundColor: widget.undoneLineColor,
            lineThickness: widget.isHorizontal
                ? widget.undoneLineThickness
                : getLineLength(i),
          ),
        ),
      );
    }
    return Container(
        height:
            widget.isHorizontal ? widget.undoneLineThickness : getLineLength(i),
        width:
            widget.isHorizontal ? getLineLength(i) : widget.undoneLineThickness,
        color: widget.undoneLineColor);
  }

  /// A function to return the line length of a specific index [i]
  double getLineLength(int i) {
    final nbStep = i + 1;
    if (widget.lineLengthCustomStep != null &&
        widget.lineLengthCustomStep.isNotEmpty) {
      if (widget.lineLengthCustomStep.any((it) => (it.nbStep - 1) == nbStep)) {
        return widget.lineLengthCustomStep
            .firstWhere((it) => (it.nbStep - 1) == nbStep)
            .length;
      }
    }
    return widget.lineLength;
  }
}

/// Class to define a custom line with [nbStep] & [length]
class StepsIndicatorCustomLine {
  final int nbStep;
  final double length;

  StepsIndicatorCustomLine({this.nbStep, this.length});
}
