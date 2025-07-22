const logger = (req, res, next) => {
    console.log(`[REST] ${new Date().toISOString()} ${req.method} ${req.originalUrl}`);
    next(); 
}

module.exports = logger;