import * as dotenv from 'dotenv';
import { MongoClient } from 'mongodb';
import express from 'express';
import bodyParser from 'body-parser';

dotenv.config();

const client = new MongoClient(process.env.ATLAS_URI);
await client.connect();
const booksCollection = client.db('library').collection('books');

const app = express();
app.use(bodyParser.json());

app.get('/', (_, res) => res.send('Books API v1.0'));

app.post('/books', async (req, res) => {
    const { title, author } = req.body;
    if (!title || !author) {
        return res.status(400).send('Invalid parameters. Please provide title and author.');
    }

    const book = { title, author };
    const result = await booksCollection.insertOne(book);

    if (result) {
        res.status(201).send(`Created a new book with id ${result.insertedId}`);
    } else {
        res.status(500).send("Failed to create a new book.");
    }
});

app.get('/books', async (req, res) => {
    const { limit = 100 } = req.params;
    const books = await booksCollection.find().limit(limit).toArray();

    res.json(books);
});

app.listen(8080, () => console.log('App is running at port 8080...'));
