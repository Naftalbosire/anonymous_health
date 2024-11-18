// app.js
const express = require('express');
const http = require('http');
const socketIo = require('socket.io');
const mongoose = require('./config/db');

const authRoutes = require('./routes/authRoutes');
const chatRoutes = require('./routes/chatRoutes');
const groupRoutes = require('./routes/groupRoutes');
const chatSocket = require('./sockets/chatSocket');

const app = express();
const server = http.createServer(app);
const io = socketIo(server);

app.use(express.json());

// Use routes
app.use('/api/auth', authRoutes);
app.use('/api/chat', chatRoutes);
app.use('/api/groups', groupRoutes);

// Initialize chat socket
chatSocket(io);

const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
