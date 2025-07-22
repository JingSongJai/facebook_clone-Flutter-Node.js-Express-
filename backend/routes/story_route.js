const router = require("express").Router();
const upload = require("../middlewares/story_upload");
const storyController = require("../controllers/story_controller");
const { authMiddleware } = require("../middlewares/auth_middleware");

router.post(
  "/",
  authMiddleware,
  upload.single("image"),
  storyController.addStory
);
router.get("/", authMiddleware, storyController.getStories);
router.get("/image/:id/:filename", storyController.getImage);

module.exports = router;
