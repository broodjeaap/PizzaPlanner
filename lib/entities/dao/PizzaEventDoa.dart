import 'package:floor/floor.dart';
import 'package:pizzaplanner/entities/PizzaEvent.dart';

@dao
abstract class PizzaEventDoa {
  @Query("SELECT * FROM PizzaEvent")
  Future<List<PizzaEvent>> getAllPizzaEvents();

  @Query("SELECT * FROM PizzaEvent WHERE id = :id")
  Stream<PizzaEvent?> findPizzaEventById(int id);

  @insert
  Future<void> insertPizzaEvent(PizzaEvent pizzaEvent);
}