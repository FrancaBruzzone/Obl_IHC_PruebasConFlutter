import express from "express";
import bodyParser from "body-parser";
import multer from "multer";
import path from "path";

const app = express();
const uploadDirectory = "/home/ihc/ihc_backend/src/uploads";

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, uploadDirectory);
  },
  filename: (req, file, cb) => {
    const extname = path.extname(file.originalname);
    console.log(file.originalname);
    cb(null, file.originalname);
  },
});

const upload = multer({
  storage: storage,
  limits: {
    fileSize: 10 * 1024 * 1024,
  },
});

import morgan from "morgan";
import cors from "cors";

import users from "./routes/users.js";
import products from "./routes/products.js";
import articles from "./routes/articles.js";
import openaiClient from './routes/openaiClient.js';

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use(morgan("dev"));
app.use(cors());
app.use(users.router);
app.use(products.router);
app.use(articles.router);
app.use(openaiClient.router);

app.post(
  "/upload",
  (req, res, next) => {
    const { authorization } = req.headers;
    if (authorization == "ihc") {
      next();
    } else res.status(401).send();
  },
  upload.single("image"),
  (req, res) => {
    if (req.file) {
      res.status(201).json({
        message: "Imagen subida correctamente",
        filename: req.file.filename,
      });
    } else {
      res.status(400).json({ error: "No se subió ninguna imagen" });
    }
  }
);

app.use("/images", express.static(path.join(uploadDirectory)));

app.use("*", (req, res) => {
  res.status(404).send("Not Found");
});

export default app;
