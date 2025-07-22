const mongoose = require("mongoose");

const userSchema = mongoose.Schema(
  {
    username: String,
    password: {
      type: String,
      required: true,
    },
    bio: String,
    avatar: String,
    cover: String,
    friends: [
      {
        _id: false,
        status: {
          type: String,
          enum: ["Accepted", "Pending", "Block"],
          default: "Pending",
        },
        user: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "User",
          required: true,
        },
        createdAt: {
          type: Date,
          default: Date.now,
        },
        request: {
          type: Boolean,
          default: true,
        },
      },
    ],
    notifications: [
      {
        isRead: {
          type: Boolean,
          default: false,
        },
        from: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "User",
          required: true,
        },
        notifyType: {
          type: String,
          enum: ["Reaction", "Comment"],
        },
        message: String,
        createdAt: {
          type: Date,
          default: Date.now,
        },
      },
    ],
    shares: [
      {
        post: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Post",
          required: true,
        },
        text: String,
      },
    ],
    refreshToken: String,
  },
  { timestamps: true }
);

userSchema.set("toJSON", {
  transform: (doc, ret) => {
    ret.id = ret._id;

    delete ret._id;
    delete ret.password;
    delete ret.__v;
  },
});

module.exports = mongoose.model("User", userSchema);
