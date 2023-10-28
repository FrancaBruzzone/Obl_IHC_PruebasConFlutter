import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/views/barcodeproductdetail_page.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class AddProductPage extends StatefulWidget {
  late final String productCode;
  AddProductPage({ required this.productCode });

  @override
  _AddProductPageState createState() => _AddProductPageState(productCode);
}

class _AddProductPageState extends State<AddProductPage> {
  final String productCode;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController environmentalInfoController;
  late XFile? pic;
  bool productNotFound = true;

  _AddProductPageState(this.productCode);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    environmentalInfoController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    environmentalInfoController.dispose();
    super.dispose();
  }

  void _saveProduct() async {
    Product p = getProductInfo();

    if (pic != null) {
      await savePictureInCloud(pic);
      await saveProductInCloud(p);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BarcodeProductDetailPage(
            product: p,
            recommendedProducts: [],
            ask:false
          ),
        ),
      );
    }
  }

  Future<void> saveProductInCloud(Product p) async {
    String _responseText = "";
    final String apiUrl = 'https://ihc.gil.com.uy/api/products';

    final String requestBody = jsonEncode({
      'code': this.productCode,
      'name': p.name,
      'brand': "brand",
      'quantity': "quantity",
      'description': p.description,
      'imageUrl': p.imageUrl,
      'environmentalInfo': p.environmentalInfo,
      'category': p.category,
      'environmentalCategory': p.environmentalCategory,
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': 'ihc'
      },
      body: requestBody,
    );

    if (response.statusCode == 200) {
      setState(() {
        _responseText = 'Respuesta del servidor: ${response.body}';
      });
    } else {
      setState(() {
        _responseText = 'Error en la solicitud: ${response.statusCode}';
      });
    }
  }

  Future<void> savePictureInCloud(XFile? picture) async {
    String _responseText = "";
    try {
      if (picture == null) {
        return;
      }

      File picpath = await changeFileNameOnly(File(picture.path), "${this.productCode}.jpg");
      var headers = {'Authorization': 'ihc', 'Content-Type': 'image/jpeg'};
      const String apiUrl = 'https://ihc.gil.com.uy/upload'; 

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      final file = picpath;
      request.files.add(await http.MultipartFile.fromPath('image', file.path));
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        setState(() async {
          _responseText = 'Respuesta del servidor: ${await response.stream.bytesToString()}';
        });
      } else {
        setState(() {
          _responseText = 'Error en la solicitud: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _responseText = 'Error: $e';
      });
    }
  }

  Product getProductInfo() {
    return Product(
      name: nameController.text,
      description: descriptionController.text,
      environmentalInfo: environmentalInfoController.text,
      imageUrl: 'https://ihc.gil.com.uy/images/${productCode}.jpg',
      category: '',
      environmentalCategory: ''
    );
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  Future<void> _takePicture(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? picture = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (picture != null) {
       setState(() {
        pic = picture;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Agregar nuevo producto'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (productNotFound)
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('El producto buscado no se encontró. Puede agregar un nuevo producto: ${productCode}',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: environmentalInfoController,
              decoration: InputDecoration(labelText: 'Información Ambiental'),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _takePicture(context);
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.all(16.0),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text('Sacar foto a producto',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                onPressed: _saveProduct,
                child: Text('Agregar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}