
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? email;
  String? aboutMe;
  String? avatarUrl;

  final TextEditingController _aboutMeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      setState(() {
        email = user.email;
        aboutMe = userDoc.get('aboutMe');
        avatarUrl = userDoc.get('avatarUrl');
      });
    }
  }

  Future<void> _updateUserAboutMe(String newAboutMe) async {
    User? user = FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({
      'aboutMe': newAboutMe,
    });

    setState(() {
      aboutMe = newAboutMe;
    });
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String imageName = 'avatar.jpg';

      Reference storageReference = FirebaseStorage.instance.ref().child('users/$userId/$imageName');
      UploadTask uploadTask = storageReference.putFile(imageFile);

      await uploadTask.whenComplete(() async {
        String downloadURL = await storageReference.getDownloadURL();

        User? user = FirebaseAuth.instance.currentUser;
        await FirebaseFirestore.instance.collection('users').doc(user?.uid).update({'avatarUrl': downloadURL});

        setState(() {
          avatarUrl = downloadURL;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC0CB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _uploadAvatar,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundColor: Colors.white,
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl!) : null,
                  child: avatarUrl == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 40.0,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16.0),
              if (email != null)
                Text(
                  'Почта: $email',
                  style: TextStyle(fontSize: 18, color: Color(0xFFDC143C)),
                ),
              SizedBox(height: 16.0),
              if (aboutMe != null)
                Text(
                  'О себе:',
                  style: TextStyle(fontSize: 18, color: Color(0xFFDC143C)),
                ),
              SizedBox(height: 8.0),
              if (aboutMe != null)
                Text(
                  aboutMe!,
                  style: TextStyle(fontSize: 16),
                ),
              SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () => _editAboutMe(context),
                child: Text('Редактировать О себе'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _editAboutMe(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Редактировать О себе'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Введите информацию о себе'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                _updateUserAboutMe(controller.text);
                Navigator.of(context).pop();
              },
              child: Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }
}