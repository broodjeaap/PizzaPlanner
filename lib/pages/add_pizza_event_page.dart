
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttericon/font_awesome5_icons.dart';

import 'package:pizzaplanner/entities/pizza_event.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/util.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddPizzaEventPage extends StatefulWidget {
  static const String route = "/event/add";
  final PizzaRecipe pizzaRecipe;

  const AddPizzaEventPage(this.pizzaRecipe);

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
    return PizzaPlannerScaffold(
        title: const Text("Add Pizza Event"),
        body: Column(
            children: <Widget>[
              Expanded(
                  flex: 40,
                  child: Column(
                      children: <Widget>[
                        Row(
                            children: <Widget>[
                              const Icon(Icons.title),
                              Container(width: 25),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      hintText: "Event Name",
                                      errorText: nameValidation ? """Name can't be empty""" : null
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
                              const Icon(FontAwesome5.hashtag),
                              Expanded(
                                  child: Slider(

                                    value: pizzaCount.toDouble(),
                                    min: 1,
                                    max: 20,
                                    divisions: 19,
                                    label: pizzaCount.toString(),
                                    onChanged: (double newPizzaCount) {
                                      setState(() {pizzaCount = newPizzaCount.round();});
                                    },
                                  )
                              ),
                              SizedBox(
                                  width: 25,
                                  child: Text(pizzaCount.toString())
                              )
                            ]
                        ),
                        Row(
                            children: <Widget>[
                              const Icon(FontAwesome5.weight_hanging),
                              Expanded(
                                  child: Slider(
                                    value: doughBallSize.toDouble(),
                                    min: 100,
                                    max: 400,
                                    divisions: 30,
                                    label: doughBallSize.toString(),
                                    onChanged: (double newDoughBallSize) {
                                      setState(() {doughBallSize = newDoughBallSize.round();});
                                    },
                                  )
                              ),
                              SizedBox(
                                  width: 25,
                                  child: Text(doughBallSize.toString())
                              )
                            ]
                        ),
                        widget.pizzaRecipe.getIngredientsTable(pizzaCount, doughBallSize),
                      ]
                  )
              ),
              const Divider(),
              Expanded(
                  flex: 45,
                  child: ListView(
                      children: <Widget>[
                        Column(
                            children: widget.pizzaRecipe.recipeSteps.where((recipeStep) => recipeStep.waitDescription.isNotEmpty).map((recipeStep) {
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
                                            onChanged: (newValue) => setState(() => recipeStep.waitValue = newValue.toInt()),
                                          )
                                      ),
                                      SizedBox(
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
              const Divider(),
              const Spacer(),
              SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Container(
                      color: Colors.blue,
                      child: TextButton(
                        onPressed: () async {

                          if (name.isEmpty){
                            setState(() { nameValidation = true; });
                            return;
                          }
                          setState(() { nameValidation = false; });
                          FocusScope.of(context).unfocus();
                          DateTime? eventTime = await showDialog(
                              context: context,
                              builder: (context) {
                                return ConfirmPizzaEventDialog(name: name, pizzaRecipe: widget.pizzaRecipe, pizzaCount: pizzaCount, doughBallSize: doughBallSize);
                              }
                          );
                          if (eventTime == null){
                            return;
                          }

                          // if the user waited to long on the confirmation dialog that the first step time is now in the past
                          final durationUntilFirstStep = Duration(seconds: widget.pizzaRecipe.getCurrentDuration().inSeconds);
                          final firstStepDateTime = eventTime.subtract(durationUntilFirstStep);
                          if (firstStepDateTime.isBefore(DateTime.now())){
                            eventTime = DateTime.now()
                                .add(durationUntilFirstStep)
                                .add(const Duration(minutes: 1));
                          }

                          final pizzaEventsBox = Hive.box<PizzaEvent>("PizzaEvents");
                          final PizzaEvent pizzaEvent = PizzaEvent(
                              name,
                              widget.pizzaRecipe,
                              pizzaCount,
                              doughBallSize,
                              eventTime
                          );
                          await pizzaEventsBox.add(pizzaEvent);

                          pizzaEvent.createPizzaEventNotifications();

                          if(!mounted) {
                            return;  //https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html
                          }
                          Navigator.of(context).pop();
                          Navigator.of(context).pop(); // two times because of the pick recipe page
                        },
                        child: const Text("Review", style: TextStyle(color: Colors.white)),
                      )
                  )
              )
            ]
        ),
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
  ConfirmPizzaEventState createState() => ConfirmPizzaEventState();
}

class ConfirmPizzaEventState extends State<ConfirmPizzaEventDialog> {
  late DateTime eventTime;
  late final DateTime minTime;

  @override
  void initState() {
    super.initState();
    eventTime = DateTime.now().add(widget.pizzaRecipe.getCurrentDuration()).add(const Duration(minutes: 1));
    minTime = DateTime.now().add(widget.pizzaRecipe.getCurrentDuration());
  }

  @override
  Widget build(BuildContext context){
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Column(
                children: <Widget>[
                  Text(widget.name),
                  const Divider(),
                  SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Container(
                          color: Colors.blue,
                          child: TextButton(
                              onPressed: () {
                                DatePicker.showDateTimePicker(context,
                                    minTime: minTime,
                                    currentTime: eventTime,
                                    maxTime: DateTime.now().add(const Duration(days: 365*10)),
                                    onConfirm: (newEventTime) {
                                      setState((){ eventTime = newEventTime; });
                                    }
                                );
                              },
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Icon(FontAwesome5.calendar_alt, color: Colors.white),
                                    const SizedBox(width: 10),
                                    Text(getDateFormat().format(eventTime), style: const TextStyle(color: Colors.white, fontSize: 25)),
                                  ]
                              )
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
                        onPressed: () async {
                          Navigator.pop(context, eventTime);
                        },
                        child: const Text("Confirm", style: TextStyle(color: Colors.white)),
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