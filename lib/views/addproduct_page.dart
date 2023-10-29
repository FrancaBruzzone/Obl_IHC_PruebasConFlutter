import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';
import 'package:obl_ihc_pruebasconflutter/utils.dart';
import 'package:obl_ihc_pruebasconflutter/views/loading.dart';
import 'package:obl_ihc_pruebasconflutter/views/productdetail_page.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

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
  late XFile? pic;
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

  void _saveProduct() async {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 80,
            height: 80,
            color: Colors.white.withOpacity(0.1),
            child: LoadingIndicator(),
          ),
        );
      },
    );

    Product p = await getProductInfo();

    if (pic != null) {
      await savePictureInCloud(pic);
      await saveProductInCloud(p);

      Navigator.pop(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProductDetailPage(
            product: p,
            recommendedProducts: [],
            ask: true,
            withBarcode: true,
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

  Future<Product> getProductInfo() async {
    Product p = Product(
        name: nameController.text,
        description: descriptionController.text,
        environmentalInfo: '',
        imageUrl: 'https://ihc.gil.com.uy/images/${productCode}.jpg',
        category: '',
        environmentalCategory: ''
    );

    await getProductDetail(p);

    return p;
  }

  Future<void> getProductDetail(Product p) async {
    String filter = p.name;
    filter = Utils.removeDiacritics(filter);
    filter = filter.toUpperCase();

    try {
      Map<String, String> headers = { 'Authorization': 'ihc', };
      http.Response response = await http.get(Uri.parse('https://ihc.gil.com.uy/api/querys/detail?filter=${filter}'),
          headers: headers
      );

      var data = json.decode(response.body);

      if (data != null) {
        var description = data["description"] as String;
        p.description = '${p.description}. $description';
        p.environmentalInfo = data["environmentalInfo"] as String;
        p.category = data["category"] as String;
        p.environmentalCategory = data["environmentalCategory"] as String;
      }
    } catch (e) {
      print(e);
    }
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
        imageFile = File(picture.path);
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
                    _takePicture(context);
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
                  onPressed: _saveProduct,
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
}