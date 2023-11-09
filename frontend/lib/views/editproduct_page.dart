import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';

// ==========================
// Vista
// ==========================
class EditProductPage extends StatefulWidget {
  final Product product;
  EditProductPage(this.product);

  @override
  _EditProductPageState createState() => _EditProductPageState(product.imageFile, product.imageUrl);
}

class _EditProductPageState extends State<EditProductPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController environmentalInfoController;
  late File? imageFile;
  final String? imageUrl;

  _EditProductPageState(this.imageFile, this.imageUrl);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    descriptionController = TextEditingController(text: widget.product.description);
    environmentalInfoController = TextEditingController(text: widget.product.environmentalInfo);
    imageFile = widget.product.imageFile;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    environmentalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Editar producto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Descripción',
                hintText: 'Ingrese la descripción aquí',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: environmentalInfoController,
              maxLines: 6,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Información ambiental',
                hintText: 'Ingrese la información ambiental aquí',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: FutureBuilder(
                future: Future.value(imageFile),
                builder: (context, snapshot) {
                  if (snapshot.hasData && imageFile != null) {
                    return Center(
                      child: Image.file(
                        imageFile!,
                        width: 100,
                      ),
                    );
                  } else if (imageUrl != null) {
                    return Image.network(
                    widget.product.imageUrl!,
                    width: 100,
                    );
                  }
                  return Container();
                }
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                width: 140,
                height: 40,
                child:
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: saveProduct,
                  icon: Icon(
                    Icons.save,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Guardar',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================
  // Lógica
  // ==========================
  void saveProduct() async {
    Utils.showLoaderDialog(context);
    String _responseText = "";

    try {
      final String apiUrl = 'https://ihc.gil.com.uy/api/products/${widget.product.code}';
      final Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'ihc',
      };

      final Map<String, dynamic> requestBody = {
        'code': widget.product.code,
        'name': nameController.text,
        'brand': "brand",
        'quantity': "quantity",
        'description': descriptionController.text,
        'environmentalInfo': environmentalInfoController.text
      };

      final response = await http.put(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        Product newProduct = widget.product;

        if (data != null) {
          newProduct.imageUrl = data["imageUrl"] as String;
          newProduct.description = data["description"] as String;
          newProduct.environmentalInfo = data["environmentalInfo"] as String;
          newProduct.category = data["category"] as String;
          newProduct.environmentalCategory = data["environmentalCategory"] as String;
        }

        _responseText = 'Respuesta del servidor: ${response.body}';

        Navigator.of(context).pop();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(
              product: newProduct,
              recommendedProducts: [],
              ask: true,
              withBarcode: true,
            ),
          ),
        );
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
            Utils.getSnackBarError('No se pudieron actualizar los datos del producto.')
        );
        _responseText = 'Error en la solicitud: ${response.statusCode}';
      }
    } catch (e) {
      _responseText = 'Error: $e';
    }

    setState(() {
      _responseText = _responseText;
    });
  }
}