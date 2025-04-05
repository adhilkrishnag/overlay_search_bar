import 'package:flutter/material.dart';
import 'package:overlay_search_bar/overlay_search_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SearchBarExample(),
    );
  }
}

class SearchBarExample extends StatefulWidget {
  const SearchBarExample({super.key});

  @override
  State<SearchBarExample> createState() => _SearchBarExampleState();
}

class _SearchBarExampleState extends State<SearchBarExample> {
  final TextEditingController _controller = TextEditingController();
  List<String> allItems = List.generate(30, (index) => 'Item $index');
  List<String> filteredItems = [];

  @override
  void initState() {
    super.initState();
    filteredItems = allItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Overlay Search Bar Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: OverlaySearchBar(
          controller: _controller,
          prefixIcon: Icons.search,
          onChanged: (value) {
            setState(() {
              filteredItems = allItems
                  .where((item) =>
                      item.toLowerCase().contains(value.toLowerCase()))
                  .toList();
            });
          },
          suggestions: [
            ...filteredItems.map((item) => ListTile(
                  title: Text(item),
                  onTap: () {
                    _controller.text = item;
                    FocusScope.of(context).unfocus();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
