
import 'package:flutter/material.dart';

class CategoryAddition extends StatefulWidget {
  const CategoryAddition({super.key});

  @override
  State<StatefulWidget> createState() => _CategoryAdditionState();
}

class _CategoryAdditionState extends State<CategoryAddition> {
  final TextEditingController _controller = TextEditingController();

  void _saveCategory() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
     

    Navigator.pop(context, text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Category")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
              maxLength: 50,
              decoration: const InputDecoration(
                labelText: "Your Category",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: _saveCategory, child: const Text("Add Category")),
          ],
        ),
      ),
    );
  }
}
