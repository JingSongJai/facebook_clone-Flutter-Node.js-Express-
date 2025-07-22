const express = require("express");
const http = require("http");
const { Server } = require("socket.io");
const cors = require("cors");
const logger = require("./middlewares/logger");
const connection = require("./connection/db");
const { errorHandler } = require("./middlewares/error_handler");
const userRoute = require("./routes/user_route");
const postRoute = require("./routes/post_route");
const notifyRoute = require("./routes/notification_route");
const storyRoute = require("./routes/story_route");
const socketHandler = require("./socket/index");
const { socketMiddleware } = require("./middlewares/auth_middleware");
require("dotenv").config();

// Connect to DB
connection();

// Setup Express + HTTP server
const app = express();
const server = http.createServer(app);

// Setup Socket.IO
const io = new Server(server, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

app.use(
  cors({
    origin: "*",
    credentials: true,
  })
);

// Use middleware
app.use(cors());
app.use(logger);
app.use(express.json());

// Routes
app.use("/api/user", userRoute);
app.use("/api/post", postRoute);
app.use("/api/notification", notifyRoute);
app.use("/api/story", storyRoute);
app.use("/api/user/image", express.static("public/user"));

// Error Handler
app.use(errorHandler);

io.use(socketMiddleware);
// Pass io to your socket handler
socketHandler.socketHandler(io);

// Start server
server.listen(process.env.PORT, "0.0.0.0", () => {
  console.log(`🚀 Server running at http://localhost:${process.env.PORT}`);
});
