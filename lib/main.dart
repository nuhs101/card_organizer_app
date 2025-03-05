import 'package:flutter/material.dart';

void main() {
  runApp(CardOrganizerApp());
}

class CardOrganizerApp extends StatelessWidget {
  const CardOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Card Organizer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FolderScreen(),
    );
  }
}

class FolderScreen extends StatelessWidget {
  final List<String> folders = ['Heart', 'Spades', 'Diamonds', 'Clubs'];

  FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Organizer')),
      body: ListView.builder(
        itemCount: folders.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(folders[index]),
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => CardScreen(folderName: folders[index]),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class CardScreen extends StatelessWidget {
  final String folderName;

  CardScreen({super.key, required this.folderName});

  final List<String> cards = ['Ace', 'King', 'Queen', 'Jack', '10', '9'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$folderName Cards')),
      body: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        children: List.generate(cards.length, (index) {
          return Card(
            child: Center(
              child: Text(
                cards[index],
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center, // Center the text
              ),
            ),
          );
        }),
      ),
    );
  }
}
