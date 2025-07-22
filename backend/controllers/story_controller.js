const Story = require("../models/story");
const storyResource = require("../resources/story_resource");
const path = require("path");

class StoryController {
  async addStory(req, res, next) {
    try {
      const story = await Story.insertOne({
        user: req.user.id,
        image: req.file.filename,
      });

      return res.json({
        message: "Added Story!",
        data: storyResource.toJson(story, req),
      });
    } catch (err) {
      next(err);
    }
  }

  async getStories(req, res, next) {
    try {
      const stories = await Story.find()
        .populate("user", "_id username avatar")
        .lean();

      return res.json({
        message: "Stories Retrieved!",
        data: storyResource.toCollection(stories, req),
      });
    } catch (err) {
      next(err);
    }
  }

  getImage = (req, res, next) => {
    try {
      const { id, filename } = req.params;

      const filePath = path.join(
        process.cwd(),
        "public",
        "story",
        id,
        filename
      );

      return res.sendFile(filePath);
    } catch (err) {
      next(err);
    }
  };
}

module.exports = new StoryController();
