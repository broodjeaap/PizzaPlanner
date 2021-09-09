import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pizzaplanner/entities/PizzaRecipe/pizza_recipe.dart';
import 'package:pizzaplanner/pages/nav_drawer.dart';
import 'package:pizzaplanner/pages/scaffold.dart';
import 'package:pizzaplanner/widgets/pizza_recipe_widget.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

  
class RecipesPage extends StatefulWidget {
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
                    valueListenable: Hive.box<PizzaRecipe>("PizzaRecipes").listenable(),
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
                              Navigator.pushNamed(context, "/recipe/view", arguments: pizzaRecipe);
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
                                          Navigator.pushNamed(context, "/recipe/view", arguments: pizzaRecipe);
                                        },
                                        child: const Text("View"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushNamed(context, "/recipes/edit", arguments: pizzaRecipe);
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
              Container(
                  color: Colors.blue,
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      Navigator.pushNamed(context, "/recipes/edit");
                    },
                    child: const Text("New Recipe", style: TextStyle(color: Colors.white)),
                  )
              ),
            ]
        ),
    );
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
    
    Share.shareFiles([recipeYamlPath], text: "${pizzaRecipe.name}");
  }
}