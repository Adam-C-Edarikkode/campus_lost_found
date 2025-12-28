import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'item_model.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final String category;

  @HiveField(4)
  final DateTime dateLost;

  @HiveField(5)
  final String? imageUrl;

  @HiveField(6)
  final String contactEmail;

  @HiveField(7)
  bool isFound;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  DateTime? foundAt;

  Item({
    String? id,
    required this.title,
    required this.description,
    required this.category,
    required this.dateLost,
    this.imageUrl,
    required this.contactEmail,
    this.isFound = false,
    DateTime? createdAt,
    this.foundAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();
  
  Item copyWith({
    String? title,
    String? description,
    String? category,
    DateTime? dateLost,
    String? imageUrl,
    String? contactEmail,
    bool? isFound,
    DateTime? foundAt,
  }) {
    return Item(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      dateLost: dateLost ?? this.dateLost,
      imageUrl: imageUrl ?? this.imageUrl,
      contactEmail: contactEmail ?? this.contactEmail,
      isFound: isFound ?? this.isFound,
      createdAt: createdAt,
      foundAt: foundAt ?? this.foundAt,
    );
  }


  static const List<String> categories = [
    'Electronics',
    'Clothing',
    'Books',
    'Keys',
    'Wallet/ID',
    'Other',
  ];
}
