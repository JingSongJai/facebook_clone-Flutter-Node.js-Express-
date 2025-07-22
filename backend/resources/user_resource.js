function toJson(user, req) {
    return {
        _id: user._id, 
        username: user.username, 
        bio: user.bio || '', 
        avatar: user.avatar, 
        avatarUrl: user.avatar == null ? null : getImageUrl(req, user.avatar),
        cover: user.cover,
        coverUrl: user.cover == null ? null : getImageUrl(req, user.cover),
        friends: Array.isArray(user.friends) ? user.friends.map(friend => ({
            status: friend.status,
            request: friend.request,
            user: toJsonFriend(friend.user, req),
            createdAt: friend.createdAt
        })) : [],
        matualCount: user.matualCount
    };
}

function toCollection(users, req) {
    return users.map(user => toJson(user, req));
}

function toJsonFriend(user, req) {
    return {
        _id: user._id, 
        username: user.username, 
        bio: user.bio || '', 
        avatar: user.avatar, 
        avatarUrl: getImageUrl(req, user.avatar),
    };
}

function toJsonFriendCollection(users, req) {
    return users.friends.map(friend => ({
            status: friend.status,
            request: friend.request,
            user: toJsonFriend(friend.user, req),
            createdAt: friend.createdAt
        }));
}

function toOnlyIdCollection(users) {
    return users.map(user => user.id);
}

function getImageUrl(req, fileName) {
    return `${req.protocol}://${req.get('host')}/api/user/image/${fileName}`
}

module.exports = { toJson, toCollection, toJsonFriend, toJsonFriendCollection, toOnlyIdCollection };