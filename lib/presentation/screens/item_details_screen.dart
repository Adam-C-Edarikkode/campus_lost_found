import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/models/item_model.dart';
import '../../logic/item_provider.dart';

class ItemDetailsScreen extends StatelessWidget {
  final Item item;

  const ItemDetailsScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Delete Item'),
                  content: const Text('Are you sure you want to delete this item?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Provider.of<ItemProvider>(context, listen: false).deleteItem(item.id);
                        Navigator.pop(context); // Close dialog
                        Navigator.pop(context); // Go back
                      },
                      child: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.imageUrl != null && item.imageUrl!.isNotEmpty)
              Image.file(
                File(item.imageUrl!),
                width: double.infinity,
                height: 300,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 300,
                  color: Colors.grey.shade300,
                  child: const Center(child: Icon(Icons.broken_image, size: 64)),
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 64, color: Colors.grey),
                ),
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      if (item.isFound)
                        const Chip(
                          label: Text('FOUND'),
                          backgroundColor: Colors.greenAccent,
                        )
                      else
                        const Chip(
                          label: Text('LOST'),
                          backgroundColor: Colors.orangeAccent,
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${item.category}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.calendar_today),
                    title: const Text('Date Lost'),
                    subtitle: Text(DateFormat.yMMMMEEEEd().format(item.dateLost)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Contact'),
                    subtitle: Text(item.contactEmail),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  
                  if (!item.isFound)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton.icon(
                        onPressed: () {
                           showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Mark as Found?'),
                              content: const Text('This will mark the item as found.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                FilledButton(
                                  onPressed: () {
                                    Provider.of<ItemProvider>(context, listen: false).markAsFound(item.id);
                                    Navigator.pop(context); // Close dialog
                                    Navigator.pop(context); // Go back to list
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Mark as Found'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
