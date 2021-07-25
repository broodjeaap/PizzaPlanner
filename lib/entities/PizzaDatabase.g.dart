// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PizzaDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorPizzaDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PizzaDatabaseBuilder databaseBuilder(String name) =>
      _$PizzaDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$PizzaDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$PizzaDatabaseBuilder(null);
}

class _$PizzaDatabaseBuilder {
  _$PizzaDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$PizzaDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$PizzaDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<PizzaDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$PizzaDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$PizzaDatabase extends PizzaDatabase {
  _$PizzaDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  PizzaEventDoa? _pizzaEventDoaInstance;

  PizzaRecipeDao? _pizzaRecipeDaoInstance;

  RecipeStepDao? _recipeStepDaoInstance;

  RecipeSubStepDao? _recipeSubStepDaoInstance;

  IngredientDao? _ingredientDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PizzaEvent` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `recipeId` INTEGER NOT NULL, `pizzaCount` INTEGER NOT NULL, `doughBallSize` INTEGER NOT NULL, `dateTime` INTEGER NOT NULL, FOREIGN KEY (`recipeId`) REFERENCES `PizzaRecipe` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `PizzaRecipe` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `description` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecipeStep` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `pizzaRecipeId` INTEGER NOT NULL, `name` TEXT NOT NULL, `waitDescription` TEXT NOT NULL, `waitUnit` TEXT NOT NULL, `waitMin` INTEGER NOT NULL, `waitMax` INTEGER NOT NULL, `waitValue` INTEGER NOT NULL, `description` TEXT NOT NULL, FOREIGN KEY (`pizzaRecipeId`) REFERENCES `PizzaRecipe` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `RecipeSubStep` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `recipeStepId` INTEGER NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, FOREIGN KEY (`recipeStepId`) REFERENCES `RecipeStep` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Ingredient` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `pizzaRecipeId` INTEGER NOT NULL, `name` TEXT NOT NULL, `unit` TEXT NOT NULL, `value` REAL NOT NULL, FOREIGN KEY (`pizzaRecipeId`) REFERENCES `PizzaRecipe` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  PizzaEventDoa get pizzaEventDoa {
    return _pizzaEventDoaInstance ??= _$PizzaEventDoa(database, changeListener);
  }

  @override
  PizzaRecipeDao get pizzaRecipeDao {
    return _pizzaRecipeDaoInstance ??=
        _$PizzaRecipeDao(database, changeListener);
  }

  @override
  RecipeStepDao get recipeStepDao {
    return _recipeStepDaoInstance ??= _$RecipeStepDao(database, changeListener);
  }

  @override
  RecipeSubStepDao get recipeSubStepDao {
    return _recipeSubStepDaoInstance ??=
        _$RecipeSubStepDao(database, changeListener);
  }

  @override
  IngredientDao get ingredientDao {
    return _ingredientDaoInstance ??= _$IngredientDao(database, changeListener);
  }
}

class _$PizzaEventDoa extends PizzaEventDoa {
  _$PizzaEventDoa(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _pizzaEventInsertionAdapter = InsertionAdapter(
            database,
            'PizzaEvent',
            (PizzaEvent item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'recipeId': item.recipeId,
                  'pizzaCount': item.pizzaCount,
                  'doughBallSize': item.doughBallSize,
                  'dateTime': _dateTimeConverter.encode(item.dateTime)
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PizzaEvent> _pizzaEventInsertionAdapter;

  @override
  Future<List<PizzaEvent>> getAllPizzaEvents() async {
    return _queryAdapter.queryList('SELECT * FROM PizzaEvent',
        mapper: (Map<String, Object?> row) => PizzaEvent(
            row['recipeId'] as int,
            row['name'] as String,
            row['pizzaCount'] as int,
            row['doughBallSize'] as int,
            _dateTimeConverter.decode(row['dateTime'] as int),
            id: row['id'] as int?));
  }

  @override
  Stream<PizzaEvent?> findPizzaEventById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM PizzaEvent WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PizzaEvent(
            row['recipeId'] as int,
            row['name'] as String,
            row['pizzaCount'] as int,
            row['doughBallSize'] as int,
            _dateTimeConverter.decode(row['dateTime'] as int),
            id: row['id'] as int?),
        arguments: [id],
        queryableName: 'PizzaEvent',
        isView: false);
  }

  @override
  Future<void> insertPizzaEvent(PizzaEvent pizzaEvent) async {
    await _pizzaEventInsertionAdapter.insert(
        pizzaEvent, OnConflictStrategy.abort);
  }
}

class _$PizzaRecipeDao extends PizzaRecipeDao {
  _$PizzaRecipeDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _pizzaRecipeInsertionAdapter = InsertionAdapter(
            database,
            'PizzaRecipe',
            (PizzaRecipe item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<PizzaRecipe> _pizzaRecipeInsertionAdapter;

  @override
  Future<List<PizzaRecipe>> getAllPizzaRecipes() async {
    return _queryAdapter.queryList('SELECT * FROM PizzaRecipe',
        mapper: (Map<String, Object?> row) => PizzaRecipe(
            row['name'] as String, row['description'] as String,
            id: row['id'] as int?));
  }

  @override
  Stream<PizzaRecipe?> findPizzaRecipeById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM PizzaRecipe WHERE id = ?1',
        mapper: (Map<String, Object?> row) => PizzaRecipe(
            row['name'] as String, row['description'] as String,
            id: row['id'] as int?),
        arguments: [id],
        queryableName: 'PizzaRecipe',
        isView: false);
  }

  @override
  Future<void> insertPizzaRecipe(PizzaRecipe pizzaRecipe) async {
    await _pizzaRecipeInsertionAdapter.insert(
        pizzaRecipe, OnConflictStrategy.abort);
  }
}

class _$RecipeStepDao extends RecipeStepDao {
  _$RecipeStepDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _recipeStepInsertionAdapter = InsertionAdapter(
            database,
            'RecipeStep',
            (RecipeStep item) => <String, Object?>{
                  'id': item.id,
                  'pizzaRecipeId': item.pizzaRecipeId,
                  'name': item.name,
                  'waitDescription': item.waitDescription,
                  'waitUnit': item.waitUnit,
                  'waitMin': item.waitMin,
                  'waitMax': item.waitMax,
                  'waitValue': item.waitValue,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecipeStep> _recipeStepInsertionAdapter;

  @override
  Future<List<RecipeStep>> getAllRecipeSteps() async {
    return _queryAdapter.queryList('SELECT * FROM RecipeStep',
        mapper: (Map<String, Object?> row) => RecipeStep(
            row['pizzaRecipeId'] as int,
            row['name'] as String,
            row['description'] as String,
            row['waitDescription'] as String,
            row['waitUnit'] as String,
            row['waitMin'] as int,
            row['waitMax'] as int,
            id: row['id'] as int?));
  }

  @override
  Stream<RecipeStep?> findRecipeStepById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM RecipeStep WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RecipeStep(
            row['pizzaRecipeId'] as int,
            row['name'] as String,
            row['description'] as String,
            row['waitDescription'] as String,
            row['waitUnit'] as String,
            row['waitMin'] as int,
            row['waitMax'] as int,
            id: row['id'] as int?),
        arguments: [id],
        queryableName: 'RecipeStep',
        isView: false);
  }

  @override
  Future<List<RecipeStep>> getPizzaRecipeSteps(int pizzaRecipeId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RecipeStep WHERE pizzaRecipeId = ?1',
        mapper: (Map<String, Object?> row) => RecipeStep(
            row['pizzaRecipeId'] as int,
            row['name'] as String,
            row['description'] as String,
            row['waitDescription'] as String,
            row['waitUnit'] as String,
            row['waitMin'] as int,
            row['waitMax'] as int,
            id: row['id'] as int?),
        arguments: [pizzaRecipeId]);
  }

  @override
  Future<void> insertRecipeStep(RecipeStep recipeStep) async {
    await _recipeStepInsertionAdapter.insert(
        recipeStep, OnConflictStrategy.abort);
  }
}

class _$RecipeSubStepDao extends RecipeSubStepDao {
  _$RecipeSubStepDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _recipeSubStepInsertionAdapter = InsertionAdapter(
            database,
            'RecipeSubStep',
            (RecipeSubStep item) => <String, Object?>{
                  'id': item.id,
                  'recipeStepId': item.recipeStepId,
                  'name': item.name,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<RecipeSubStep> _recipeSubStepInsertionAdapter;

  @override
  Future<List<RecipeSubStep>> getAllRecipeSubSteps() async {
    return _queryAdapter.queryList('SELECT * FROM RecipeSubStep',
        mapper: (Map<String, Object?> row) => RecipeSubStep(
            row['recipeStepId'] as int,
            row['name'] as String,
            row['description'] as String,
            id: row['id'] as int?));
  }

  @override
  Stream<RecipeSubStep?> findRecipeSubStepById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM RecipeSubStep WHERE id = ?1',
        mapper: (Map<String, Object?> row) => RecipeSubStep(
            row['recipeStepId'] as int,
            row['name'] as String,
            row['description'] as String,
            id: row['id'] as int?),
        arguments: [id],
        queryableName: 'RecipeSubStep',
        isView: false);
  }

  @override
  Future<List<RecipeSubStep>> getRecipeStepSubSteps(int recipeStepId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM RecipeStep WHERE recipeStepId = ?1',
        mapper: (Map<String, Object?> row) => RecipeSubStep(
            row['recipeStepId'] as int,
            row['name'] as String,
            row['description'] as String,
            id: row['id'] as int?),
        arguments: [recipeStepId]);
  }

  @override
  Future<void> insertRecipeSubStep(RecipeSubStep recipeSubStep) async {
    await _recipeSubStepInsertionAdapter.insert(
        recipeSubStep, OnConflictStrategy.abort);
  }
}

class _$IngredientDao extends IngredientDao {
  _$IngredientDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _ingredientInsertionAdapter = InsertionAdapter(
            database,
            'Ingredient',
            (Ingredient item) => <String, Object?>{
                  'id': item.id,
                  'pizzaRecipeId': item.pizzaRecipeId,
                  'name': item.name,
                  'unit': item.unit,
                  'value': item.value
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Ingredient> _ingredientInsertionAdapter;

  @override
  Future<List<Ingredient>> getAllIngredients() async {
    return _queryAdapter.queryList('SELECT * FROM Ingredient',
        mapper: (Map<String, Object?> row) => Ingredient(
            row['pizzaRecipeId'] as int,
            row['name'] as String,
            row['unit'] as String,
            row['value'] as double,
            id: row['id'] as int?));
  }

  @override
  Stream<Ingredient?> findIngredientById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Ingredient WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Ingredient(
            row['pizzaRecipeId'] as int,
            row['name'] as String,
            row['unit'] as String,
            row['value'] as double,
            id: row['id'] as int?),
        arguments: [id],
        queryableName: 'Ingredient',
        isView: false);
  }

  @override
  Future<List<Ingredient>> getPizzaRecipeIngredients(int pizzaRecipeId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Ingredient WHERE pizzaRecipeId = ?1',
        mapper: (Map<String, Object?> row) => Ingredient(
            row['pizzaRecipeId'] as int,
            row['name'] as String,
            row['unit'] as String,
            row['value'] as double,
            id: row['id'] as int?),
        arguments: [pizzaRecipeId]);
  }

  @override
  Future<void> insertIngredient(Ingredient ingredient) async {
    await _ingredientInsertionAdapter.insert(
        ingredient, OnConflictStrategy.abort);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
