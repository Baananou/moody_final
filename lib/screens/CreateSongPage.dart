import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({Key? key}) : super(key: key);

  @override
  _AddSongPageState createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final _formKey = GlobalKey<FormState>();
  late String _docId;
  late String _title;
  late String _artist;
  late String _moodId;
  late String _videoUrl;
  List<DropdownMenuItem<String>> _moodDropdownItems = [];
  String? _selectedMoodId;

  @override
  void initState() {
    super.initState();
    _loadMoods();
  }

  void _loadMoods() async {
    QuerySnapshot moodSnapshot =
        await FirebaseFirestore.instance.collection('moods').get();
    setState(() {
      _moodDropdownItems = moodSnapshot.docs
          .map((doc) => DropdownMenuItem(
                value: doc.id,
                child: Text(doc['name']),
              ))
          .toList();
    });
  }

  void _addSong() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance
          .collection('songs')
          .doc(_docId)
          .set({
            'title': _title,
            'artist': _artist,
            'moodId': _selectedMoodId,
            'videourl': _videoUrl,
          }, SetOptions(merge: true))
          .then((value) => Navigator.pop(context))
          .catchError((error) => print('Failed to add song: $error'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Song'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Document ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a document ID';
                  }
                  return null;
                },
                onChanged: (value) {
                  _docId = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                onChanged: (value) {
                  _title = value;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Artist'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an artist';
                  }
                  return null;
                },
                onChanged: (value) {
                  _artist = value;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Mood'),
                value: _selectedMoodId,
                items: _moodDropdownItems,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a mood';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _selectedMoodId = value;
                  });
                },
              ),
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Mood ID'),
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a mood ID';
              //     }
              //     return null;
              //   },
              //   onChanged: (value) {
              //     _moodId = value;
              //   },
              // ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Video URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a video URL';
                  }
                  return null;
                },
                onChanged: (value) {
                  _videoUrl = value;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _addSong,
                child: const Text('Add Song'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
