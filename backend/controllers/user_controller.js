const User = require('../models/user');
const bcrypt = require('bcrypt'); 
const jwt = require('jsonwebtoken'); 
const user = require('../models/user');
const userResource = require('../resources/user_resource');
const mongoose = require('mongoose');
require('dotenv').config();

exports.register = async (req, res, next) => {
    const { username, password } = req.body;
    const avatar = req.file.filename || null;

    try {
        const hashedPassword = await bcrypt.hash(password, 10);
        const user = User({ username: username, password: hashedPassword, avatar: avatar || null });

        await user.save(); 

        return res.json({ message: 'User Registered!' });
    } 
    catch (err) {
        next(err);
    }
}

exports.login = async (req, res, next) => {
    try {
        const username = req.body.username;
        const password = req.body.password;

        const user = await User.findOne({ username: username });
        if (!user) return res.status(401).json({ message: 'Wrong username or password!' });

        const compare = await bcrypt.compare(password, user.password);
        if (!compare) return res.status(401).json({ message: 'Wrong username or password!' });

        //generate access token
        const token = jwt.sign(
            { id: user.id, username: user.username },
            process.env.SECRET_KEY, 
            {
                expiresIn: process.env.EXPIRE_IN
            } 
        );

        //generate refresh token
        const refreshToken = jwt.sign(
            { id: user.id }, 
            process.env.REFRESH_SECRET_KEY, 
            {
                expiresIn: '3w'
            }
        );

        user.refreshToken = refreshToken;
        await user.save(); 

        return res.json({ message: 'Login Successfully!', token: token, refreshToken: refreshToken });
    }
    catch (err) {
        next(err);
    }
}

