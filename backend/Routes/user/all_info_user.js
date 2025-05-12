const User = require('../../Model/User');
const express = require('express');
const router = express.Router();
router.get('/users', async (req, res) => {
  try {
      const users = await User.find();
      res.json(users);
  } catch (err) {
      console.error("Lỗi khi lấy danh sách sách:", err);
      res.status(500).json({ message: err.message });
  }
});

module.exports = router;