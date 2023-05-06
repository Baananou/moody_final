import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moody_final/screens/CreateMoodPage.dart';
import 'package:moody_final/screens/CreateSongPage.dart';
import 'package:moody_final/screens/allSongs_screen.dart';
import 'package:moody_final/screens/songs_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Mood'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('moods').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GridView.builder(
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final DocumentSnapshot mood = snapshot.data!.docs[index];
                    final Map<String, dynamic> moodData =
                        mood.data() as Map<String, dynamic>;
                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SongsPage(moodId: moodData['id']),
                        ),
                      ),
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // SvgPicture.network(
                            //   mood['image'] as String,
                            //   width: 50,
                            //   height: 50,
                            //   placeholderBuilder: (BuildContext context) =>
                            //       const CircularProgressIndicator(),
                            // ),
                            const SizedBox(height: 10),
                            Text(
                              mood['name'] as String,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Image(
                image: AssetImage('images/app_logo.png'),
                height: 80,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              title: const Text('Create new Mood (Admin)'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateMoodPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Add new Song (Admin)'),
              onTap: () {
                FirebaseAuth.instance.authStateChanges().listen((User? user) {
                  if (user != null) {
                    String email = user.email!;
                    // Check email address against specific email address
                    if (email == 'baananou@test.com') {
                      // Navigate to AddSongPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddSongPage()),
                      );
                    } else {
                      // Redirect user to different page or show error message
                      // For example:
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Access Denied'),
                            content: const Text(
                                'You are not authorized to access this page.'),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.pop(context);
                                  // Navigate to different page
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  }
                });
              },
            ),
            ListTile(
              title: const Text('All Songs'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AllSongsPage(),
                  ),
                );
              },
            ),
            const ListTile(
              title: Text(
                'Hello, you are signed in as',
                style: TextStyle(fontSize: 22),
              ),
            ),
            ListTile(
              title: Text(
                user.email!,
                style: const TextStyle(fontSize: 22),
              ),
            ),
            ListTile(
              title: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () => FirebaseAuth.instance.signOut(),
                color: Colors.amber[900],
                child: Text(
                  'Sign out',
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
