import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/add_recipe_url.dart';
import 'package:pizzaplanner/pages/edit_recipe_page.dart';
import 'package:pizzaplanner/pages/recipe_page.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

  
class RecipesPage extends StatefulWidget {
  static const String route = "/recipes/view";
  @override
  RecipesPageState createState() => RecipesPageState();
}

class RecipesPageState extends State<RecipesPage> {
  String searchText = "";
  
  @override
  Widget build(BuildContext context){
    return PizzaPlannerScaffold(
        title: const Text("Pizza Recipes"),
        body: Column(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: TextFormField(
                    decoration: const InputDecoration(
                        hintText: "Search Recipes",
                    ),
                    initialValue: searchText,
                    onChanged: (String newSearch) {
                      setState(() {
                        searchText = newSearch;
                      });
                    },
                  ),
              ),
              const Divider(),
              const Center(child: Text("Long press to edit")),
              const Divider(),
              Expanded(
                flex: 50,
                child: ValueListenableBuilder(
                    valueListenable: Hive.box<PizzaRecipe>(PizzaRecipe.hiveName).listenable(),
                    builder: (context, Box<PizzaRecipe> pizzaRecipesBox, widget) {
                      return ListView.separated(
                        itemCount: pizzaRecipesBox.length,
                        itemBuilder: (context, i) {
                          final pizzaRecipe = pizzaRecipesBox.get(i);
                          if (
                              pizzaRecipe == null ||
                              pizzaRecipe.deleted ||
                              (searchText.isNotEmpty && !pizzaRecipe.name.toLowerCase().contains(searchText))){
                            return const SizedBox();
                          }
                          return InkWell(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              Navigator.pushNamed(context, RecipePage.route, arguments: pizzaRecipe);
                            },
                            onLongPress: () {
                              FocusScope.of(context).unfocus();
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text(pizzaRecipe.name),
                                    content: const Text("What do you want to do?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          sharePizzaRecipe(pizzaRecipe);
                                        },
                                        child: const Text("Share"),
                                      ),
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
                                          Navigator.pushNamed(context, EditRecipePage.route, arguments: pizzaRecipe);
                                        },
                                        child: const Text("Edit"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          showDialog(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                                title: const Text("Delete?"),
                                                content: const Text("Are you sure?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Back"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (pizzaRecipe.isInBox){
                                                        pizzaRecipe.deleted = true;
                                                        pizzaRecipe.save();
                                                      }
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                                                  ),
                                                ]
                                            );
                                          });
                                        },
                                        child: const Text("Delete", style: TextStyle(color: Colors.redAccent)),
                                      ),
                                    ]
                                );
                              });
                            },
                            child: PizzaRecipeWidget(pizzaRecipe),
                          );
                        },
                        separatorBuilder: (BuildContext context, int i) {
                          final pizzaRecipe = pizzaRecipesBox.get(i);
                          if (
                            pizzaRecipe == null || 
                            pizzaRecipe.deleted || 
                            (searchText.isNotEmpty && !pizzaRecipe.name.toLowerCase().contains(searchText))){
                            return const SizedBox();
                          }
                          return const Divider(); 
                        },
                      );
                    }
                ),
              ),
              const Divider(),
              Expanded(
                flex: 5,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                          color: Theme.of(context).buttonColor,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();
                              showDialog(context: context, builder: (BuildContext context) {
                                return AlertDialog(
                                    title: const Text("Source"),
                                    content: const Text("Add from a local file or from an URL?"),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          loadLocalRecipe();
                                        },
                                        child: const Text("Local"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, AddRecipeURLPage.route);
                                        },
                                        child: const Text("URL"),
                                      )
                                    ]
                                );
                              });
                              
                            },
                            child: const Text("Load Recipe", style: TextStyle(color: Colors.white)),
                          )
                      ),
                    ),
                    const Expanded(
                      flex: 1,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 5,
                      child: Container(
                          color: Theme.of(context).buttonColor,
                          width: double.infinity,
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pushNamed(context, EditRecipePage.route);
                            },
                            child: const Text("New Recipe", style: TextStyle(color: Colors.white)),
                          )
                      ),
                    )
                  ],
                )
              ),
            ]
        ),
    );
  }
  
  Future<void> loadLocalRecipe() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null){
      return;
    }
    
    try {
      File(result.files.single.path).readAsString().then((String contents) async {
        final pizzaRecipe = await PizzaRecipe.fromYaml(contents);
        final pizzaRecipeBox = Hive.box<PizzaRecipe>(PizzaRecipe.hiveName);
        pizzaRecipeBox.add(pizzaRecipe);
      });
    } catch (exception) {
      print(exception);
    }
  }
  
  Future<void> sharePizzaRecipe(PizzaRecipe pizzaRecipe) async{
    final tempDir = await getTemporaryDirectory();
    final recipeName = pizzaRecipe.name.replaceAll(RegExp(r"\s+"), "");
    final recipeYamlPath = path.join(
        tempDir.absolute.path,
        "$recipeName.pizza"
    );
    
    final recipeYamlHandle = File(recipeYamlPath);
    
    await recipeYamlHandle.writeAsString(pizzaRecipe.toYaml());
    
    Share.shareFiles([recipeYamlPath], text: pizzaRecipe.name);
  }
}