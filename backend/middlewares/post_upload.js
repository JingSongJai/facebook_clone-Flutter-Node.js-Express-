const multer = require('multer');
const fs = require('fs');

const postStorage = multer.diskStorage({
    destination: (req, file, cb) => {
        if (!fs.existsSync(`public/post/${req.user.id}`)) {
            fs.mkdirSync(`public/post/${req.user.id}`, { recursive: true });
        }
        cb(null, `public/post/${req.user.id}`);
    },
    filename: (req, file, cb) => {
        const uniqueName = `${Date.now()}-${file.originalname}`;
        cb(null, uniqueName);
    }
});

const upload = multer({ storage: postStorage });

module.exports = upload;