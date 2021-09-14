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
  final ValueNotifier<List<Widget>> itemListNotifier = ValueNotifier(<Widget>[]);
  
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
                child: Container(
                  color: Colors.blue,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      await showDialog(context: context, builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("URL"),
                          content: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Recipe URL",
                            ),
                            initialValue: url ?? "",
                            onChanged: (String newUrl) {
                              tempUrl = newUrl;
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
                              onPressed: () async {
                                Navigator.pop(context);
                                url = tempUrl;
                                fetchUrl();
                              },
                              child: const Text("Fetch"),
                            ),
                          ],
                        );
                      }).then((_) {
                        setState(() {});
                      });
                    },
                    child: Text(url ?? "Tap to load URL", style: const TextStyle(color: Colors.white)),
                  ),
                ),
            ),
            const Divider(),
            Expanded(
              flex: 45,
              child: ValueListenableBuilder<List<Widget>>(
                valueListenable: itemListNotifier,
                builder: (BuildContext context, List<Widget> widgets, Widget? child) {
                  print("test");
                  return ListView(
                    children: widgets
                  );
                }
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
      if (!(yamlBody.startsWith("recipe:") || yamlBody.startsWith("recipes"))){
        return;
      }
      final pizzaRecipe = await PizzaRecipe.fromYaml(yamlBody);
      
      itemListNotifier.value.clear();
      itemListNotifier.value = <Widget>[ // inefficient probably but otherwise it doesn't trigger notify...
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
      ];
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