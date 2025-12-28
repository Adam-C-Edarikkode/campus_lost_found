import 'package:hive_flutter/hive_flutter.dart';
import '../models/item_model.dart';

class ItemRepository {
  static const String boxName = 'items_box';

  Future<Box<Item>> _getBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<Item>(boxName);
    } else {
      return await Hive.openBox<Item>(boxName);
    }
  }

  Future<List<Item>> getItems() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<void> addItem(Item item) async {
    final box = await _getBox();
    await box.put(item.id, item);
  }

  Future<void> updateItem(Item item) async {
    final box = await _getBox();
    await box.put(item.id, item);
  }

  Future<void> deleteItem(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }
}
