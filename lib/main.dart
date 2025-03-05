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
  final List<String> folders = ['Hearts', 'Spades', 'Diamonds', 'Clubs'];
  final List<String> suits = ["hearts", 'spades', 'diamonds', 'clubs'];
  final List<String> numbers = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
  ];
  FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Organizer')),
      body: Column(
        children: [
          //Folders
          Expanded(
            child: ListView.builder(
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text("${folders[index]} ${numbers[0]}"),
                    trailing: IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CardScreen(folderName: folders[index]),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Deck blah comment
          Expanded(
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (context, suitIndex) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                  ),
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: numbers.length,
                  itemBuilder: (context, numberIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridTile(
                        child: Text(
                          "${suits[suitIndex]}${numbers[numberIndex]}",
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
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
