const router = require('express').Router(); 
const userController = require('../controllers/user_controller'); 
const validator = require('../validators/user_validator');
const { validationHandler } = require('../middlewares/error_handler');
const upload = require('../middlewares/user_upload');
const { authMiddleware } = require('../middlewares/auth_middleware');

router.post('/register', upload.single('image'), validator, validationHandler, userController.register);
router.post('/login', upload.none(), userController.login);
router.get('/profile', authMiddleware, userController.profile);
router.post('/refresh', userController.refresh);
router.get('/', authMiddleware, userController.getUsers);
router.post('/friend', authMiddleware, userController.addFriend);
router.put('/friend/accept', authMiddleware, userController.acceptFriend);
router.delete('/friend/remove', authMiddleware, userController.removeFriend);
router.delete('/friend/cancel', authMiddleware, userController.cancelSendingFriend);
router.put('/upload', upload.single('image'), authMiddleware, userController.updateCover);

module.exports = router;