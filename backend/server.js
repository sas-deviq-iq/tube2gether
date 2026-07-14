require('dotenv').config();
const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');

const User = require('./models/User');
const Room = require('./models/Room');

const app = express();
app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// MongoDB Connection
mongoose.connect(process.env.MONGODB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch(err => console.error('MongoDB connection error:', err));

// API: Google Auth (Kept for future use if needed)
app.post('/api/auth/google', async (req, res) => {
  const { idToken } = req.body;
  if (!idToken) return res.status(400).json({ error: 'idToken is required' });

  try {
    const ticket = await googleClient.verifyIdToken({
      idToken,
      audience: process.env.GOOGLE_CLIENT_ID,
    });
    const payload = ticket.getPayload();
    const { sub: googleId, email, name: username, picture: avatarUrl } = payload;

    let user = await User.findOne({ googleId });
    if (!user) user = await User.create({ googleId, email, username, avatarUrl });

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '7d' });
    res.json({ token, user });
  } catch (error) {
    res.status(401).json({ error: 'Invalid Google Token' });
  }
});

// API: Guest Auth (Custom Username Login)
app.post('/api/auth/guest', async (req, res) => {
  const { username } = req.body;
  if (!username || username.trim() === '') {
    return res.status(400).json({ error: 'Username is required' });
  }

  try {
    const trimmedUsername = username.trim();
    // Generate a random Google-like ID for guests
    const guestGoogleId = `guest_${Date.now()}_${Math.random().toString(36).substring(2, 9)}`;
    const avatarUrl = `https://api.dicebear.com/7.x/avataaars/png?seed=${encodeURIComponent(trimmedUsername)}&backgroundColor=b6e3f4,c0aede,d1d4f9,ffdfbf,ffd5dc`;
    
    const user = await User.create({ 
      googleId: guestGoogleId, 
      email: `${guestGoogleId}@guest.tube2gether.local`, 
      username: trimmedUsername, 
      avatarUrl 
    });

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET, { expiresIn: '365d' }); // 1 year token for guests
    res.json({ token, user });
  } catch (error) {
    console.error('Guest Auth Error:', error);
    res.status(500).json({ error: 'Server error creating guest account' });
  }
});

// Volatile room state for fast real-time sync
// memoryRooms[roomId] = { currentVideo: string, state: 'playing'|'paused', time: 0, hostId: string, users: Set }
const memoryRooms = {};

// API: Get Public Rooms
app.get('/api/rooms/public', async (req, res) => {
  try {
    const publicRooms = await Room.find({ isPublic: true }).populate('hostId', 'username avatarUrl');
    // Attach current live state if available
    const response = publicRooms.map(room => {
      const liveState = memoryRooms[room.roomId] || { users: new Set() };
      return {
        _id: room._id,
        roomId: room.roomId,
        host: room.hostId,
        currentVideo: room.currentVideo,
        usersCount: liveState.users.size,
      };
    });
    res.json(response);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Server error' });
  }
});

// Socket.io Middleware for Authentication
io.use(async (socket, next) => {
  try {
    const token = socket.handshake.auth.token;
    if (!token) return next(new Error('Authentication error: Token required'));
    
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const user = await User.findById(decoded.userId);
    if (!user) return next(new Error('Authentication error: User not found'));

    socket.user = user;
    next();
  } catch (err) {
    next(new Error('Authentication error: Invalid token'));
  }
});

