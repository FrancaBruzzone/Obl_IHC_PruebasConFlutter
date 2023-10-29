import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';

// ==========================
// Vista
// ==========================
class AddProductPage extends StatefulWidget {
  late final String productCode;
  AddProductPage({ required this.productCode });

  @override
  _AddProductPageState createState() => _AddProductPageState(productCode, null);
}

class _AddProductPageState extends State<AddProductPage> {
  final String productCode;
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late XFile? image;
  late File? imageFile;
  bool productNotFound = true;

  _AddProductPageState(this.productCode, this.imageFile);

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
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
            Text('El producto buscado no se encontró. Puede agregar un nuevo producto: ${productCode}',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text('Agrega los datos básicos del producto y nosotros nos encargaremos del resto.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 40),
            TextField(
              controller: descriptionController,
              maxLines: 4,
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
            SizedBox(height: 30),
            FutureBuilder(
              future: Future.value(imageFile),
              builder: (context, snapshot) {
                if (snapshot.hasData && imageFile != null) {
                  return Center(
                    child: Image.file(
                      imageFile!,
                      width: 120,
                    ),
                  );
                }
                return Container();
              }
            ),
            SizedBox(height: 30),
            Center(
              child: SizedBox(
                width: 140,
                height: 40,
                child:
                ElevatedButton.icon(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    takePicture(context);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                  ),
                  label: Text('Sacar foto'),
                ),
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
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Agregar',
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
    Product product = await getProductInfo();

    if (image != null) {
      await saveImageInCloud(image);
      await saveProductInCloud(product);

      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            product: product,
            recommendedProducts: [],
            ask: true,
            withBarcode: true,
          ),
        ),
      );
    }

    Navigator.pop(context);
  }

  Future<Product> getProductInfo() async {
    Product newProduct = Product(
        name: nameController.text,
        description: descriptionController.text,
        environmentalInfo: '',
        imageUrl: 'https://ihc.gil.com.uy/images/${productCode}.jpg',
        category: '',
        environmentalCategory: ''
    );

    try {
      String filter = newProduct.name;
      filter = Utils.removeDiacritics(filter);
      filter = filter.toUpperCase();

      Map<String, String> headers = { 'Authorization': 'ihc', };
      http.Response response = await http.get(
          Uri.parse('https://ihc.gil.com.uy/api/querys/detail?filter=${filter}'),
          headers: headers
      );

      var data = json.decode(response.body);

      if (data != null) {
        var description = data["description"] as String;
        newProduct.description = '${newProduct.description}. $description';
        newProduct.environmentalInfo = data["environmentalInfo"] as String;
        newProduct.category = data["category"] as String;
        newProduct.environmentalCategory = data["environmentalCategory"] as String;
      }
    } catch (e) {
      print(e);
    }

    return newProduct;
  }

  Future<void> saveProductInCloud(Product product) async {
    String _responseText = "";
    final String apiUrl = 'https://ihc.gil.com.uy/api/products';
    final Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'authorization': 'ihc',
    };

    final Map<String, dynamic> requestBody = {
      'code': this.productCode,
      'name': product.name,
      'brand': "brand",
      'quantity': "quantity",
      'description': product.description,
      'imageUrl': product.imageUrl,
      'environmentalInfo': product.environmentalInfo,
      'category': product.category,
      'environmentalCategory': product.environmentalCategory,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: headers,
      body: jsonEncode(requestBody),
    );

    setState(() {
      _responseText = response.statusCode == 200
          ? 'Respuesta del servidor: ${response.body}'
          : 'Error en la solicitud: ${response.statusCode}';
    });
  }

  Future<void> saveImageInCloud(XFile? picture) async {
    String _responseText = "";

    if (picture == null)
      return;

    try {
      final File filepath = File(picture.path);
      final File picpath = await filepath.rename(
          filepath.parent.path + Platform.pathSeparator + "${this.productCode}.jpg"
      );

      final http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse('https://ihc.gil.com.uy/upload')
      );
      request.headers.addAll({'Authorization': 'ihc'});
      request.files.add(await http.MultipartFile.fromPath('image', picpath.path));

      final http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        _responseText = 'Respuesta del servidor: ${await response.stream.bytesToString()}';
      } else {
        _responseText = 'Error en la solicitud: ${response.statusCode}';
      }
    } catch (e) {
      _responseText = 'Error: $e';
    }

    setState(() {
      _responseText = _responseText;
    });
  }

  Future<void> takePicture(BuildContext context) async {
    final XFile? newPicture = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
      maxWidth: 800,
      maxHeight: 600,
    );

    if (newPicture != null) {
      setState(() {
        image = newPicture;
        imageFile = File(newPicture.path);
      });
    }
  }
}