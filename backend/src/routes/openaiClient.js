import { Router } from "express";
import OpenAI from "openai";
import axios from "axios";
import https from "https";

const router = Router();

const apiKeyGT = process.env.OPENAI_API_KEY;

const openai = new OpenAI({
  apiKey: apiKeyGT,
});

/* 'GET /api/recommendedProducts': Utiliza OpenAI para obtener productos recomendados 
de acuerdo a un producto específico */
router.get('/api/recommendedProducts', (req, res, next) => {
  const { authorization } = req.headers;
  if (authorization == "ihc") {
    next();
  } else res.status(401).send();
},
async (req, res) => {
  try {
    const filter = req.query.filter;

    if (filter == undefined || filter == "" || filter == null)
      res.status(400).json({ error: "filter is missing" });

    console.log("El filtro es: ", filter);

    let response = await getQueryOpenAI(filter);

    if (response.length > 0) {
      console.log(response[0].message.content);
      if (response[0].message.content != "null") {
        let resp = response[0].message.content;
       
        const respStart = resp.indexOf("[");
        const respEnd = resp.indexOf("]", respStart);

        if (respStart !== -1 && respEnd !== -1) {
          const jsonContent = resp.slice(respStart, respEnd + 1);

          try {
            const parsedJSON = JSON.parse(jsonContent);
            res.status(200).json(parsedJSON);

          } catch (e) {
            res.status(404).json({ error: "fail to parse" });
          }
        } else {
          res.status(404).json([]);
        }
      } else {
        res.status(404).json([]);
      }
    } else {
      res.status(404).json([]);
    }
  } catch (e) {
    res.json({ error: e.message });
  }
});

async function getQueryOpenAI(product) {
  var prompt =`
  Estoy buscando productos sustitutos para el producto "${product}". El motivo es reducir el impacto ambiental y elegir opciones más sostenibles. 
  ¿Puedes proporcionarme detalles de productos sustitutos en formato JSON con el contenido en español como se muestra a continuación?
  [
    {
      "name": "Nombre del producto sustituto",
      "description": "Descripción del producto en no más de 30 palabras",
      "environmentalInfo": "Información ambiental del producto sustituto recomendado",
      "category": "Categoría a la que pertenece el producto sustituto recomendado",
      "environmentalCategory": "Categorización ambiental del producto recomendado"
    }
  ]
  `;
  
  const chatCompletion = await openai.chat.completions.create({
    messages: [
      { role: 'system', content: 'Tú eres un asistente virtual comprometido con el medio ambiente que ofrece productos sustentables y ecológicos.'},
      { role: "user", content: prompt },
      { role: 'system', content: 'No quiero que me mandes nada en otro formato que no sea JSON. Si no puedes encontrar productos sustitutos, simplemente responde con un formato JSON vacío: []' }
    ],

    model: "gpt-3.5-turbo",
  });

  return chatCompletion.choices;
}

/* 'GET /api/productDetails': Utiliza OpenAI para obtener los detalles de un producto 
específico */
router.get('/api/productDetails', (req, res, next) => {
  const { authorization } = req.headers;
  if (authorization == "ihc") {
    next();
  } else res.status(401).send();
},
async (req, res) => {
  try {
    const filter = req.query.filter;
    
    if (filter == undefined || filter == "" || filter == null)
      res.status(400).json({ error: "filter is missing" });

    console.log("El filtro es: ", filter);

    let response = await getProductDetailOpenAI(filter);

    if (response.length > 0) {
      console.log(response[0].message.content);
      if (response[0].message.content != "null") {
        let resp = response[0].message.content;
      
        const respStart = resp.indexOf("{");
        const respEnd = resp.indexOf("}", respStart);

        if (respStart !== -1 && respEnd !== -1) {
          const jsonContent = resp.slice(respStart, respEnd + 1);
          const parsedJSON = JSON.parse(jsonContent);
          res.status(200).json(parsedJSON);
        } else {
          res.status(404).json([]);
        }
      } else {
        res.status(404).json([]);
      }
    } else {
      res.status(404).json([]);
    }
  } catch (e) {
    res.status(404).json([]);
  }
});

async function getProductDetailOpenAI(product) {
var prompt =`
Estoy buscando llenar los datos para el producto "${product}". El motivo es conocer su impacto ambiental. 
¿Puedes proporcionarme detalles del producto en formato JSON con el contenido en español como se muestra a continuación?
[
  {
    "name": "El nombre del producto que te di",
    "description": "Descripción del producto en no más de 30 palabras",
    "environmentalInfo": "Información ambiental del producto",
    "category": "Categoría a la que pertenece el producto",
    "environmentalCategory": "Categorización ambiental del producto"
  }
]
`;

const chatCompletion = await openai.chat.completions.create({
  messages: [
    { role: 'system', content: 'Tú eres un asistente virtual comprometido con el medio ambiente que conoce los datelles de los productos en cuanto a su sustentabilidad y ecología.'},
    { role: "user", content: prompt },
    { role: 'system', content: 'No quiero que me mandes nada en otro formato que no sea JSON. Si no puedes encontrar detalles del producto, simplemente responde con un formato JSON vacío: []' }
  ],

  model: "gpt-3.5-turbo",
});

return chatCompletion.choices;
}

export default { router };
