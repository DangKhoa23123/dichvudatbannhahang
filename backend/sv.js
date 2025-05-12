const express = require('express');
const dotenv = require('dotenv');
const { connectDB } = require('./config/db');
const path = require('path');
const login = require("./Routes/login_and_register/login");
const register = require("./Routes/login_and_register/register");
const allInfoUser = require('./Routes/user/all_info_user');



dotenv.config();

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));

// 📌 API Login
app.use("", login);
// 📌 API Register
app.use("", register);
// 📌 API All Info User
app.use('', allInfoUser);


connectDB(process.env.MONGO_URI);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
