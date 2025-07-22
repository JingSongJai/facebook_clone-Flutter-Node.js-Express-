const userResource = require('./user_resource'); 

function toJson(notify, req) {
    return {
        isRead: notify.isRead,
        from: userResource.toJsonFriend(notify.from, req), 
        notifyType: notify.notifyType, 
        message: notify.message,
        createdAt: notify.createdAt,
    };
}

function toCollection(notifies, req) {
    return Array.isArray(notifies) ? notifies.map(notify => toJson(notify, req)) : [];
}

module.exports = {
    toJson, 
    toCollection
};