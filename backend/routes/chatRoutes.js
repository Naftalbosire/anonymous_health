// routes/chatRoutes.js
const express = require('express');
const router = express.Router();
const chatController = require('../controllers/chatController');
const Message = require('../models/Message');


router.get('/messages', chatController.getMessages);


router.get('/messages/:userId', async (req, res) => {
  try {
    const messages = await Message.find({
      $or: [{ sender: req.params.userId }, { recipient: req.params.userId }],
    }).sort({ timestamp: 1 });
    res.json(messages);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch messages' });
  }
});

module.exports = router;
