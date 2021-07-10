import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:intl/intl.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/PizzaRecipe.dart';
import 'package:pizzaplanner/util.dart';

class AddPizzaEventPage extends StatefulWidget {
  @override
  AddPizzaEventPageState createState() => AddPizzaEventPageState();
}

class AddPizzaEventPageState extends State<AddPizzaEventPage> {
  final DateFormat dateFormatter = DateFormat("yyyy-MM-dd hh:mm");

  String name = "";
  bool initialized = false;
  late PizzaRecipe pizzaRecipe;
  late List<PizzaRecipe> pizzaTypes;
  int pizzaCount = 1;
  int doughBallSize = 250;
  DateTime eventTime = DateTime.now();

  bool nameValidation = false;

  @override
  void initState() {
    super.initState();
    getRecipes().then((pTypes) {
      this.pizzaTypes = pTypes;
      this.pizzaRecipe = this.pizzaTypes.first;
      setState(() {this.initialized = true;});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Pizza Event"),
        ),
        body: Container(
            padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
            child:  Column(
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
                      Icon(FontAwesome5.pizza_slice),
                      Container(width: 25),
                      Expanded(
                        child: this.initialized ? // Only render the dropdown if the recipes have been loaded from storage
                          DropdownButton<String>(
                              value: this.pizzaRecipe.name,
                              onChanged: (String? newType) {
                                setState(() => this.pizzaRecipe = this.pizzaTypes.firstWhere((pizzaRecipe) => pizzaRecipe.name == newType));
                              },
                              items: this.pizzaTypes.map((pizzaRecipe) {
                                return DropdownMenuItem(
                                  value: pizzaRecipe.name,
                                  child: Text(pizzaRecipe.name)
                                );
                              }).toList()
                          ) : CircularProgressIndicator()
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
                Row(
                    children: <Widget>[
                      Icon(FontAwesome5.calendar_alt),
                      Expanded(
                          child: InkWell(
                              child: Center(
                                child: Text(dateFormatter.format(this.eventTime)),
                              ),
                              onTap: () {
                                DatePicker.showDateTimePicker(context,
                                    showTitleActions: true,
                                    minTime: DateTime.now(),
                                    currentTime: this.eventTime.difference(DateTime.now()).isNegative ? DateTime.now() : this.eventTime,
                                    maxTime: DateTime.now().add(Duration(days: 365*10)),
                                    onConfirm: (newEventTime) {
                                      setState((){ this.eventTime = newEventTime; });
                                    }
                                );
                              }
                          )
                      )
                    ]
                ),
                Divider(),
                this.initialized ? this.pizzaRecipe.getIngredientsWidget(this.doughBallSize * this.pizzaCount) : Container(),
                Spacer(),
                SizedBox(
                    width: double.infinity,
                    height: 70,
                    child: Container(
                        color: Colors.blue,
                        child: TextButton(
                          child: Text("Add", style: TextStyle(color: Colors.white)),
                          onPressed: () {
                            if (this.name.length == 0){
                              setState(() { this.nameValidation = true; });
                              return;
                            }
                            Navigator.pop(context, PizzaEvent(
                                this.name,
                                this.pizzaRecipe,
                                this.pizzaCount,
                                this.doughBallSize,
                                this.eventTime
                            ));
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