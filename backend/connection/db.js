const mongoose = require("mongoose");

async function connection() {
  try {
    mongoose.connect("mongodb://localhost:27017/facebook");
    console.log("Connection Successfully!");
  } catch (err) {
    console.log("Connection Failed!");
  }
}

module.exports = connection;
