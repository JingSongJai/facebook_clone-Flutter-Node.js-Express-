const mongoose = require('mongoose');

const postSchema = mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User'
    },
    text: String, 
    images: [
        String
    ], 
    likes: [
        {
            user: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'User'
            },
            reactType: {
                type: String, 
                enum: ['Like', 'Love', 'Care', 'Laugh', 'Sad', 'Angry', 'Wow']
            }
        }
    ],
    comments: [
        {
            user: {
                type: mongoose.Schema.Types.ObjectId,
                ref: 'User'
            },
            text: String, 
            createdAt: {
                type: Date, 
                default: Date.now
            }
        }
    ]
}, { timestamps: true, toJSON: { virtuals: true }, toObject: { virtuals: true } });

postSchema.set('toJSON', {
    transform: (doc, ret) => {
        delete ret.__v;
        return ret;
    }
});

// postSchema.virtual('imageUrls').get(function () {
//     return this.images.map(image => `http://localhost:3000/api/post/image/${post.user._id}/${image}`);
// });

module.exports = mongoose.model('Post', postSchema);