import 'package:flutter/material.dart';

class AddPlacesScreen extends StatefulWidget {
  const AddPlacesScreen({super.key});

  @override
  State<AddPlacesScreen> createState() {
    return _AddPlacesScreenState();
  }
}

class _AddPlacesScreenState extends State<AddPlacesScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Places"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: "Title"),
              controller: _controller,
              style:
                  TextStyle(color: Theme.of(context).colorScheme.onBackground),
            ),
            SizedBox(
              height: 12,
            ),
            ElevatedButton.icon(
                icon: const Icon(Icons.add),
                onPressed: () {},
                label: const Text("Add place"))
          ],
        ),
      ),
    );
  }
}
