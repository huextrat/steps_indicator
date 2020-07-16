library steps_indicator;

import 'package:flutter/material.dart';
import 'package:steps_indicator/linear_painter.dart';

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
      this.lineLengthCustomStep});

  @override
  _StepsIndicatorState createState() => _StepsIndicatorState();
}

class _StepsIndicatorState extends State<StepsIndicator> with TickerProviderStateMixin {
  AnimationController _animationControllerToNext;
  Animation _animationToNext;
  double _percentToNext = 0;

  AnimationController _animationControllerToPrevious;
  Animation _animationToPrevious;
  double _percentToPrevious = 1;

  bool isPreviousStep = false;

  @override
  void initState() {
    super.initState();
    _animationControllerToNext = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this
    );
    _animationControllerToPrevious = AnimationController(
        duration: const Duration(milliseconds: 400),
        vsync: this
    );
  }

  @override
  void dispose() {
    _animationControllerToNext.dispose();
    _animationControllerToPrevious.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(StepsIndicator oldWidget) {
    if (widget.selectedStep > oldWidget.selectedStep) {
      _animationControllerToNext.reset();
      setState(() {
        _animationToNext = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(parent: _animationControllerToNext, curve: Curves.linear),
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
        isPreviousStep = true;
        _animationToPrevious = Tween(begin: 1.0, end: 0.0).animate(
          CurvedAnimation(parent: _animationControllerToPrevious, curve: Curves.linear),
        )..addListener(() {
          setState(() {
            _percentToPrevious = _animationToPrevious.value;
          });
          if (_animationControllerToPrevious.isCompleted) {
            isPreviousStep = false;
          }
        });
        _animationControllerToPrevious.forward();
      });
    }
    super.didUpdateWidget(oldWidget);
  }

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

  Widget stepBuilder(int i) {
    if (widget.isHorizontal) {
      // Display in Row
      return widget.selectedStep == i
          ? Row(
              children: <Widget>[
                stepSelectedWidget(),
                widget.selectedStep == widget.nbSteps ? stepLineDoneWidget(i) : Container(),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : widget.selectedStep > i
              ? Row(
                  children: <Widget>[
                    stepDoneWidget(),
                    i < widget.nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
                  ],
                )
              : Row(
                  children: <Widget>[
                    stepUnselectedWidget(),
                    i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
                  ],
                );
    } else {
      // Display in Column
      return widget.selectedStep == i
          ? Column(
              children: <Widget>[
                stepSelectedWidget(),
                widget.selectedStep == widget.nbSteps ? stepLineDoneWidget(i) : Container(),
                i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : widget.selectedStep > i
              ? Column(
                  children: <Widget>[
                    stepDoneWidget(),
                    i < widget.nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
                  ],
                )
              : Column(
                  children: <Widget>[
                    stepUnselectedWidget(),
                    i != widget.nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
                  ],
                );
    }
  }

  Widget stepSelectedWidget() {
    return widget.selectedStepWidget ?? ClipRRect(
            borderRadius: BorderRadius.circular(widget.selectedStepSize),
            child: Container(
                decoration: BoxDecoration(
                    color: widget.selectedStepColorIn,
                    borderRadius: BorderRadius.circular(widget.selectedStepSize),
                    border: Border.all(
                        width: widget.selectedStepBorderSize,
                        color: widget.selectedStepColorOut)),
                height: widget.selectedStepSize,
                width: widget.selectedStepSize,
                child: Container()));
  }

  Widget stepDoneWidget() {
    return widget.doneStepWidget ?? ClipRRect(
            borderRadius: BorderRadius.circular(widget.doneStepSize),
            child: Container(
              color: widget.doneStepColor,
              height: widget.doneStepSize,
              width: widget.doneStepSize,
              child: Container(),
            ),
          );
  }

  Widget stepUnselectedWidget() {
    return widget.unselectedStepWidget ?? ClipRRect(
            borderRadius: BorderRadius.circular(widget.unselectedStepSize),
            child: Container(
                    color: widget.unselectedStepColorIn,
                        color: widget.unselectedStepColorOut)),
                height: widget.unselectedStepSize,
                width: widget.unselectedStepSize,
              color: widget.unselectedStepColor,
              height: widget.unselectedStepSize,
              width: widget.unselectedStepSize,
              child: Container(),
            ),
          );
  }

  Widget stepLineDoneWidget(int i) {
    return Container(
      height: widget.isHorizontal ? widget.lineThickness : getLineLength(i),
      width: widget.isHorizontal ? getLineLength(i) : widget.lineThickness,
      child: CustomPaint(
        painter: LinearPainter(
            progress: widget.selectedStep == i + 1 ? _percentToNext : 1,
            progressColor: widget.doneLineColor,
            backgroundColor: widget.undoneLineColor,
            lineThickness: widget.lineThickness
        ),
      ),
    );
  }

  Widget stepLineUndoneWidget(int i) {
    if (isPreviousStep && widget.selectedStep == i) {
      return Container(
        height: widget.isHorizontal ? widget.lineThickness : getLineLength(i),
        width: widget.isHorizontal ? getLineLength(i) : widget.lineThickness,
        child: CustomPaint(
          painter: LinearPainter(
              progress: _percentToPrevious,
              progressColor: widget.doneLineColor,
              backgroundColor: widget.undoneLineColor,
              lineThickness: widget.lineThickness
          ),
        ),
      );
    }
    return Container(
        height: widget.isHorizontal ? widget.lineThickness : getLineLength(i),
        width: widget.isHorizontal ? getLineLength(i) : widget.lineThickness,
        color: widget.undoneLineColor);
  }

  double getLineLength(int i) {
    final nbStep = i + 1;
    if (widget.lineLengthCustomStep != null && widget.lineLengthCustomStep.isNotEmpty) {
      if (widget.lineLengthCustomStep.any((it) => (it.nbStep - 1) == nbStep)) {
        return widget.lineLengthCustomStep
            .firstWhere((it) => (it.nbStep - 1) == nbStep)
            .lenght;
      }
    }
    return widget.lineLength;
  }
}

class StepsIndicatorCustomLine {
  final int nbStep;
  final double lenght;

  StepsIndicatorCustomLine({this.nbStep, this.lenght});
}
