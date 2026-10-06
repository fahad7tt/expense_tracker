import '../../domain/entities/fixed_item.dart';
import '../../domain/repositories/fixed_item_repository.dart';
import '../datasources/fixed_item_data_source.dart';
import '../models/fixed_item_model.dart';

class FixedItemRepositoryImpl implements FixedItemRepository {
  final FixedItemLocalDataSource dataSource;

  FixedItemRepositoryImpl(this.dataSource);

  @override
  Future<List<FixedItem>> getAllFixedItems() async {
    final models = await dataSource.getAllFixedItems();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveFixedItem(FixedItem item) async {
    await dataSource.saveFixedItem(FixedItemModel.fromEntity(item));
  }

  @override
  Future<void> deleteFixedItem(String id) async {
    await dataSource.deleteFixedItem(id);
  }

  @override
  Future<void> saveAllFixedItems(List<FixedItem> items) async {
    final models = items.map((i) => FixedItemModel.fromEntity(i)).toList();
    await dataSource.saveAllFixedItems(models);
  }
}
