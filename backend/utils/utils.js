exports.generateRoomId = (userA, userB) => {
    return [userA, userB].sort().join('_');
}