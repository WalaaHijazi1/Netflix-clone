const express = require('express');
const path = require('path');
const register = require('./metrics');

const app = express();
const PORT = 3001;

// Serve frontend build (replace 'dist' with your actual build output dir)
app.use(express.static(path.join(__dirname, 'dist')));

app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.listen(PORT, () => {
  console.log(`App running on port ${PORT}`);
});
