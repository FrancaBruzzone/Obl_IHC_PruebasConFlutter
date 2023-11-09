import { Router } from "express";
const router = Router();
import User from "../models/User.js";
import faker from "faker";

/* 'GET /api/users': Obtiene todos los usuarios de la Base de Datos */
router.get('/api/users',
  (req, res, next) => {
    const { authorization } = req.headers;

    if (authorization == "ihc") {
      next();
    } else res.status(401).send();
  },

  async (req, res) => {
    const users = await User.find();
    res.json({ users });
  }
);

/* 'POST /api/users': Crea un usuario en la Base de Datos */
router.post('/api/users',
  (req, res, next) => {
    const { authorization } = req.headers;

    if (authorization == "ihc") {
      next();
    } else res.status(401).send();
  },
  async (req, res) => {
    try {
      let { uuid, name, mail } = req.body;

      let exists = await User.findOne({ uuid });

      if (!exists) {
        let u = await User.create({
          name: name,
          uuid: uuid,
          mail: mail,
          avatar: faker.image.avatar(),
        });

        res.status(201).json(u);
      } else res.status(400).json({ error: "user already exists" });
    } catch (error) {
      res.status(500).json({ error });
    }
  }
);

/* 'PUT /api/users/:id': Actualiza un usuario */
router.put('/api/users/:id',
  (req, res, next) => {
    const { authorization } = req.headers;

    if (authorization == "ihc") {
      next();
    } else res.status(401).send();
  },
  async (req, res) => {
    try {
      const filter = { uuid: req.params.id };
      let { name, mail } = req.body;
      let id = req.params.id;
      console.log("modify user: ", id);
      let result = await User.updateOne(filter, {
        name: name,
        mail: mail,
      });
      console.log(result);
      if (result) {
        res.status(200).json(result);
      } else {
        res.status(404).json({ message: "UUID no encontrado" });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

/* 'GET/api/users/:id': Obtiene un usuario de la Base de Datos */
router.get('/api/users/:id',
  (req, res, next) => {
    const { authorization } = req.headers;

    if (authorization == "ihc") {
      next();
    } else res.status(401).send();
  },
  async (req, res) => {
    try {
      const filter = { uuid: req.params.id };

      let id = req.params.id;
      console.log("modify user: ", id);
      let result = await User.findOne(filter);
      console.log(result);
      if (result) {
        res.status(200).json(result);
      } else {
        res.status(404).json({ message: "UUID no encontrado" });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  }
);

export default { router };
