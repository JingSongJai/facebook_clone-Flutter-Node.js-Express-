const User = require('../../models/user'); 
const userResource = require('../../resources/user_resource');

countOnlineUser = async (io, socket, onlineUsers) => {
    const newUsers = [...onlineUsers.keys()].filter(id => id !== socket.userId);
    console.log(newUsers);
    const friends = await User.find({
      _id: { $in: newUsers }, 
      'friends.user': socket.userId
    });

    console.log(friends.length);

    io.emit('online', {
      count: friends.length,
      friends: userResource.toOnlyIdCollection(friends)
    });
}

module.exports = countOnlineUser;