import { Router } from "express";
import axios from "axios";
import https from "https";
import Product from "../models/Product.js";
import path from "path";
import fs from 'fs/promises';

const router = Router();

const OpenFoodFactUrl = "https://openfoodfacts.org/api/v0/product/";
const uploadDirectory = "/home/ihc/ihc_backend/src/uploads";

/* 'GET /api/products/:id': Utiliza Open Food Factos para obtener los detalles de un
producto específico */
router.get('/api/products/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const prod = await Product.findOne({ 'code': id });

    if (prod) {
      res.status(201).json(prod);
    } else {
      let response = await getProduct(OpenFoodFactUrl, id);
      let data = response.data;

      if (data && data.status == "1") {
        let p = {
          code: id,
          name: (data.product.product_name_es)?data.product.product_name_es:data.product.product_name,
          description: (data.product.ingredients_text_es) ? data.product.ingredients_text_es || "" : data.product.ingredients_text || "",
          imageUrl: data.product.image_front_url || "",
          environmentalInfo: data.product.ecoscore_data.adjustments.packaging 
            .non_recyclable_and_non_biodegradable_materials == 0
            ? "reciclable/biodegradable"
            : "no biodegradable/no identificado",
          category: data.product.categories || "",
          environmentalCategory: "",
        }

        let product = await Product.create(p);
        res.status(201).json(product);
      }
      else {
        res.status(404).json({ error: "Producto no encontrado" });
      }
    }
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
});

async function getProduct(url, code) {
  try {
    const response = await axios.get(url + code);
    return response;

  } catch (error) {
    console.error(error);
  }
}

/* 'GET /api/products': Obtiene todos los productos de la Base de Datos */
router.get('/api/products', async (req, res) => {
  const products = await Product.find();
  res.json({ products });
});

/* 'POST /api/products': Crea un producto en la Base de Datos */
router.post('/api/products', async (req, res) => {
  const { authorization } = req.headers;
  const {
    code,
    name,
    description,
    imageUrl,
    environmentalInfo,
    category,
    environmentalCategory,
  } = req.body;

  if (authorization != "ihc") {
    res.status(401).send();   
  } else {
    const newProd = await Product.findOne({ 'code': code }).exec();
    
    if (!newProd) {
      let product = await Product.create({
        code,
        name,
        description,
        imageUrl,
        environmentalInfo,
        category,
        environmentalCategory,
      });

      res.status(201).json(product);
    } else {
      res.status(400).send();
    }
  }
});

/* 'PUT /api/products/:id': Actualiza los datos de un producto por código */
router.put('/api/products/:id', async (req, res) => {
  try {
    const { authorization } = req.headers;
    const {
      code,
      name,
      description,
      imageUrl,
      environmentalInfo,
      category,
      environmentalCategory,
    } = req.body;

    const { id } = req.params;

    if (authorization != "ihc") {
      res.status(401).send();   
    } else {
      const filter = { 'code': id };
      const newData = {
        code,
        name,
        description,
        environmentalInfo,
        category,
        environmentalCategory,
      }

      if (imageUrl)
        newData.imageUrl = imageUrl

      const productUpdated = await Product.findOneAndUpdate(filter, newData, { new: true });
      res.status(200).json(productUpdated);
    }
  } catch (error) {
    res.status(500).json({error: error.message});
  }
});

// 'DELETE /api/products': Elimina todos los productos y las imágenes correspondientes de la Base de Datos
router.delete('/api/products', async (req, res) => {
  const { authorization } = req.headers;
  
  if (authorization != "ihc") {
    res.status(401).send();
  } else { 
    try {
      const productCodes = await Product.distinct('code');
      await deleteImagesByProductCodes(productCodes);
      await Product.deleteMany({});
      res.status(200).send('Todos los productos y sus imágenes correspondientes han sido eliminados correctamente.');
    } catch (error) {
      res.status(500).send('Error al eliminar productos e imágenes.');
    }
  }
});

const deleteImagesByProductCodes = async (productCodes) => {
  try {
    const files = await fs.readdir(uploadDirectory);

    for (const file of files) {
      const filePath = path.join(uploadDirectory, file);
      if (productCodes.some((code) => file.startsWith(code))) {
        await fs.unlink(filePath);
        console.log('Imagen eliminada:', filePath);
      }
    }
  } catch (error) {
    console.error('Error al eliminar imágenes:', error);
    throw error;
  }
};

export default { router };
