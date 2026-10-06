import '../entities/fixed_item.dart';
import '../repositories/fixed_item_repository.dart';

class GetFixedItems {
  final FixedItemRepository repository;
  GetFixedItems(this.repository);

  Future<List<FixedItem>> execute() async {
    return await repository.getAllFixedItems();
  }
}

class SaveFixedItem {
  final FixedItemRepository repository;
  SaveFixedItem(this.repository);

  Future<void> execute(FixedItem item) async {
    await repository.saveFixedItem(item);
  }
}

class DeleteFixedItem {
  final FixedItemRepository repository;
  DeleteFixedItem(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteFixedItem(id);
  }
}
