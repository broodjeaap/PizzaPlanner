import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/scaffold.dart';

import 'package:http/http.dart' as http;
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';

class AddRecipeURLPage extends StatefulWidget {
  final String? url;
  
  const AddRecipeURLPage(this.url);
  
  @override
  AddRecipeURLPageState createState() => AddRecipeURLPageState();
}

class AddRecipeURLPageState extends State<AddRecipeURLPage> {
  String? url;
  String tempUrl = "?";
  List<Widget> itemList = <Widget>[];
  
  @override
  void initState() {
    super.initState();
    url = widget.url;
  }
  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: const Text("Fetch Pizza Recipe"),
        body: Column(
          children: <Widget>[
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: () async {
                    showDialog(context: context, builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("URL"),
                        content: TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Recipe URL",
                          ),
                          initialValue: url ?? "",
                          onChanged: (String newUrl) {
                            setState(() {
                              tempUrl = newUrl;
                            });
                          },
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              url = tempUrl;
                              setState(() {
                                fetchUrl();
                              });
                            },
                            child: const Text("Fetch"),
                          ),
                        ],
                      );
                    });
                  },
                  child: Text(url ?? "?"),
              ),
            ),
            Expanded(
              flex: 45,
              child: ListView(
                children: itemList,
              )
            )
          ]
        )
    );
  }
  
  Future<void> fetchUrl() async {
    if (url == null){
      return;
    }
    final uri = Uri.parse(url!);
    if (!uri.isAbsolute){
      return;
    }
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        return;
      }
      
      final yamlBody = response.body;
      final pizzaRecipe = await PizzaRecipe.fromYaml(yamlBody);
            
      
      itemList.clear();
      itemList.add(
        InkWell(
          onTap: () {
            showDialog(context: context, builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(pizzaRecipe.name),
                  content: const Text("What do you want to do?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, "/recipe/view", arguments: pizzaRecipe);
                      },
                      child: const Text("View"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        addPizzaRecipeToBox(pizzaRecipe);
                      },
                      child: const Text("Add"),
                    ),
                  ]
              );
            });
          },
          child: PizzaRecipeWidget(pizzaRecipe),
        )
      );
    } catch (exception) {
      print(exception);
      return;
    }
  }
  
  Future<void> addPizzaRecipeToBox(PizzaRecipe pizzaRecipe) async {
    final pizzaRecipeBox = Hive.box<PizzaRecipe>("PizzaRecipes");
    if (pizzaRecipeBox.containsKey(pizzaRecipe.key)) {
      return; // this recipe is already in the box
    }
    setState(() {
      pizzaRecipeBox.add(pizzaRecipe);
    });
  }
}