io.on('connection', (socket) => {
  console.log(`User connected: ${socket.user.username} (${socket.id})`);

  socket.on('join_room', async ({ roomId, isPublic, videoUrl }) => {
    socket.join(roomId);

    // Initialize memory state if not exists
    if (!memoryRooms[roomId]) {
      memoryRooms[roomId] = {
        hostId: socket.user._id.toString(),
        currentVideo: videoUrl || null,
        state: 'paused',
        time: 0,
        users: new Set()
      };
      
      try {
        // Save/Update in DB
        let dbRoom = await Room.findOne({ roomId });
        if (!dbRoom) {
          dbRoom = await Room.create({
            roomId,
            isPublic: isPublic || false,
            hostId: socket.user._id,
            currentVideo: videoUrl || null
          });
          io.emit('public_rooms_updated');
        } else {
          // If it exists but we are recreating memory state, update host to the current joiner
          dbRoom.hostId = socket.user._id;
          dbRoom.currentVideo = videoUrl || dbRoom.currentVideo;
          dbRoom.isPublic = isPublic !== undefined ? isPublic : dbRoom.isPublic;
          await dbRoom.save();
          if (dbRoom.isPublic) io.emit('public_rooms_updated');
        }
      } catch (e) {
        console.error('Error creating/updating room in DB:', e);
      }
    }
    
    memoryRooms[roomId].users.add(socket.id);
    const isHost = memoryRooms[roomId].hostId === socket.user._id.toString();

    socket.emit('room_joined', { 
      role: isHost ? 'host' : 'guest', 
      roomState: {
        roomId,
        currentVideo: memoryRooms[roomId].currentVideo,
        state: memoryRooms[roomId].state,
        time: memoryRooms[roomId].time
      }
    });

    socket.to(roomId).emit('user_joined', { 
      id: socket.id, 
      userId: socket.user._id,
      username: socket.user.username,
      avatarUrl: socket.user.avatarUrl
    });
  });

  socket.on('video_state_update', ({ roomId, state, time }) => {
    const room = memoryRooms[roomId];
    if (room && room.hostId === socket.user._id.toString()) {
      room.state = state;
      room.time = time;
      socket.to(roomId).emit('sync_video_state', { state, time });
    }
  });

  socket.on('video_seek', ({ roomId, time }) => {
    const room = memoryRooms[roomId];
    if (room && room.hostId === socket.user._id.toString()) {
      room.time = time;
      socket.to(roomId).emit('sync_video_seek', { time });
    }
  });

  socket.on('change_video', async ({ roomId, videoUrl }) => {
    const room = memoryRooms[roomId];
    if (room && room.hostId === socket.user._id.toString()) {
      room.currentVideo = videoUrl;
      room.state = 'paused';
      room.time = 0;
      
      try {
        await Room.updateOne({ roomId }, { currentVideo: videoUrl });
      } catch (e) {
        console.error('Error updating video in DB', e);
      }

      io.to(roomId).emit('video_changed', { videoUrl });
      io.emit('public_rooms_updated'); // Because the video changed
    }
  });

  socket.on('send_message', ({ roomId, message }) => {
    io.to(roomId).emit('receive_message', { 
      userId: socket.user._id,
      username: socket.user.username, 
      avatarUrl: socket.user.avatarUrl,
      message, 
      timestamp: Date.now() 
    });
  });

  socket.on('disconnect', async () => {
    console.log(`User disconnected: ${socket.user.username}`);
    for (const roomId in memoryRooms) {
      const room = memoryRooms[roomId];
      if (room.users.has(socket.id)) {
        room.users.delete(socket.id);
        socket.to(roomId).emit('user_left', { id: socket.id, username: socket.user.username });

        if (room.users.size === 0) {
          delete memoryRooms[roomId];
          try {
            await Room.updateOne({ roomId }, { isPublic: false });
            io.emit('public_rooms_updated');
          } catch (e) {
            console.error(e);
          }
        } else if (room.hostId === socket.user._id.toString()) {
          // Pass host to another active user
          const nextSocketId = Array.from(room.users)[0];
          const nextSocket = io.sockets.sockets.get(nextSocketId);
          if (nextSocket && nextSocket.user) {
            room.hostId = nextSocket.user._id.toString();
            try {
              await Room.updateOne({ roomId }, { hostId: nextSocket.user._id });
            } catch (e) {
              console.error(e);
            }
            io.to(nextSocketId).emit('host_transferred');
          }
        }
      }
    }
  });
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
