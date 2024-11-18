// controllers/groupController.js
const Group = require('../models/Group');
const GroupMessage = require('../models/GroupMessage');
const User = require('../models/User');

// Create a new group
exports.createGroup = async (req, res) => {
  try {
    const { name } = req.body;
    const existingGroup = await Group.findOne({ name });
    if (existingGroup) return res.status(400).json({ message: 'Group name already exists' });

    const group = new Group({ name, members: [req.user.id] });
    await group.save();

    res.status(201).json({ message: 'Group created successfully', data: group });
  } catch (error) {
    res.status(500).json({ message: 'Error creating group', error });
  }
};

// Add a member to a group
exports.addMember = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { memberId } = req.body;

    const group = await Group.findById(groupId);
    if (!group) return res.status(404).json({ message: 'Group not found' });

    if (!group.members.includes(memberId)) {
      group.members.push(memberId);
      await group.save();
    }

    res.status(200).json({ message: 'Member added successfully', data: group });
  } catch (error) {
    res.status(500).json({ message: 'Error adding member', error });
  }
};

// Send a message in a group
exports.sendGroupMessage = async (req, res) => {
  try {
    const { groupId } = req.params;
    const { content } = req.body;

    const groupMessage = new GroupMessage({
      group: groupId,
      sender: req.user.id,
      content,
    });
    await groupMessage.save();

    res.status(201).json({ message: 'Message sent successfully', data: groupMessage });
  } catch (error) {
    res.status(500).json({ message: 'Error sending message', error });
  }
};

// Get messages in a group
exports.getGroupMessages = async (req, res) => {
  try {
    const { groupId } = req.params;

    const messages = await GroupMessage.find({ group: groupId }).sort({ timestamp: 1 });

    res.status(200).json({ message: 'Group messages retrieved successfully', data: messages });
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving group messages', error });
  }
};
