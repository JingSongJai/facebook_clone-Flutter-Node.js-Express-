const { onlineUsers } = require('../stores'); 
const User = require('../../models/user');

module.exports.sendNotification = async (toUserId, from, notifyType, message) => {
  console.log(`${toUserId} - ${[...onlineUsers.keys()]}`);
  const receiveSocket = onlineUsers.get(toUserId); 
  const update = await User.findByIdAndUpdate(toUserId, {
    $push: {
      notifications: { 
        'from': from, 
        'notifyType': notifyType, 
        'message': message
      }
    }
    },
    {
      new: true
    }
  );

  if (receiveSocket) {
    receiveSocket.emit(
      'notification', 
      {
        from, 
        notifyType, 
        message
    });
  }
  else {
    console.log(`User ${toUserId} is not online`);
  }
}