const mongoose = require('mongoose');

const roomSchema = new mongoose.Schema({
  roomId: {
    type: String,
    required: true,
    unique: true,
  },
  isPublic: {
    type: Boolean,
    default: false,
  },
  hostId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  currentVideo: {
    type: String,
    default: null,
  },
  state: {
    type: String,
    enum: ['playing', 'paused'],
    default: 'paused',
  },
  time: {
    type: Number,
    default: 0,
  },
  // In a real app, users in room are volatile so we might not need to save the array of active users to DB,
  // but we can save history or the creator. Let's keep a list of active users.
  activeUsers: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }]
}, { timestamps: true });

module.exports = mongoose.model('Room', roomSchema);
