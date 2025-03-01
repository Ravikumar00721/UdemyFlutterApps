import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpo/todo/itemprovider.dart';

class ItemScreen extends ConsumerWidget {
  const ItemScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(itemProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo"),
      ),
      body: ListView.builder(
        itemCount: item.length,
        itemBuilder: (context, index) {
          final itemDetail = item[index];
          return ListTile(
            title: Text(itemDetail.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                    onPressed: () {
                      ref.read(itemProvider.notifier).deleteItem(itemDetail.id);
                    },
                    icon: Icon(Icons.delete)),
                IconButton(
                    onPressed: () {
                      ref
                          .read(itemProvider.notifier)
                          .updateItem(itemDetail.id, "Asif Taj");
                    },
                    icon: Icon(Icons.edit))
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(itemProvider.notifier).addItem('New Item');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
