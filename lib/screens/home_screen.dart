import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Mood'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('moods').snapshots(),
        builder: (context, snapshot) {
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
            itemBuilder: (context, index) {
              DocumentSnapshot mood = snapshot.data!.docs[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SongsPage(moodId: mood['id']),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(mood['name']),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Image.asset(
                'images/app_logo.png',
                height: 80,
              ),
            ),
            const ListTile(
                title: Text(
              'Hello you Are signed in as',
              style: TextStyle(fontSize: 22),
            )),
            ListTile(
                title: Text(
              user.email!,
              style: const TextStyle(fontSize: 22),
            )),
            ListTile(
              title: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(12)),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
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

class SongsPage extends StatelessWidget {
  final String moodId;

  const SongsPage({required this.moodId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs for Mood'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('songs')
            .where('moodId', isEqualTo: moodId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No songs found for this mood'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              final song = snapshot.data!.docs[index];
              final Url = song['videourl'];
              String videoId = YoutubePlayer.convertUrlToId(Url)!;

              YoutubePlayerController _controller = YoutubePlayerController(
                initialVideoId: videoId,
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );

              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: MediaQuery.of(context).size.height / 4,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                  ),
                ),
              );
              // return ListTile(
              //   title: Text(song['title']),
              //   subtitle: Text(song['artist']),
              //   onTap: () {
              //     // TODO: handle song selection
              //   },
              // );
            },
          );
        },
      ),
    );
  }
}



    // Scaffold(
    //   body: SafeArea(
    //     child: Center(
    //         child: SingleChildScrollView(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
              // Text(
              //   'Hello you Are signed in as',
              //   style: TextStyle(fontSize: 22),
              // ),
    //           SizedBox(
    //             height: 5,
    //           ),
              // Text(
              //   user.email!,
              //   style: TextStyle(fontSize: 22),
              // ),
              // MaterialButton(
              //   shape: RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(12)),
              //   onPressed: () {
              //     FirebaseAuth.instance.signOut();
              //   },
              //   color: Colors.amber[900],
              //   child: Text(
              //     'Sign out',
              //     style: GoogleFonts.robotoCondensed(
              //         fontSize: 16,
              //         color: Colors.white,
              //         fontWeight: FontWeight.bold),
              //   ),
              // ),
    //         ],
    //       ),
    //     )),
    //   ),
    // );
    //   }
    // }
