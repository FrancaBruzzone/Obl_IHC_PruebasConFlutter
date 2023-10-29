import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:obl_ihc_pruebasconflutter/entities/Product.dart';

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
  void saveProduct() {
    Navigator.of(context).pop();
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
        imageFile = File(newPicture.path);
      });
    }
  }
}