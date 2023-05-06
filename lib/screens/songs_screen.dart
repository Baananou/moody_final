import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final song = snapshot.data!.docs[index];
                final url = song['videourl'];
                String videoId = YoutubePlayer.convertUrlToId(url)!;

                YoutubePlayerController _controller = YoutubePlayerController(
                  initialVideoId: videoId,
                  flags: const YoutubePlayerFlags(
                    autoPlay: false,
                    mute: false,
                  ),
                );

                return Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        song['title'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Text(
                        song['artist'] as String,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 15),
                      YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                      ),
                      const SizedBox(height: 15),
                      const Divider(
                        height: 20,
                        thickness: 3,
                        indent: 20,
                        endIndent: 20,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