exports.profile = async (req, res, next) => {
    try {
        const user = await User.findById(req.query.id || req.user.id)
                                .populate('friends.user')
                                .populate('notifications.from');

        return res.json({ data: userResource.toJson(user, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.refresh = async (req, res, next) => {
    try {
        const { refreshToken } = req.body;

        const decode = jwt.verify(refreshToken, process.env.REFRESH_SECRET_KEY);

        const user = await User.findById(decode.id);
        if (!user || !user.refreshToken || user.refreshToken !== refreshToken) {
            return res.status(401).json({ message: 'Invalid refresh token!' });
        }

        const newAccessToken = jwt.sign(
            { id: user.id, username: user.username }, 
            process.env.SECRET_KEY, 
            {
                expiresIn: process.env.EXPIRE_IN
            }
        );

        return res.json({ accessToken: newAccessToken });
    }
    catch (err) {
        next(err); 
    }
}

exports.getUsers = async (req, res, next) => {
    try {
        const other = req.query.other;
        const friend = req.query.friend;
        const request = req.query.request;
        const userId = req.query.userId || null;
        const name = req.query.name || ''; 
        const sort = req.query.sort; 


        let sortFilter = {};

        if (sort) {
            sortFilter = { 'friends.createdAt': parseInt(sort) }; 
        }

        let filter = {
            _id: { $ne: userId ?? req.user.id },
            username: { $regex: name, $options: 'i' }
        }; 

        if (other) {
            filter['friends.user'] = { $ne: req.user.id }; 
        }
        
        if (friend) {
            filter.friends = {
                $elemMatch: {
                    user: userId ?? req.user.id,
                    status: 'Accepted'
                }
            }
        }

        if (request) {
            filter.friends = {
                $elemMatch: {
                    user: userId ?? req.user.id,
                    status: 'Pending'
                }
            }
        }

        let users = await User.find(filter)
                                .sort(sortFilter)
                                .populate('friends.user')
                                .lean(); 

        users = await Promise.all(users.map(async user => {
            const matualCount = await User.countDocuments({
                'friends.user': { $all: [userId ?? req.user.id, user._id.toString() ] }
            });

            user.matualCount = matualCount;
            return user;
        }));

        return res.json({ message: 'Users retreived!', data: userResource.toCollection(users, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.getUser = async (req, res, next) => {
    try {
        const id = req.params.id || req.user.id;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Invalid format id!' }); 
        }

        const user = await User.findById(id)
                               .populate('friends.user'); 
        if (!user) return res.status(400).json({ message: 'User not found!' }); 

        return res.json({ message: 'User found!', data: userResource.toJson(user, req) }); 
    }
    catch (err) {
        next(err);
    }
}

exports.addFriend = async (req, res, next) => {
    try {
        const userId = req.body.userId;
        const id = req.user.id;

        if (userId === id) return res.status(400).json({ message: 'Id can\'t be the same' });

        if (!mongoose.isValidObjectId(userId) || !mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Invalid format id!' }); 
        }

        const user = await User.findById(userId); 
        if (!user) return res.status(400).json({ message: 'User not found!' }); 
        
        const exist = user.friends.some(friend => friend.user.toString() === id);
        if (exist) return res.status(400).json({ message: 'Already sent!' });

        const me = await User.findById(id);

        user.friends.push(({
            user: id,
            request: false
        }));

        me.friends.push(({
            user: user._id
        }))

        await user.save(); 
        await me.save();

        return res.json({ message: 'Sent as friend!' });
    }
    catch (err) {
        next(err);
    }
}

exports.acceptFriend = async (req, res, next) => {
    try {
        const userId = req.body.userId;
        const id = req.user.id;

        if (userId === id) return res.status(400).json({ message: 'Id can\'t be the same' });

        if (!mongoose.isValidObjectId(userId) || !mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Invalid format id!' }); 
        }

        const user = await User.findById(userId); 
        if (!user) return res.status(400).json({ message: 'User not found!' }); 

        const isUpdated = await User.updateMany(
            { 
                _id: { $in: [userId, id] },
                'friends.user': { $in: [userId, id] }
            },
            { $set: {'friends.$.status': 'Accepted'} }
        );

        if (!isUpdated) return res.status(400).json({ message: 'Updated fail!' });

        return res.json({ message: 'Accepted successfully!' });
    }
    catch (err) {
        next(err);
    }
}

exports.removeFriend = async (req, res, next) => {
    try {
        const userId = req.body.userId;
        const id = req.user.id;

        if (userId === id) return res.status(400).json({ message: 'Id can\'t be the same' });

        if (!mongoose.isValidObjectId(userId) || !mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Invalid format id!' }); 
        }

        const user = await User.findById(userId); 
        if (!user) return res.status(400).json({ message: 'User not found!' }); 

        const isUpdated = await User.updateMany(
            { 
                _id: { $in: [userId, id] },
                'friends.user': { $in: [userId, id] },
                'friends.status': { $in: ['Accepted', 'Block'] }
            }, 
            {
                $pull: { 'friends': { user: { $in: [id, userId] } } }
            }
        );

        if (!isUpdated) return res.status(400).json({ message: 'Updated fail!' });

        return res.json({ message: 'Removed successfully!' });
    }
    catch (err) {
        next(err);
    }
}

exports.cancelSendingFriend = async (req, res, next) => {
    try {
        const userId = req.body.userId;
        const id = req.user.id;

        if (userId === id) return res.status(400).json({ message: 'Id can\'t be the same' });

        if (!mongoose.isValidObjectId(userId) || !mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Invalid format id!' }); 
        }

        const user = await User.findById(userId); 
        if (!user) return res.status(400).json({ message: 'User not found!' }); 

        const isDeleted = await User.updateMany(
            {
                _id: { $in: [userId, id] },
                'friends.user': { $in: [userId, id] },
                'friends.status': 'Pending'
            },
            {
                $pull: { 'friends': { user: { $in: [userId, id] } } }
            }
        );

        return res.json({ message: 'Canceled successfully!' });
    }
    catch (err) {
        next(err);
    }
}

exports.updateCover = async (req, res, next) => {
    try {
        const profile = req.query.profile;

        if (!profile) {
            const update = await User.findByIdAndUpdate(req.user.id, {
                $set: { cover: req.file.filename || null }
            });
        } 
        else {
            const update = await User.findByIdAndUpdate(req.user.id, {
                $set: { avatar: req.file.filename || null }
            });
        }

        return res.json({ message: 'Image Updated!' });
    }
    catch (err) {
        next(err);
    }
}