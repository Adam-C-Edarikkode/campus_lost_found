import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/item_provider.dart';
import '../../data/models/item_model.dart';
//import '../../core/theme.dart';
import '../widgets/item_card.dart';
import 'add_item_screen.dart';
import 'item_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Use addPostFrameCallback to avoid provider issues during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ItemProvider>(context, listen: false).loadItems();
    });
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<ItemProvider>(
      context,
      listen: false,
    ).setSearchQuery(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Lost & Found'),
        actions: [
          Consumer<ItemProvider>(
            builder: (context, itemProvider, child) {
              return IconButton(
                icon: Icon(
                  itemProvider.themeMode == ThemeMode.light
                      ? Icons.brightness_3_sharp
                      : Icons.brightness_5_sharp,
                ),
                onPressed: () {
                  itemProvider.toggleTheme();
                },
              );
            },
          ),
          /* IconButton(
            icon:  Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ItemProvider>(context, listen: false).toggleTheme();
            },
          ), */
          // Filter button could go here
        ],
      ),
      body: Consumer<ItemProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.items.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No items found yet.'),
                ],
              ),
            );
          }

          final items = provider.filteredItems;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search items...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: _showFilterBottomSheet,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(child: Text('No matches found.'))
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ItemCard(
                            item: item,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ItemDetailsScreen(item: item),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddItemScreen()),
          );
        },
        label: const Text('Report Lost'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Consumer<ItemProvider>(
          builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Filter Options',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.setFilterStatus(FilterStatus.all);
                          provider.setCategoryFilter(null);
                          Navigator.pop(context);
                        },
                        child: const Text('Clear Filters'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilterChip(
                        label: const Text('All'),
                        selected: provider.filterStatus == FilterStatus.all,
                        onSelected: (bool selected) {
                          provider.setFilterStatus(FilterStatus.all);
                        },
                      ),
                      FilterChip(
                        label: const Text('Lost'),
                        selected: provider.filterStatus == FilterStatus.lost,
                        onSelected: (bool selected) {
                          if (selected) {
                            provider.setFilterStatus(FilterStatus.lost);
                          }
                        },
                      ),
                      FilterChip(
                        label: const Text('Found'),
                        selected: provider.filterStatus == FilterStatus.found,
                        onSelected: (bool selected) {
                          if (selected) {
                            provider.setFilterStatus(FilterStatus.found);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Category',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: Item.categories.map((category) {
                      return FilterChip(
                        label: Text(category),
                        selected: provider.categoryFilter == category,
                        onSelected: (bool selected) {
                          provider.setCategoryFilter(selected ? category : null);
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
