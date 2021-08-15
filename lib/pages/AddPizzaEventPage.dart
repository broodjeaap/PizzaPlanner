import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/util.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddPizzaEventPage extends StatefulWidget {
  final PizzaRecipe pizzaRecipe;

  AddPizzaEventPage(this.pizzaRecipe);

  @override
  AddPizzaEventPageState createState() => AddPizzaEventPageState();
}

class AddPizzaEventPageState extends State<AddPizzaEventPage> {
  String name = "";
  int pizzaCount = 1;
  int doughBallSize = 250;
  DateTime eventTime = DateTime.now();

  bool nameValidation = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Pizza Event"),
        ),
        resizeToAvoidBottomInset: false,
        body: Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child:  Column(
                children: <Widget>[
                  Expanded(
                      flex: 20,
                      child: Column(
                          children: <Widget>[
                            Row(
                                children: <Widget>[
                                  Icon(Icons.title),
                                  Container(width: 25),
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(
                                          hintText: "Event Name",
                                          errorText: this.nameValidation ? "Name can\'t be empty" : null
                                      ),
                                      onChanged: (String newName) {
                                        setState(() {
                                          name = newName;
                                        });
                                      },
                                    ),
                                  )
                                ]
                            ),
                            Row(
                                children: <Widget>[
                                  Icon(FontAwesome5.hashtag),
                                  Expanded(
                                      child: Slider(

                                        value: pizzaCount.toDouble(),
                                        min: 1,
                                        max: 20,
                                        divisions: 19,
                                        label: this.pizzaCount.toString(),
                                        onChanged: (double newPizzaCount) {
                                          setState(() {this.pizzaCount = newPizzaCount.round();});
                                        },
                                      )
                                  ),
                                  Container(
                                      width: 25,
                                      child: Text(this.pizzaCount.toString())
                                  )
                                ]
                            ),
                            Row(
                                children: <Widget>[
                                  Icon(FontAwesome5.weight_hanging),
                                  Expanded(
                                      child: Slider(
                                        value: doughBallSize.toDouble(),
                                        min: 100,
                                        max: 400,
                                        divisions: 30,
                                        label: this.doughBallSize.toString(),
                                        onChanged: (double newDoughBallSize) {
                                          setState(() {this.doughBallSize = newDoughBallSize.round();});
                                        },
                                      )
                                  ),
                                  Container(
                                      width: 25,
                                      child: Text(this.doughBallSize.toString())
                                  )
                                ]
                            ),
                          ]
                      )
                  ),
                  Divider(),
                  Expanded(
                      flex: 45,
                      child: ListView(
                          children: <Widget>[
                            Column(
                                children: this.widget.pizzaRecipe.recipeSteps.where((recipeStep) => recipeStep.waitDescription.length > 0).map((recipeStep) {
                                  return <Widget>[
                                    Text(recipeStep.waitDescription),
                                    Row(
                                        children: <Widget>[
                                          Expanded(
                                              child: Slider(
                                                value: recipeStep.waitValue!.toDouble(),
                                                min: recipeStep.waitMin.toDouble(),
                                                max: recipeStep.waitMax.toDouble(),
                                                divisions: recipeStep.waitMax - recipeStep.waitMin,
                                                label: recipeStep.waitValue.toString(),
                                                onChanged: (newValue) => this.setState(() => recipeStep.waitValue = newValue.toInt()),
                                              )
                                          ),
                                          Container(
                                              width: 25,
                                              child: Text(recipeStep.waitValue.toString())
                                          )
                                        ]
                                    )
                                  ];
                                }).expand((option) => option).toList()
                            )
                          ]
                      )
                  ),
                  Divider(),
                  Spacer(),
                  SizedBox(
                      width: double.infinity,
                      height: 70,
                      child: Container(
                          color: Colors.blue,
                          child: TextButton(
                            child: Text("Review", style: TextStyle(color: Colors.white)),
                            onPressed: () async {
                              if (this.name.length == 0){
                                setState(() { this.nameValidation = true; });
                                return;
                              }
                              setState(() { this.nameValidation = false; });
                              FocusScope.of(context).unfocus();
                              DateTime? eventTime = await showDialog(
                                  context: context,
                                  builder: (context) {
                                    return ConfirmPizzaEventDialog(name: name, pizzaRecipe: this.widget.pizzaRecipe, pizzaCount: pizzaCount, doughBallSize: doughBallSize);
                                  }
                              );
                              if (eventTime == null){
                                return;
                              }

                              var pizzaEventsBox = Hive.box<PizzaEvent>("PizzaEvents");
                              PizzaEvent pizzaEvent = PizzaEvent(
                                  this.name,
                                  this.widget.pizzaRecipe,
                                  this.pizzaCount,
                                  this.doughBallSize,
                                  eventTime
                              );
                              await pizzaEventsBox.add(pizzaEvent);

                              pizzaEvent.createPizzaEventNotifications();

                              Navigator.pop(context);
                              Navigator.pop(context); // two times because of the pick recipe page
                            },
                          )
                      )
                  )
                ]
            )
        )
    );
  }
}

class ConfirmPizzaEventDialog extends StatefulWidget {
  final String name;
  final PizzaRecipe pizzaRecipe;
  final int pizzaCount;
  final int doughBallSize;

  const ConfirmPizzaEventDialog({Key? key,
      required this.name,
      required this.pizzaRecipe,
      required this.pizzaCount,
      required this.doughBallSize}
    ) : super(key: key);

  @override
  ConfirmPizzaEventState createState() => new ConfirmPizzaEventState();
}

class ConfirmPizzaEventState extends State<ConfirmPizzaEventDialog> {
  late DateTime eventTime;
  late final DateTime minTime;

  @override
  void initState() {
    super.initState();
    eventTime = DateTime.now().add(widget.pizzaRecipe.getCurrentDuration()).add(Duration(minutes: 1));
    minTime = DateTime.now().add(widget.pizzaRecipe.getCurrentDuration());
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      insetPadding: EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 30,
              child: Column(
                children: <Widget>[
                  Text(widget.name),
                  Divider(),
                  Text("Ingredients"),
                  widget.pizzaRecipe.getIngredientsTable(widget.pizzaCount, widget.doughBallSize),
                  Divider(),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                          color: Colors.blue,
                          child: TextButton(
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(FontAwesome5.calendar_alt, color: Colors.white),
                                    SizedBox(width: 10),
                                    Text(getDateFormat().format(this.eventTime), style: TextStyle(color: Colors.white, fontSize: 25)),
                                  ]
                              ),
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: minTime,
                                    currentTime: eventTime,
                                    maxTime: DateTime.now().add(Duration(days: 365*10)),
                                    onConfirm: (newEventTime) {
                                      setState((){ this.eventTime = newEventTime; });
                                    }
                                );
                              }
                          )
                      )
                  ),
                ]
              )
            ),
            Expanded(
                flex: 60,
                child: ListView(
                  children: <Widget>[
                    widget.pizzaRecipe.getStepTimeTable(eventTime)
                  ]
                )
            ),
            Expanded(
              flex: 10,
              child: SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Container(
                      color: Colors.blue,
                      child: TextButton(
                        child: Text("Confirm", style: TextStyle(color: Colors.white)),
                        onPressed: () async {
                          Navigator.pop(context, this.eventTime);
                        },
                      )
                  )
              )
            ),
          ]
        )
      )
    );
  }
}