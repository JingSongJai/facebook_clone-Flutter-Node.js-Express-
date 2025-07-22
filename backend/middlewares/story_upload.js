const multer = require("multer");
const fs = require("fs");

const storyStorage = multer.diskStorage({
  destination: (req, file, cb) => {
    if (!fs.existsSync(`public/story/${req.user.id}`)) {
      fs.mkdirSync(`public/story/${req.user.id}`, { recursive: true });
    }
    cb(null, `public/story/${req.user.id}`);
  },
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${file.originalname}`;

    cb(null, uniqueName);
  },
});

const upload = multer({
  storage: storyStorage,
  fileFilter: (req, file, cb) => {
    const allowedTypes = ["image/jpeg", "image/png"];

    if (allowedTypes.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error("Only image is allowed!"), false);
    }
  },
});

module.exports = upload;
