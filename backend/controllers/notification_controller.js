const { sendNotification } = require('../socket/events/notification'); 
const notifyResource = require('../resources/notification_resource');
const User = require('../models/user');

exports.getNotification = async (req, res, next) => {
    try {
        const notifies = await User.findById(req.user.id)
                                   .select('notifications')
                                   .populate('notifications.from');

        console.log(notifies);

        return res.json({ message: 'Notifications Retrieved!', data: notifyResource.toCollection(notifies['notifications'], req)});
    }
    catch (err) {
        next(err);
    }
}