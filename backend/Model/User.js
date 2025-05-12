const mongoose = require("mongoose");

const User = new mongoose.Schema({
    username: { type: String, required: true, },
    email: { type: String, required: true, unique: true },
    phone: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    thumnail: { type: String, } //If user donn't use thumnail, set default
});

module.exports = mongoose.model("User", User);