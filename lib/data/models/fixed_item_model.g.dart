// GENERATED CODE - MANUAL HIVE ADAPTER FOR FIXED ITEM MODEL

part of 'fixed_item_model.dart';

class FixedItemModelAdapter extends TypeAdapter<FixedItemModel> {
  @override
  final int typeId = 2;

  @override
  FixedItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FixedItemModel(
      id: fields[0] as String,
      title: fields[1] as String,
      amount: fields[2] as double,
      isIncome: fields[3] as bool,
      category: fields[4] as String?,
      currency: fields[5] as String?,
      isActive: fields[6] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FixedItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.isIncome)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.currency)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FixedItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
