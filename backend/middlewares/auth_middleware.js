const jwt = require('jsonwebtoken');
require('dotenv').config();

const authMiddleware = (req, res, next) => { 
    try {
        const auth = req.headers.authorization;

        if (!auth || auth.split(' ')[0] !== 'Bearer') {
            return res.status(403).json({ error: 'No Token Provided!' });
        }

        const token = auth.split(' ')[1];

        const decode = jwt.verify(token, process.env.SECRET_KEY);

        req.user = decode;

        next();
    }
    catch (err) {
        return res.status(403).json({ error: err.message });
    }
}

const socketMiddleware = (socket, next) => {
    try {
        const token = socket.handshake.auth.token || socket.handshake.headers.token;
        if (!token) return next(new Error('No Token Provided!')); 

        const decode = jwt.verify(token, process.env.SECRET_KEY); 

        socket.userId = decode.id;
        
        next(); 
    }
    catch (err) {
        return next(new Error(err.message));
    }
}

module.exports = { authMiddleware, socketMiddleware };