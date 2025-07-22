const { onlineUsers } = require('./stores');
const User = require('../models/user');

module.exports.socketHandler = (io) => {
  io.on('connection', async (socket) => {
    console.log('🟢 New socket connected:', socket.id);

    // add user to onlineUsers
    onlineUsers.set(socket.userId, socket.id);
    console.log([...onlineUsers.keys()]);
    console.log(`[Socket] User ${socket.userId} - Online User ${[...onlineUsers.keys()].length}`);
    
    // get user's friends
    const friends = await User.findById(socket.userId).select('friends').lean(); 
    const friendsId = friends.friends.map(friend => friend.user.toString());

    
    // emit to all friends
    friendsId.forEach(id => {
      const friendSocket = onlineUsers.get(id);
      if (friendSocket) {
        io.to(friendSocket).emit('friend_online', { 'id': socket.userId });
      }
    });

    // emit to socket user
    const onlineFriends = friendsId.filter(id => onlineUsers.has(id));
    io.to(socket.id).emit('online', {
      count: onlineFriends.length, 
      friends: onlineFriends, 
    });
    
    socket.on('disconnect', async () => {
      onlineUsers.delete(socket.userId);
      // get user's friends
      const users = await User.findById(socket.userId).select('friends').lean(); 
      const usersId = users.friends.map(user => user.user.toString()); 

      // emit to all user's friends
      usersId.forEach(id => {
        const userSocket = onlineUsers.get(id.toString()); 
        if (userSocket) {
          io.to(userSocket).emit('friend_offline', { 'id': socket.userId });
        }
      });
    });

    socket.on('test', (message) => {
      socket.emit('message', message);
    });
  });
}