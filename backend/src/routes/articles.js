import { Router } from "express";
const router = Router();
import Article from "../models/Article.js";
import faker from "faker";
import axios from "axios";
import cheerio from 'cheerio';

const apiKey = "AIzaSyC8lZz1_tMeY297wjg3WfcnAwykoAjnCig";
const customSearchId = "434ac66dded3040d1";

const topics = [
  'Reciclaje',
  'Sustentabilidad',
  'Huella de Carbono',
  'Cambio Climático',
  'Calentamiento Global',
  'Ebullición Global',
  'Productos Alimenticios Ecológicos',
  'Productos Ecológicos',
]

const descriptions = [
  'Artículo sobre reciclaje y su importancia.',
  'Artículo sobre prácticas de sustentabilidad.',
  'Artículo sobre la reducción de la huella de carbono.',
  'Artículo sobre el cambio climático y sus efectos.',
  'Artículo sobre el calentamiento global y medidas para combatirlo.',
  'Artículo sobre la ebullución global y medidas para combatirla.',
  'Artículo sobre productos alimenticios ecológicos y su impacto.',
  'Artículo sobre productos ecológicos y su importancia en la sostenibilidad.',
]

/* 'GET /api/articles': Obtiene todos los articulos de la Base de Datos */
router.get('/api/articles', async (req, res) => {
  const articles = await Article.find();
  res.json({ articles });
});

/* 'POST /api/articles': Utiliza Google Custom Search para obtener de internet 5 artículos
de acuerdo a los temas registrados en topics, y los crea en la Base de datos */
router.post('/api/articles', async (req, res) => {
  for (let i = 0; i < 5; i++) {
    const randomTopicIndex = Math.floor(Math.random() * topics.length)
    const randomTopic = topics[randomTopicIndex]
    const description = descriptions[randomTopicIndex]

    try {
      const searchUrl = `https://www.googleapis.com/customsearch/v1?q=${randomTopic}&key=${apiKey}&cx=${customSearchId}&alt=json`
      const response = await axios.get(searchUrl)

      const searchResults = response.data.items

      if (searchResults && searchResults.length > 0) {
        for (let j = 0; j < searchResults.length; j++) {
          const title = searchResults[j].title;
          const articleUrl = searchResults[j].link;

          const existingArticle = await Article.findOne({ title });

          if (!existingArticle) {
            const articleResponse = await axios.get(articleUrl);
            const $ = cheerio.load(articleResponse.data);
            const articleContent = $('p').text();
            
            const content = articleContent
              .split(' ')
              .map(word => word.replace(/[^\w\dáéíóúüÁÉÍÓÚÜñÑ]+/g, ''))
              .filter(word => word !== '')
              .slice(0, 100)
              .join(' ');

            const newArticle = {
              title: title,
              category: randomTopic,
              description: description,
              articleUrl: articleUrl,
              content: content,
              timestamp: new Date()
            };

            await Article.create(newArticle);
            break;
          }
        }
      }
    } catch (error) {
      console.error(`Error al obtener contenido: ${error}`)
    }
  }
  res.json({ message: '5 artículos creados correctamente.' })
})

/* 'DELETE /api/articles': Elimina todos los artículos de la Base de datos */
router.delete('/api/articles', async (req, res) => {
  await Article.deleteMany({});
  res.status(200).send("Artículos eliminados correctamente.");
})

export default { router };