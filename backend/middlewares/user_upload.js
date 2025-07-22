const multer = require('multer'); 

const userStorage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'public/user');
    },
    filename: (req, file, cb) => {
        const uniqueName = `${Date.now()}-${file.originalname}`;
        cb(null, uniqueName);
    }
});

function filterImage(req, file, cb) {
    console.log(file);
    const allowTypes = ['image/jpeg', 'image/png']; 

    if (allowTypes.includes(file.mimetype)) {
        cb(null, true); 
    }
    else {
        cb(new Error('Only image are allowed!'), false);
    }
}

const upload = multer({ storage: userStorage, fileFilter: filterImage, limits: { fileSize: 1 * 1024 * 1024, files: 1 } }); 

module.exports = upload;