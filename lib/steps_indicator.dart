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

  const StepsIndicator({
    this.selectedStep = 0,
    this.nbSteps = 4,
    this.selectedStepColorOut = Colors.blue,
    this.selectedStepColorIn = Colors.white,
    this.doneStepColor = Colors.blue,
    this.unselectedStepColor = Colors.blue,
    this.doneLineColor = Colors.blue,
    this.undoneLineColor = Colors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < nbSteps; i++) stepBuilder(i),
      ],
    );
  }

  Widget stepBuilder(int i) {
    return selectedStep == i
        ? Row(
            children: <Widget>[
              stepSelectedWidget(),
              selectedStep == nbSteps ? stepLineDoneWidget() : Container(),
              i != nbSteps - 1 ? stepLineUndoneWidget() : Container()
            ],
          )
        : selectedStep > i
            ? Row(
                children: <Widget>[
                  stepDoneWidget(),
                  stepLineDoneWidget(),
                ],
              )
            : Row(
                children: <Widget>[
                  stepUnselectedWidget(),
                  i != nbSteps - 1 ? stepLineUndoneWidget() : Container()
                ],
              );
  }

  Widget stepSelectedWidget() {
    return Hero(
      tag: 'selectedStep',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Container(
            decoration: BoxDecoration(
                color: selectedStepColorIn,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(width: 1, color: selectedStepColorOut)),
            height: 14,
            width: 14,
            child: Container()),
      ),
    );
  }

  Widget stepDoneWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: doneStepColor,
        height: 10,
        width: 10,
        child: Container(),
      ),
    );
  }

  Widget stepUnselectedWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        color: unselectedStepColor,
        height: 10,
        width: 10,
        child: Container(),
      ),
    );
  }

  Widget stepLineDoneWidget() {
    return Container(height: 1, width: 40, color: doneLineColor);
  }

  Widget stepLineUndoneWidget() {
    return Container(height: 1, width: 40, color: undoneLineColor);
  }
}
