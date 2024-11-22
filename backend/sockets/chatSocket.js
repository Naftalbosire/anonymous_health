// sockets/chatSocket.js
const { Message } = require('../models/Message');  // CommonJS import

module.exports = (io) => {
  io.on('connection', (socket) => {
    console.log('User connected:', socket.id);

    // Listen for private messages
    socket.on('private_message', async ({ sender, recipient, content }) => {
      try {
        const message = await Message.create({ sender, recipient, content });

        // Emit the message to the recipient
        io.to(recipient).emit('private_message', message);
        socket.emit('private_message', message); // Optionally emit to sender
      } catch (error) {
        console.error('Error sending private message:', error);
      }
    });

    // Listen for disconnect
    socket.on('disconnect', () => {
      console.log('User disconnected:', socket.id);
    });
  });
};
