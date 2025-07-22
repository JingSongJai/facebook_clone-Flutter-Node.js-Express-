const expressValidation = require('express-validator'); 
const validationResult = expressValidation.validationResult;

const errorHandler = (err, req, res, next) => {
    return res.status(400).json({ message: 'Something wrong!', error: err.message });
}

const validationHandler = (req, res, next) => {
    const errors = validationResult(req);

    if (!errors.isEmpty()) {
        return res.status(400).json({ errors: errors.array() });
    }

    next(); 
}

module.exports = { errorHandler, validationHandler };