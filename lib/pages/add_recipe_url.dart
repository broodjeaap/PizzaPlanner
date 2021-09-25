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
  static const String initialUrl = "https://raw.githubusercontent.com/broodjeaap/PizzaRecipes/master/index.yaml";
  
  const AddRecipeURLPage(this.url);
  
  @override
  AddRecipeURLPageState createState() => AddRecipeURLPageState();
}

class AddRecipeURLPageState extends State<AddRecipeURLPage> {
  String? url;
  late String tempUrl;
  final ValueNotifier<List<Widget>> itemListNotifier = ValueNotifier(<Widget>[]);
  
  @override
  void initState() {
    super.initState();
    url = widget.url;
    if (url != null){
      fetchUrl(url!).then((widgets) => itemListNotifier.value = widgets);
    }
    tempUrl = url ?? AddRecipeURLPage.initialUrl;
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
                  color: Theme.of(context).buttonColor,
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
                            initialValue: url ?? AddRecipeURLPage.initialUrl,
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
        try {
          return await recipeDir(yamlBody);
        } catch (exception){
          return const <Widget>[
            Text(
              "Failed to load",
            )
          ];
        }
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
        final itemMap = item as YamlMap;
        if (itemMap.containsKey("url")){ // Dir item
          widgets.add(buildDirWidget(itemMap));
        } else { // recipe item
          widgets.add(await buildRecipeWidget(itemMap));
        }
        widgets.add(const Divider());
      } catch (exception){
        widgets.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Failed to load",
                style: Theme.of(context).textTheme.subtitle2
              )
            ],
          )
        );
      }
    }
    return widgets; 
  }
  
  Widget buildDirWidget(YamlMap itemMap){
    final name = itemMap["name"] as String;
    final url = itemMap["url"] as String;
    return InkWell(
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
    );
  }
  
  Future<Widget> buildRecipeWidget(YamlMap itemMap) async {
    final pizzaRecipe = await PizzaRecipe.fromParsedYaml(itemMap);
    return InkWell(
      onTap: () {
        showDialog(context: context, builder: (BuildContext context) {
          return buildRecipeDialog(pizzaRecipe);
        });
      },
      child: PizzaRecipeWidget(pizzaRecipe),
    );
  }
  
  Future<List<Widget>> singleRecipe(String yamlBody) async {
    final pizzaRecipe = await PizzaRecipe.fromYaml(yamlBody);
    return <Widget>[
      InkWell(
        onTap: () {
          showDialog(context: context, builder: (BuildContext context) {
            return buildRecipeDialog(pizzaRecipe);
          });
        },
        child: PizzaRecipeWidget(pizzaRecipe),
      )
    ];
  }
  
  AlertDialog buildRecipeDialog(PizzaRecipe pizzaRecipe){
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
  }
  
  Future<void> addPizzaRecipeToBox(PizzaRecipe pizzaRecipe) async {
    final pizzaRecipeBox = Hive.box<PizzaRecipe>(PizzaRecipe.hiveName);
    if (pizzaRecipeBox.containsKey(pizzaRecipe.key)) {
      return; // this recipe is already in the box
    }
    setState(() {
      pizzaRecipeBox.add(pizzaRecipe);
    });
  }
}