// sockets/chatSocket.js
const { Message } = require("../models/Message"); // CommonJS import

module.exports = (io) => {
  const userSocketMap = new Map();

  io.on("connection", (socket) => {
    // Map user ID to socket ID
    socket.on("register_user", (userId) => {
      userSocketMap.set(userId, socket.id);
    });

    socket.on("private_message", async ({ sender, recipient, content }) => {
      try {
        const message = await Message.create({ sender, recipient, content });
        console.log(message.content);
        const recipientSocketId = userSocketMap.get(recipient);
        if (recipientSocketId) {
          io.to(recipientSocketId).emit("private_message", message);
          console.log('sent');
        } else {
          console.log("Recipient is offline. Message saved to database.");
        }
        socket.emit("private_message", message); // Optionally emit to sender
      } catch (error) {
        console.log("Error sending private message:", error);
        socket.emit("error", "Failed to send message");
      }
    });

    socket.on("disconnect", () => {
      console.log("User disconnected:", socket.id);
      // Remove user from map
      userSocketMap.forEach((id, userId) => {
        if (id === socket.id) userSocketMap.delete(userId);
      });
    });
  });
};
