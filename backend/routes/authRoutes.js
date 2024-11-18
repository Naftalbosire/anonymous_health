// routes/authRoutes.js
const express = require('express');
const router = express.Router();
const authController = require('../controllers/authController');

router.post('/register', authController.register);
router.post('/login', authController.login);
// Route to get all users
router.get("/users", authController.getAllUsers);

module.exports = router;
