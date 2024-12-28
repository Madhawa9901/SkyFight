import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HighScoresScreen extends StatelessWidget {
  const HighScoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('High Scores'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/sky_background_mountains.png"), fit: BoxFit.fill)
        ),
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('scores')
                .orderBy('score', descending: true) // Order by highest score
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Error loading scores.'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No scores available.'));
              }

              final scores = snapshot.data!.docs;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Name column width
                    1: FlexColumnWidth(1), // Score column width
                  },
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(20)),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Score',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                    // Table Rows
                    ...scores.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final name = data['name'] ?? 'Unknown';
                      final score = data['score'] ?? 0;

                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(name, style: const TextStyle(fontSize: 14)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              score.toString(),
                              style: const TextStyle(fontSize: 14),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
