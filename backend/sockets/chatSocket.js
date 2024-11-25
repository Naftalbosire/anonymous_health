// sockets/chatSocket.js
const Message = require("../models/Message"); // CommonJS import

module.exports = (io) => {
  const userSocketMap = new Map();

  io.on("connection", (socket) => {
    console.log('User connected');

    // Register the user when they connect
    socket.on("register_user", (userId) => {
      userSocketMap.set(userId, socket.id);
    });

    // Listen for private messages
    socket.on("private_message", async ({ sender, recipient, content }) => {
      console.log('Private message received');
      try {
        // Create a new message in the database
        const message = await Message.create({ sender, recipient, content });
        console.log("Message created:", message.content);

        // Emit the message to the recipient if they are online
        const recipientSocketId = userSocketMap.get(recipient);
        if (recipientSocketId) {
          io.to(recipientSocketId).emit("private_message", message);
          console.log("Message sent to recipient");
        } else {
          console.log("Recipient is offline. Message saved to database.");
        }

        // Emit the message back to the sender for confirmation
        socket.emit("private_message", message);

      } catch (error) {
        console.error("Error sending private message:", error);
        socket.emit("error", "Failed to send message");
      }
    });

    // Handle user disconnect
    socket.on("disconnect", () => {
      console.log("User disconnected:", socket.id);
      userSocketMap.forEach((id, userId) => {
        if (id === socket.id) userSocketMap.delete(userId);
      });
    });
  });
};
