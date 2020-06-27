import 'package:flutter/material.dart';
import 'package:steps_indicator/steps_indicator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Steps Indicator Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Steps Indicator Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedStep = 0;
  int nbSteps = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StepsIndicator(
              selectedStep: selectedStep,
              nbSteps: nbSteps,
              doneLineColor: Colors.green,
              doneStepColor: Colors.green,
              undoneLineColor: Colors.red,
              unselectedStepColor: Colors.red,
              lineLength: 20,
              lineLengthCustomStep: [
                StepsIndicatorCustomLine(nbStep: 4, lenght: 105)
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MaterialButton(
                  color: Colors.red,
                  onPressed: () {
                    if(selectedStep > 0) {
                      setState(() {
                        selectedStep--;
                      });
                    }
                  },
                  child: Text('Prev'),
                ),
                MaterialButton(
                  color: Colors.green,
                  onPressed: () {
                    if(selectedStep < nbSteps) {
                      setState(() {
                        selectedStep++;
                      });
                    }
                  },
                  child: Text('Next'),
                )
              ],
            )
          ],
        )
      ),
    );
  }
}