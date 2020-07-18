library steps_indicator;

import 'package:flutter/material.dart';
import 'package:steps_indicator/linear_painter.dart';
import 'package:steps_indicator/step_widget.dart';

class StepsIndicator extends StatefulWidget {
  final int selectedStep;
  final int nbSteps;
  final Color selectedStepColorOut;
  final Color selectedStepColorIn;
  final Color doneStepColor;

  //Step colors for unselected in and out
  final Color unselectedStepColorOut;
  final Color unselectedStepColorIn;
  final Color doneLineColor;
  final Color undoneLineColor;
  final bool isHorizontal;
  final double lineLength;

  //Line thickness for done and Undone
  final double doneLineThickness;
  final double undoneLineThickness;
  final double doneStepSize;
  final double unselectedStepSize;
  final double selectedStepSize;
  final double selectedStepBorderSize;

  //Border size for unselectedStep
  final double unselectedStepBorderSize;
  final Widget doneStepWidget;
  final Widget unselectedStepWidget;
  final Widget selectedStepWidget;
  final List<StepsIndicatorCustomLine> lineLengthCustomStep;
  final bool enableLineAnimation;
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
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < widget.nbSteps; i++) stepBuilder(i),
        ],
      );
    } else {
      // Display in Column
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < widget.nbSteps; i++) stepBuilder(i),
        ],
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
        widget.enableStepAnimation) {
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
                StepWidget().generateSimpleStepWidget(
                    color: widget.unselectedStepColor,
                    size: widget.unselectedStepSize),
          );
        },
      );
    }

    return widget.unselectedStepWidget ??
        StepWidget().generateSimpleStepWidget(
            color: widget.unselectedStepColor, size: widget.unselectedStepSize);
  }

  /// A function to return the selected step widget
  /// Index [i] is used to check if animation is needed or not if activated
  Widget stepSelectedWidget(int i) {
    if (widget.selectedStep == i &&
        (i != 0 || _isPreviousStep) &&
        widget.enableStepAnimation) {
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
        widget.enableStepAnimation) {
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
      height: widget.isHorizontal ? widget.lineThickness : getLineLength(i),
      width: widget.isHorizontal ? getLineLength(i) : widget.lineThickness,
      child: CustomPaint(
        painter: LinearPainter(
          progress: widget.selectedStep == i + 1 && widget.enableLineAnimation
              ? _percentToNext
              : 1,
          progressColor: widget.doneLineColor,
          backgroundColor: widget.undoneLineColor,
          lineThickness:
              widget.isHorizontal ? widget.lineThickness : getLineLength(i),
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
        height: widget.isHorizontal ? widget.lineThickness : getLineLength(i),
        width: widget.isHorizontal ? getLineLength(i) : widget.lineThickness,
        child: CustomPaint(
          painter: LinearPainter(
            progress: _percentToPrevious,
            progressColor: widget.doneLineColor,
            backgroundColor: widget.undoneLineColor,
            lineThickness:
                widget.isHorizontal ? widget.lineThickness : getLineLength(i),
          ),
        ),
      );
    }
    return Container(
        height: widget.isHorizontal ? widget.lineThickness : getLineLength(i),
        width: widget.isHorizontal ? getLineLength(i) : widget.lineThickness,
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
