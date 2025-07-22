const router = require('express').Router(); 
const notifyController = require('../controllers/notification_controller');
const { authMiddleware } = require('../middlewares/auth_middleware');

router.get('/', authMiddleware, notifyController.getNotification);

module.exports = router;