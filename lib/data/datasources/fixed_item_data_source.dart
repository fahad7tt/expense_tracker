import 'package:hive_flutter/hive_flutter.dart';
import '../models/fixed_item_model.dart';

abstract class FixedItemLocalDataSource {
  Future<List<FixedItemModel>> getAllFixedItems();
  Future<void> saveFixedItem(FixedItemModel item);
  Future<void> deleteFixedItem(String id);
  Future<void> saveAllFixedItems(List<FixedItemModel> items);
}

class FixedItemLocalDataSourceImpl implements FixedItemLocalDataSource {
  final Box<FixedItemModel> fixedItemBox;

  FixedItemLocalDataSourceImpl(this.fixedItemBox);

  @override
  Future<List<FixedItemModel>> getAllFixedItems() async {
    return fixedItemBox.values.toList();
  }

  @override
  Future<void> saveFixedItem(FixedItemModel item) async {
    await fixedItemBox.put(item.id, item);
  }

  @override
  Future<void> deleteFixedItem(String id) async {
    await fixedItemBox.delete(id);
  }

  @override
  Future<void> saveAllFixedItems(List<FixedItemModel> items) async {
    final map = {for (var item in items) item.id: item};
    await fixedItemBox.putAll(map);
  }
}
