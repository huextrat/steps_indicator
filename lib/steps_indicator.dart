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

  const StepsIndicator({
    this.selectedStep = 0,
    this.nbSteps = 4,
    this.selectedStepColorOut = Colors.blue,
    this.selectedStepColorIn = Colors.white,
    this.doneStepColor = Colors.blue,
    this.unselectedStepColor = Colors.blue,
    this.doneLineColor = Colors.blue,
    this.undoneLineColor = Colors.blue,
    this.isHorizontal = true
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < nbSteps; i++) stepBuilder(i),
      ],
    ) : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (var i = 0; i < nbSteps; i++) stepBuilder(i),
      ],
    );
  }

  Widget stepBuilder(int i) {
    return isHorizontal ? (selectedStep == i
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
              )) : (selectedStep == i
        ? Column(
      children: <Widget>[
        stepSelectedWidget(),
        selectedStep == nbSteps ? stepLineDoneWidget() : Container(),
        i != nbSteps - 1 ? stepLineUndoneWidget() : Container()
      ],
    )
        : selectedStep > i
        ? Column(
      children: <Widget>[
        stepDoneWidget(),
        stepLineDoneWidget(),
      ],
    )
        : Column(
      children: <Widget>[
        stepUnselectedWidget(),
        i != nbSteps - 1 ? stepLineUndoneWidget() : Container()
      ],
    ));
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
    return Container(height: isHorizontal ? 1 : 40, width: isHorizontal ? 40 : 1, color: doneLineColor);
  }

  Widget stepLineUndoneWidget() {
    return Container(height: isHorizontal ? 1 : 40, width: isHorizontal ? 40 : 1, color: undoneLineColor);
  }
}
