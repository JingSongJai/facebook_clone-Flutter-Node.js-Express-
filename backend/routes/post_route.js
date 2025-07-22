const router = require('express').Router();
const postController = require('../controllers/post_controller');
const upload = require('../middlewares/post_upload');
const { authMiddleware } = require('../middlewares/auth_middleware');

router.get('/filter', authMiddleware, postController.filterPosts);
router.post('/', authMiddleware, upload.array('images'), postController.createPost);
router.get('/', authMiddleware, postController.getPosts);
router.get('/:id', authMiddleware, postController.getPost);
router.post('/like/:id', authMiddleware, postController.likePost);
router.post('/unlike/:id', authMiddleware, postController.unLikePost);
router.post('/comment/:id', authMiddleware, postController.addComment);
router.get('/image/:id/:filename', postController.getImage);

module.exports = router;