import 'package:flutter/material.dart';
//Importaciones de Firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( FirestoreButtonWidget());
}

class FirestoreButtonWidget extends StatefulWidget {
  @override
  _FirestoreButtonWidgetState createState() => _FirestoreButtonWidgetState();
}

class _FirestoreButtonWidgetState extends State<FirestoreButtonWidget> {
  String _displayedData = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Smart Organizer Shelter'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                // Lógica para recuperar los datos de Firestore
                _retrieveDataFromFirestore();
              },
              child: Text('Obtener Lista'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[200],
                child: SingleChildScrollView(
                  child: Text(
                    _displayedData,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _retrieveDataFromFirestore() {
    FirebaseFirestore.instance.collection('productos').get().then((querySnapshot) {
      String data = '';
      querySnapshot.docs.forEach((doc) {
        var disponible = doc.data()['disponible'];
        var nombre = doc.data()['nombre_producto'];
        if(disponible == "True"){
          data += 'Producto: $nombre, Estado: No hay\n';

        }else{
          data += 'Producto: $nombre, Estado: Sí hay\n';

        }
      });
      setState(() {
        _displayedData = data;
      });
    }).catchError((error) {
      print('Error al obtener los datos: $error');
    });
  }
}

