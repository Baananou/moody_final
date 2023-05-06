import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AllSongsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Songs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('songs').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No songs found'));
          }

          return ListView.builder(
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
                height: 300,
                margin: EdgeInsets.all(10),
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
