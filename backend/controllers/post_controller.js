const mongoose = require('mongoose');
const Post = require('../models/post');
const User = require('../models/user');
const path = require('path');
const postResource = require('../resources/post_resource');
const { sendNotification } = require('../socket/events/notification');

exports.createPost = async (req, res, next) => {
    try {
        const id = req.user.id;
        const text = req.body.text;
        const images = req.files.map(file => file.filename);

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Wrong format id!' });
        }

        const post = Post({ user: id, text: text, images: images });

        await post.save(); 

        return res.json({ message: 'Post Created!', data: postResource.toJson(post, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.getPosts = async (req, res, next) => {
    try {
        const { userId } = req.query;

        let filter = {}; 
        
        if (userId) filter.user = userId;
        else filter.user = req.user.id;
        
        let posts = await Post.find(filter)
                            .populate('user', 'username avatar')
                            .populate('likes.user', 'username avatar')
                            .populate('comments.user', 'username avatar')
                            .lean();

        return res.json({ message: 'Posts Retreived!', data: postResource.toCollection(posts, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.filterPosts = async (req, res, next) => {
    try {
        const { text, user } = req.query;

        let filter = {}; 

        if (text) filter.text = new RegExp(text, 'i');

        if (user) filter.user = user;
        
        let posts = await Post.find(filter)
                            .populate('user', 'username avatar')
                            .populate('likes.user', 'username avatar')
                            .populate('comments.user', 'username avatar')
                            .lean();

        return res.json({ message: 'Posts Retreived!', data: postResource.toCollection(posts, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.getPost = async (req, res, next) => {
    try {
        const { id } = req.params;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Wrong format id!' }); 
        }

        // get post
        let post = await Post.findById(id)
                            .populate('user', 'username avatar')
                            .populate('likes.user', 'username avatar')
                            .populate('comments.user', 'username avatar')
                            .lean();

        return res.json({ message: 'Post Retreived!', data: postResource.toJson(post, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.likePost = async (req, res, next) => {
    try {
        const id = req.params.id;
        const userId = req.user.id;
        const reactType = req.body.reactType;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Wrong format id!' }); 
        }

        const post = await Post.findById(id);

        if (!post) return res.status(404).json({ message: 'Post not found!' });

        const isLiked = post.likes.find(like => like.user.toString() === userId);
        if (isLiked) {
            isLiked.reactType = reactType;
        }
        else {
            post.likes.push(({ user: userId, reactType: reactType }));
        }

        await post.save();
        
        // get post
        let result = await Post.findById(id)
                            .populate('user', 'username avatar')
                            .populate('likes.user', 'username avatar')
                            .populate('comments.user', 'username avatar')
                            .lean();

        return res.json({ message: 'Post Liked!', data: postResource.toJson(result, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.unLikePost = async (req, res, next) => {
    try {
        const id = req.params.id;
        const userId = req.user.id;
        const reactType = req.body.reactType;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Wrong format id!' }); 
        }

        const post = await Post.findById(id);

        if (!post) return res.status(404).json({ message: 'Post not found!' });

        const isLiked = post.likes.find(like => like.user.toString() === userId);
        if (!isLiked) return res.status(400).json({ message: 'You have not liked this post!' });

        var update = await Post.updateOne(
            {
                _id: id,
                'likes.user': userId
            },
            {
                $pull: { likes: { user: userId } },
            },
            {
                new: true
            }
        );

        console.log(update);

        // get post
        let result = await Post.findById(id)
                            .populate('user', 'username avatar')
                            .populate('likes.user', 'username avatar')
                            .populate('comments.user', 'username avatar')
                            .lean();

        return res.json({ message: 'Post UnLiked!', data: postResource.toJson(result, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.addComment = async (req, res, next) => {
    try {
        const id = req.params.id; 
        const userId = req.user.id;
        const text = req.body.text;

        if (!mongoose.isValidObjectId(id)) {
            return res.status(400).json({ message: 'Wrong format id!' }); 
        }

        const post = await Post.findById(id).populate('user', '_id username');

        post.comments.push(
            ({
                user: userId,
                text: text
            })
        );

        await post.save();

        sendNotification(post.user._id, userId, 'Comment', `${post.user.username} just comment on your post`);
        
        // get post
        let result = await Post.findById(id)
                            .populate('user', 'username avatar')
                            .populate('likes.user', 'username avatar')
                            .populate('comments.user', 'username avatar')
                            .lean();

        return res.json({ message: 'Comment Added!', data: postResource.toJson(result, req) });
    }
    catch (err) {
        next(err);
    }
}

exports.getImage = (req, res, next) => {
    try {
        const { id, filename } = req.params;

        const filePath = path.join(process.cwd(), 'public', 'post', id, filename);

        return res.sendFile(filePath);
    }
    catch (err) {
        next(err);
    }
}