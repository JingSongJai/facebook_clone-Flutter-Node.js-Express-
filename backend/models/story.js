const mongoose = require("mongoose");

const storySchema = mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    image: String,
  },
  { timestamps: true }
);

const story = mongoose.model("Story", storySchema);

module.exports = story;
