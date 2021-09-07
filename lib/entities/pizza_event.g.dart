// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pizza_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PizzaEventAdapter extends TypeAdapter<PizzaEvent> {
  @override
  final int typeId = 4;

  @override
  PizzaEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PizzaEvent(
      fields[0] as String,
      fields[1] as PizzaRecipe,
      fields[2] as int,
      fields[3] as int,
      fields[4] as DateTime,
    )
      ..archived = fields[5] as bool
      ..deleted = fields[6] as bool;
  }

  @override
  void write(BinaryWriter writer, PizzaEvent obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.recipe)
      ..writeByte(2)
      ..write(obj.pizzaCount)
      ..writeByte(3)
      ..write(obj.doughBallSize)
      ..writeByte(4)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.archived)
      ..writeByte(6)
      ..write(obj.deleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PizzaEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
