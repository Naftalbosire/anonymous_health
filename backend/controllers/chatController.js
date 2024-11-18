// controllers/chatController.js
const Message = require('../models/Message');
const User = require('../models/User');

// Send a private message
exports.sendMessage = async (req, res) => {
  try {
    const { recipientId, content } = req.body;
    const senderId = req.user.id;

    const message = new Message({ sender: senderId, recipient: recipientId, content });
    await message.save();

    res.status(201).json({ message: 'Message sent successfully', data: message });
  } catch (error) {
    res.status(500).json({ message: 'Error sending message', error });
  }
};

// Get message history between two users
exports.getMessages = async (req, res) => {
  try {
    const { recipientId } = req.params;
    const senderId = req.user.id;

    const messages = await Message.find({
      $or: [
        { sender: senderId, recipient: recipientId },
        { sender: recipientId, recipient: senderId },
      ],
    }).sort({ timestamp: 1 });

    res.status(200).json({ message: 'Messages retrieved successfully', data: messages });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving messages', error });
  }
};
