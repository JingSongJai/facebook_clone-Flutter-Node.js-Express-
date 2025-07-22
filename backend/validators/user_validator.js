const { body } = require('express-validator');

const userValidators = [
    body('username')
        .notEmpty().withMessage('Username required!'),
    body('password')
        .notEmpty().withMessage('Password required!')
        .isLength({ min: 8 }).withMessage('Password length is atleast 8 characters')
];

module.exports = userValidators;