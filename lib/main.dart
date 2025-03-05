import 'package:flutter/material.dart';
import 'helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.init();
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
  final DatabaseHelper dbHelper = DatabaseHelper();

  FolderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Card Organizer')),
      body: Column(
        children: [
          // Folders List
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getFolders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No folders available.'));
                } else {
                  var folders = snapshot.data!;
                  return ListView.builder(
                    itemCount: folders.length,
                    itemBuilder: (context, index) {
                      var folder = folders[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(folder['name']),
                          trailing: IconButton(
                            icon: Icon(Icons.arrow_forward),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => CardScreen(
                                        folderId: folder['id'],
                                        folderName: folder['name'],
                                      ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          // Deck
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
  final int folderId;

  CardScreen({super.key, required this.folderId, required this.folderName});

  final List<String> cards = ['Ace', 'King', 'Queen', 'Jack', '10', '9'];

  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cards')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: dbHelper.getCardsInFolder(folderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No cards available.'));
          } else {
            return GridView.count(
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: List.generate(snapshot.data!.length, (index) {
                var card = snapshot.data![index];
                return Card(
                  child: Center(
                    child: Text(
                      card['name'],
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center, // Center the text
                    ),
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}
