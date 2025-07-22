function toJson(post, req) {
    //set image url for user post
    post.user.avatarUrl = `${req.protocol}://${req.host}/api/user/image/${post.user.avatar}`;
    //set image url for likes
    post.likes = post.likes.map(like => {
            like.user.avatarUrl = `${req.protocol}://${req.host}/api/user/image/${like.user.avatar}`;
            return like;
        }
    );
    //set image url for comments
    post.comments = post.comments.map(comment => {
            comment.user.avatarUrl = `${req.protocol}://${req.host}/api/user/image/${comment.user.avatar}`;
            return comment;
        }
    );
    
    //remove __v field
    delete post.__v;


    return ({
        ...post, 
        imageUrls: post.images.map(image => `${req.protocol}://${req.host}/api/post/image/${post.user._id}/${image}`)
    });
}

function toCollection(posts, req) {
    return posts.map(post => toJson(post, req));
}

module.exports = { toJson, toCollection };