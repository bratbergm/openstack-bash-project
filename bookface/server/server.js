'use strict';

import express from 'express';
import path from 'path';
import mysql from 'mysql';
import { resourceUsage } from 'process';
import bodyParser from 'body-parser';
import bcrypt from 'bcryptjs'; // npm install, pw hashing
const app = express();
const PORT = 8081;

app.listen(PORT, () => {
  console.log('Running...');
});

app.use(express.static(path.resolve() + '/server'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var db = mysql.createConnection({
  host: 'db',
  user: 'admin',
  password: 'password',
  database: 'prog2053-proj',
});

db.connect(function (err) {
  if (err) {
    throw err;
  }
  console.log('Connected!');
});

// Add headers
app.use(function (req, res, next) {
  // Website you wish to allow to connect
  res.setHeader('Access-Control-Allow-Origin', 'http://localhost:8080');

  // Request methods you wish to allow
  res.setHeader(
    'Access-Control-Allow-Methods',
    'GET, POST, OPTIONS, PUT, PATCH, DELETE'
  );

  // Request headers you wish to allow
  res.setHeader(
    'Access-Control-Allow-Headers',
    'X-Requested-With,content-type'
  );

  // Set to true if you need the website to include cookies in the requests sent
  // to the API (e.g. in case you use sessions)
  res.setHeader('Access-Control-Allow-Credentials', true);

  // Pass to next layer of middleware
  next();
});

app.post('/registerUser', function (req, res) {
  console.log(req.body);

  const { email, password, passwordConfirm } = req.body;
  // Query for stored emails in database to check if user inputs an email that already exists
  db.query(
    'SELECT `email` FROM users WHERE email = ?',
    [email],
    async (error, result) => {
      if (error) {
        console.log(error);
      } // If one or more input fields are empty
      else if (!email || !password || !passwordConfirm) {
        console.log('One or more field is missing input');
        res.send(450);
      } else if (result.length > 0) {
        // If the email already exists in the database
        console.log('Email is in use');
        res.send(400);
      } // If the passwords from user is a mismatch
      else if (password !== passwordConfirm) {
        console.log('Password mismatch');
        res.send(300);
      } else {
        // If all is OK
        bcrypt.hash(password, 8).then((hashedPassword) => {
          db.query(
            'INSERT INTO users SET ?',
            { email: email, password: hashedPassword },
            (error, results) => {
              if (error) {
                console.log(error);
              } else {
                console.log(results);
                console.log('User is added');
                res.send(200);
              }
            }
          );
        });
      }
    }
  );
});

app.post('/loginUser', function (req, res) {
  console.log(req.body);

  const { email, password } = req.body;

  db.query(
    'SELECT `email`,`password` FROM users WHERE email = ?',
    [email],
    async (error, results) => {
      console.log(results);

      if (error) {
        console.log(error);
      } // If missing input from user
      else if (!email || !password) {
        res.send(400);
      } // Todo: If wrong email (not able to make this work)
      else if (false) {
        res.send(300);
      } // If wrong password
      else if (!(await bcrypt.compare(password, results[0].password))) {
        res.send(450);
      } else {
        // If everyting is OK
        res.send(200);
      }
    }
  );
});

app.post('/addPost', function (req, res) {
  const { title, content, user } = req.body;

  db.query(
    'INSERT INTO posts SET ?',
    { user: user, title: title, content: content },
    (error, results) => {
      if (error) {
        console.log(error);
      } // If one or more fields are missing input 
      else if (!title || !content || !user) {
        res.send(400);
      } else {
        // If everything is OK
        console.log(results);
        console.log('Post is added');
        res.send(200);
      }
    }
  );
});

app.get('/getPosts', function (req, res) {
  db.query(
    'SELECT p.pid AS postId, u.uid AS userId, title, content, userType, email, picture AS avatar FROM posts p INNER JOIN users u ON u.uid = p.user',
    function (err, result) {
      if (err) {
        console.log(err);
      } else {
        // Send to frontend
        res.send(JSON.stringify(result));
      }
    }
  );
});


app.get('/getUsers', function (req, res) {
  db.query('SELECT * FROM users', function (err, result) {
    if (err) {
      res.status(400).send('Error in database operation.');
    } else {
      res.writeHead(200, { 'Content-Type': 'application/json' });
      res.end(JSON.stringify(result));
      //console.log("Result: " + res);
    }
  });
});
