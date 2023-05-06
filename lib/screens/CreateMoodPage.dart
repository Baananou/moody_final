import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateMoodPage extends StatefulWidget {
  @override
  _CreateMoodPageState createState() => _CreateMoodPageState();
}

class _CreateMoodPageState extends State<CreateMoodPage> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isSaving = false;

  void _saveMood() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSaving = true;
      });

      try {
        await FirebaseFirestore.instance
            .collection('moods')
            .doc(_idController.text.trim())
            .set({
          'name': _nameController.text.trim(),
        });

        Navigator.pop(context);
      } catch (error) {
        setState(() {
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save mood: $error'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Mood'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'ID',
                  hintText: 'Enter an ID for the mood',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an ID for the mood';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter a name for the mood',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name for the mood';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isSaving ? null : _saveMood,
                child: _isSaving
                    ? const SizedBox(
                        height: 20.0,
                        width: 20.0,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
