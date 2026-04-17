const express = require('express');
const path = require('path');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());

// Serve existing static assets from the original project structure
app.use('/css', express.static(path.join(__dirname, 'src/main/webapp/css')));
app.use('/js', express.static(path.join(__dirname, 'src/main/webapp/js')));
app.use('/images', express.static(path.join(__dirname, 'src/main/webapp/images')));

// Mock data
const mockItems = [
    { id: 1, name: "Vintage Camera", category: "Electronics", location: "London", image: "https://images.unsplash.com/photo-1544027993-37dbfe43562a?auto=format&fit=crop&q=80&w=400" },
    { id: 2, name: "Wooden Chair", category: "Furniture", location: "Berlin", image: "https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&q=80&w=400" },
    { id: 3, name: "Hardcover Book Set", category: "Books", location: "Paris", image: "https://images.unsplash.com/photo-1512820790803-83ca734da794?auto=format&fit=crop&q=80&w=400" }
];

// Routes for mock pages
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'mocks/index.html'));
});

app.get('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'mocks/login.html'));
});

app.get('/register', (req, res) => {
    res.sendFile(path.join(__dirname, 'mocks/register.html'));
});

app.get('/search', (req, res) => {
    res.sendFile(path.join(__dirname, 'mocks/search.html'));
});

app.get('/dashboard', (req, res) => {
    res.sendFile(path.join(__dirname, 'mocks/dashboard.html'));
});

// Mock API endpoint for items
app.get('/api/items', (req, res) => {
    res.json(mockItems);
});

app.listen(PORT, () => {
    console.log(`\x1b[32m[FreeGive Simulator]\x1b[0m App is running at http://localhost:${PORT}`);
    console.log(`\x1b[36mPress Ctrl+C to stop the server\x1b[0m`);
});
