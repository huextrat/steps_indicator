library steps_indicator;

import 'package:flutter/material.dart';

class StepsIndicator extends StatelessWidget {
  final int selectedStep;
  final int nbSteps;
  final Color selectedStepColorOut;
  final Color selectedStepColorIn;
  final Color doneStepColor;
  final Color unselectedStepColor;
  final Color doneLineColor;
  final Color undoneLineColor;
  final bool isHorizontal;
  final double lineLength;
  final double lineThickness;
  final double doneStepSize;
  final double unselectedStepSize;
  final double selectedStepSize;
  final double selectedStepBorderSize;
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
      this.unselectedStepColor = Colors.blue,
      this.doneLineColor = Colors.blue,
      this.undoneLineColor = Colors.blue,
      this.isHorizontal = true,
      this.lineLength = 40,
      this.lineThickness = 1,
      this.doneStepSize = 10,
      this.unselectedStepSize = 10,
      this.selectedStepSize = 14,
      this.selectedStepBorderSize = 1,
      this.doneStepWidget,
      this.unselectedStepWidget,
      this.selectedStepWidget,
      this.lineLengthCustomStep});

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      // Display in Row
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < nbSteps; i++) stepBuilder(i),
        ],
      );
    } else {
      // Display in Column
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          for (var i = 0; i < nbSteps; i++) stepBuilder(i),
        ],
      );
    }
  }

  Widget stepBuilder(int i) {
    if (isHorizontal) {
      // Display in Row
      return (selectedStep == i
          ? Row(
              children: <Widget>[
                stepSelectedWidget(),
                selectedStep == nbSteps ? stepLineDoneWidget(i) : Container(),
                i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : selectedStep > i
              ? Row(
                  children: <Widget>[
                    stepDoneWidget(),
                    i < nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
                  ],
                )
              : Row(
                  children: <Widget>[
                    stepUnselectedWidget(),
                    i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
                  ],
                ));
    } else {
      // Display in Column
      return (selectedStep == i
          ? Column(
              children: <Widget>[
                stepSelectedWidget(),
                selectedStep == nbSteps ? stepLineDoneWidget(i) : Container(),
                i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
              ],
            )
          : selectedStep > i
              ? Column(
                  children: <Widget>[
                    stepDoneWidget(),
                    i < nbSteps - 1 ? stepLineDoneWidget(i) : Container(),
                  ],
                )
              : Column(
                  children: <Widget>[
                    stepUnselectedWidget(),
                    i != nbSteps - 1 ? stepLineUndoneWidget(i) : Container()
                  ],
                ));
    }
  }

  Widget stepSelectedWidget() {
    return Hero(
      tag: 'selectedStep',
      child: selectedStepWidget != null
          ? selectedStepWidget
          : ClipRRect(
              borderRadius: BorderRadius.circular(selectedStepSize),
              child: Container(
                  decoration: BoxDecoration(
                      color: selectedStepColorIn,
                      borderRadius: BorderRadius.circular(selectedStepSize),
                      border: Border.all(
                          width: selectedStepBorderSize,
                          color: selectedStepColorOut)),
                  height: selectedStepSize,
                  width: selectedStepSize,
                  child: Container()),
            ),
    );
  }

  Widget stepDoneWidget() {
    return doneStepWidget != null
        ? doneStepWidget
        : ClipRRect(
            borderRadius: BorderRadius.circular(doneStepSize),
            child: Container(
              color: doneStepColor,
              height: doneStepSize,
              width: doneStepSize,
              child: Container(),
            ),
          );
  }

  Widget stepUnselectedWidget() {
    return unselectedStepWidget != null
        ? unselectedStepWidget
        : ClipRRect(
            borderRadius: BorderRadius.circular(unselectedStepSize),
            child: Container(
              color: unselectedStepColor,
              height: unselectedStepSize,
              width: unselectedStepSize,
              child: Container(),
            ),
          );
  }

  Widget stepLineDoneWidget(int i) {
    return Container(
        height: isHorizontal ? lineThickness : getLineLength(i),
        width: isHorizontal ? getLineLength(i) : lineThickness,
        color: doneLineColor);
  }

  Widget stepLineUndoneWidget(int i) {
    return Container(
        height: isHorizontal ? lineThickness : getLineLength(i),
        width: isHorizontal ? getLineLength(i) : lineThickness,
        color: undoneLineColor);
  }

  double getLineLength(int i) {
    var nbStep = i + 1;
    if (lineLengthCustomStep != null && lineLengthCustomStep.length > 0) {
      if (lineLengthCustomStep.any((it) => (it.nbStep - 1) == nbStep)) {
        return lineLengthCustomStep
            .firstWhere((it) => (it.nbStep - 1) == nbStep)
            .lenght;
      }
    }
    return lineLength;
  }
}

class StepsIndicatorCustomLine {
  final int nbStep;
  final double lenght;

  StepsIndicatorCustomLine({this.nbStep, this.lenght});
}
