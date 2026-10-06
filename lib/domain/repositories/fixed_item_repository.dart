import '../entities/fixed_item.dart';

abstract class FixedItemRepository {
  Future<List<FixedItem>> getAllFixedItems();
  Future<void> saveFixedItem(FixedItem item);
  Future<void> deleteFixedItem(String id);
  Future<void> saveAllFixedItems(List<FixedItem> items);
}
