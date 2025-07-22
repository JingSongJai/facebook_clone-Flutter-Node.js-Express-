const userResource = require("./user_resource");

class StoryResource {
  toJson(story, req) {
    return {
      id: story._id,
      user: userResource.toJsonFriend(story.user, req),
      image: story.image,
      imageUrl: this.getImageUrl(req, story.image, story.user._id),
      createdAt: story.createdAt,
      updatedAt: story.updatedAt,
    };
  }

  toCollection(stories, req) {
    return Array.isArray(stories)
      ? stories.map((story) => this.toJson(story, req))
      : [];
  }

  getImageUrl(req, filename, id) {
    const encodedFilename = encodeURIComponent(filename);
    return `${req.protocol}://${req.get(
      "host"
    )}/api/story/image/${id}/${encodedFilename}`;
  }
}

module.exports = new StoryResource();
