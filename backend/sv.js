const express = require('express');
const dotenv = require('dotenv');
const { connectDB } = require('./config/db');
const path = require('path');
const authRoutes = require("./Routes/auth");
const User = require("./Model/User");


dotenv.config();

const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, 'public')));


app.use("/api", authRoutes);

// 📌 API lấy toàn bộ user
app.get('/api/users', async (req, res) => {
  try {
      const users = await User.find();
      res.json(users);
  } catch (err) {
      console.error("Lỗi khi lấy danh sách sách:", err);
      res.status(500).json({ message: err.message });
  }
});


connectDB(process.env.MONGO_URI);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
