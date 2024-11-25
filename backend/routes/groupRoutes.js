const express = require('express');
const router = express.Router();
const groupController = require('../controllers/groupController');
const authenticate = require('../middleware/authMiddleware'); // Ensure the user is authenticated

// Create a new group
router.post('/create', authenticate, groupController.createGroup);

// Add a member to a group
router.post('/:groupId/add-member', authenticate, groupController.addMember);

// Send a message in a group
router.post('/:groupId/messages', authenticate, groupController.sendGroupMessage);

// Get messages in a group
router.get('/:groupId/messages', authenticate, groupController.getGroupMessages);

// Get all groups
router.get('/', authenticate, groupController.getAllGroups);

module.exports = router;
