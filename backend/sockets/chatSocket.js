// sockets/chatSocket.js
const { Message, GroupMessage } = require('../models'); // Load models

module.exports = (io) => {
  io.on('connection', (socket) => {
    console.log('User connected:', socket.id);

    // Private Chat
    socket.on('private_message', async ({ sender, recipient, content }) => {
      const message = await Message.create({ sender, recipient, content });
      io.to(recipient).emit('private_message', message);
    });

    // Group Chat
    socket.on('group_message', async ({ groupId, sender, content }) => {
      const groupMessage = await GroupMessage.create({ group: groupId, sender, content });
      io.to(groupId).emit('group_message', groupMessage);
    });

    socket.on('disconnect', () => {
      console.log('User disconnected:', socket.id);
    });
  });
};
