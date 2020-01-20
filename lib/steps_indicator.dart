library steps_indicator;

import 'package:flutter/material.dart';

class StepsIndicator extends StatelessWidget {
  final int selectedStep;
  final int nbSteps;
  final Color selectedStepColor;
  final Color doneStepColor;
  final Color unselectedStepColor;
  final Color doneLineColor;
  final Color undoneLineColor;

  const StepsIndicator(
      {
        this.selectedStep = 0,
        this.nbSteps = 4,
        this.selectedStepColor = Colors.blue,
        this.doneStepColor = Colors.blue,
        this.unselectedStepColor = Colors.blue,
        this.doneLineColor = Colors.blue,
        this.undoneLineColor = Colors.blue,
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        for (var i = 0; i < nbSteps; i++) stepBuilder(i),
      ],
    );
  }

  Widget stepBuilder(int i) {
    return stepSelected == i
        ? Row(
      children: <Widget>[
        stepSelectedWidget(),
        stepSelected == nbSteps ? stepLineDoneWidget() : Container(),
        i != nbSteps-1 ? stepLineUndoneWidget() : Container()
      ],
    )
        : stepSelected > i ? Row(
      children: <Widget>[
        stepDoneWidget(),
        stepLineDoneWidget(),
      ],
    ) : Row(
      children: <Widget>[
        stepUnselectedWidget(),
        i != nbSteps-1 ? stepLineUndoneWidget() : Container()
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(7),
                border: Border.all(width: 1, color: selectedStepColor)),
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
