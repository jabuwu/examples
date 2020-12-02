const express = require('express');
const app = express();
app.get('/', (req, res) => {
  res.send('Hello, express + lambda');
});
module.exports = { app };