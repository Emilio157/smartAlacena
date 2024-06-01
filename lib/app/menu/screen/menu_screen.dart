import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/color.dart';
import '../../../provider/auth_provider.dart';
import '../../../models/product_model.dart';
import '../../../services/product_service.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthenticationProvider authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    String nameToShow = "Hola!";
    String name = "";
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        String? fullName = authProvider.user?.name;
        if (fullName != null) {
          List<String> nameParts = fullName.split(" ");
          name = nameParts.first;
        }
        nameToShow = "$nameToShow $name";
      }
    } catch (e) {
      nameToShow = "Ha ocurrido un problema, reinicia la aplicación";
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          nameToShow,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(11, 96, 151, 1),
      ),
      body: const _MenuView(),
    );
  }
}

class _MenuView extends StatefulWidget {
  const _MenuView();
  @override
  __MenuViewState createState() => __MenuViewState();
}

class __MenuViewState extends State<_MenuView> {
  final ProductService _productService = ProductService();
  String ubicacion = "Ubicacion Desconocida";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          _buildAppBar(ubicacion),
          Expanded(
            child: StreamBuilder<List<ProductModel>>(
              stream: _productService.getProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No products found'));
                } else {
                  List<ProductModel> products = snapshot.data!;
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      var product = products[index];
                      return ListTile(
                        title: Text('Producto: ${product.name}'),
                        subtitle: Text('Estado: ${product.enable == 'yes' ? 'Sí hay' : 'No hay'}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(String location) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lista de tu",
                          style: TextStyle(
                            color: AppColor.textColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "Alacena inteligente",
                          style: TextStyle(
                            color: AppColor.blue,
                            fontWeight: FontWeight.w900,
                            fontSize: 25,
                            height: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
