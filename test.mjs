import request from 'supertest';
import assert from 'assert';

const baseUrl = 'http://localhost:8080';

describe('Books API', () => {
    const book = { title: 'Anna Karenina', author: 'Leo Tolstoy' };

    it('Should persist documents', () => {
        request(baseUrl)
            .post('/books')
            .send(book)
            .expect(201)
            .end((err, res) => {
                if (err) throw err;
                assert(res.text.includes('Created a new book'));
            });

        request(baseUrl)
            .get('/books')
            .expect(200)
            .expect('Content-Type', /json/)
            .end((err, res) => {
                if (err) throw err;
                assert(res.body[0].title == book.title);
                assert(res.body[0].author == book.author);
            });
    });
});
