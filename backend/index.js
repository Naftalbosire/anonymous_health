const express = require("express");
const mongoose = require("mongoose");
const dotenv = require("dotenv");
dotenv.config();

const authRoutes = require("./routes/authRoutes");
const chatRoutes = require("./routes/chatRoutes");
const groupRoutes = require("./routes/groupRoutes");

const app = express();
app.use(express.json());

// Connect to MongoDB
mongoose
  .connect(process.env.MONGODB_URI, {})
  .then(() => console.log("Connected to MongoDB"))
  .catch((error) => console.error("MongoDB connection error:", error));

// Route setup
app.use("/api/auth", authRoutes);
app.use("/api/chat", chatRoutes);
app.use("/api/group", groupRoutes);

// HTML Route for the home page
app.get("/", (req, res) => {
  res.send(`
    <html>
      <head>
        <title>Server Running</title>
      </head>
      <body>
        <h1>Server is running!</h1>
        <p>You can access the API routes:</p>
        <ul>
          <li><a href="/api/auth">Auth Routes</a></li>
          <li><a href="/api/chat">Chat Routes</a></li>
          <li><a href="/api/group">Group Routes</a></li>
        </ul>
      </body>
    </html>
  `);
});

// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
