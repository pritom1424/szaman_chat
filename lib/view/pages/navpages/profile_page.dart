import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _usernameController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    // Load initial user data (you can replace this with actual data loading logic)
    _usernameController.text = 'John Doe'; // Initial username
  }

  void _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  void _saveProfile() {
    // Save profile changes (you can replace this with actual saving logic)
    final username = _usernameController.text;
    final profileImage = _profileImage;

    // For demonstration purposes
    print('Username: $username');
    print('Profile Image: ${profileImage?.path}');

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profile updated successfully!'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          Center(
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : AssetImage('assets/images/default_avatar.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: _pickImage,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveProfile,
            child: Text('Save Changes'),
          ),
        ],
      ),
    );
  }
}
