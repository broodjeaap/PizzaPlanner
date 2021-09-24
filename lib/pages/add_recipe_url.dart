import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/recipe_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';

import 'package:http/http.dart' as http;
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';
import 'package:yaml/yaml.dart';

class AddRecipeURLPage extends StatefulWidget {
  static const String route = "/recipes/add/url";
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
    if (url != null){
      fetchUrl(url!).then((widgets) => itemListNotifier.value = widgets);
    }
    
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
                                if (url == null){
                                  return;
                                }
                                itemListNotifier.value = await fetchUrl(url!);
                                
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
  
  Future<List<Widget>> fetchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!uri.isAbsolute){
      return const [];
    }
    try {
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        return const [];
      }
      
      final yamlBody = response.body;
      if (!(yamlBody.startsWith("recipe:") || yamlBody.startsWith("recipes:"))){
        return const [];
      }
      if (yamlBody.startsWith("recipe:")){
        return await singleRecipe(yamlBody);
      }
      if (yamlBody.startsWith("recipes:")){
        return await recipeDir(yamlBody);
      }      
    } catch (exception) {
      print(exception);
    }
    return const [];
  }
  
  Future<List<Widget>> recipeDir(String yamlBody) async {
    final yaml = loadYaml(yamlBody);
    final urls = yaml["recipes"] as YamlList;
    final widgets = <Widget>[];
    for (final item in urls) {
      try {
        final name = item["name"] as String;
        final url = item["url"] as String;
        widgets.add(
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AddRecipeURLPage.route, arguments: url);
              },
              child: Container(
                  height: 70,
                  width: double.infinity,
                  color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(name, style: const TextStyle(color: Colors.white)),
                      ),
                      const Divider(),
                      Center(
                        child: Text(url, style: const TextStyle(color: Colors.white)),
                      ),
                    ],
                  )
              ),
            )
        );
        widgets.add(const Divider());
      } catch (exception){
        print(exception);
      }
      
    }
    return widgets; 
  }
  
  Future<List<Widget>> singleRecipe(String yamlBody) async {
    final pizzaRecipe = await PizzaRecipe.fromYaml(yamlBody);
    return <Widget>[
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
                      Navigator.pushNamed(context, RecipePage.route, arguments: pizzaRecipe);
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