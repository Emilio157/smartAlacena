import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_alacena/models/user_model.dart'; // Asegúrate de importar el modelo aquí
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_alacena/provider/auth_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Método para obtener un usuario por su UID
  Future<UserModel?> getUserByUid(String uid) async {
    DocumentSnapshot userSnapshot =
        await _firestore.collection('users').doc(uid).get();
    if (userSnapshot.exists) {
      return UserModel.fromFirebase(userSnapshot);
    } else {
      return null;
    }
  }

  Future<String?> updateProfilePic(File image, String uid) async {
    String profilePicURL = await uploadProfilePic(image, uid);
    await _firestore
        .collection('users')
        .doc(uid)
        .update({'profilePicURL': profilePicURL});
    return profilePicURL;
  }

  Future<UserModel> createUser(String username, String email, String password,
      File? image, BuildContext context) async {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel user = UserModel(
      uid: userCredential.user!.uid,
      name: username,
      email: email,
      profilePicURL: image != null
          ? await uploadProfilePic(image, userCredential.user!.uid)
          : null,
    );
    debugPrint(user.uid);

    // update current user data
    _auth.currentUser!.updateDisplayName(username);
    _auth.currentUser!.updatePhotoURL(user.profilePicURL!);
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
    //Creando datos de la alacena
    var users_collection_ref = _firestore.collection('users');
    var subcollection_ref = users_collection_ref.doc(user.uid).collection('alacena');
    String idCompartimiento = "";
    for (int i=0;i<34;i++)
    {
      idCompartimiento = (i + 1).toString();
      Map<String, String> dataCrear = {
        'enable': 'no',
        'name': '',
        'value': '',
        'id': idCompartimiento
      };

      subcollection_ref.doc(idCompartimiento).set(dataCrear);
    }
    return user;
  }

  Future<String> uploadProfilePic(File image, String uid) async {
    UploadTask uploadTask = _storage.ref('profilePic/$uid').putFile(image);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> signInUser(context, String email, String password) async {
    UserModel? user = await getUserByEmail(email);
    if (user == null) throw 'Datos incorrectos o usuario no encontrado.';
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    Provider.of<AuthenticationProvider>(context, listen: false).user = user;
  }

  Future<void> signOutUser(context) async {
    await FirebaseAuth.instance.signOut();
    Provider.of<AuthenticationProvider>(context, listen: false).removeUser();
  }

  Future<bool> setUserInProvider(context, User? user) async {
    if (user == null) return false;
    UserModel? userData = await getUserByUid(user.uid);
    Provider.of<AuthenticationProvider>(context, listen: false).user = userData;
    return true;
  }

  // Método para obtener un usuario por su email
  Future<UserModel?> getUserByEmail(String email) async {
    debugPrint(email);
    QuerySnapshot userSnapshot = await _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();
    if (userSnapshot.docs.isNotEmpty) {
      for (var doc in userSnapshot.docs) {
        debugPrint(doc.data().toString());
      }
    } else {
      debugPrint('No documents found or user not found.');
    };
    if (userSnapshot.docs.isNotEmpty) {
      return UserModel.fromFirebase(userSnapshot.docs.first);
    } else {
      return null;
    }
  }

  // Método para agregar un nuevo usuario
  Future<void> addUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(user.toMap());
  }

  // Método para actualizar la información de un usuario
  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toMap());
  }
}