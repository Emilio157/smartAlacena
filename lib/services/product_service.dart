import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ProductModel>> getProducts() {
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('alacena')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromFirebase(doc))
            .toList());
  }
}
