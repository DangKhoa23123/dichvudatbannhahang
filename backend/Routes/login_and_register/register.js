const express = require("express");
const router = express.Router();
const User = require("../../Model/User");

router.post("/register", async (req, res) => {
  const { email, phone, username, password } = req.body;

  if (!email || !phone || !username || !password) {
    return res
      .status(400)
      .json({ success: false, error: "Thiếu thông tin bắt buộc." });
  }
  try {
    const newUser = new User({
      email,
      phone,
      username,
      password,
    });
    await newUser.save();
    res.json({ success: true, message: "Đăng ký thành công!" });
  } catch (err) {
    if (err.code === 11000) {
      res
        .status(400)
        .json({ success: false, error: "Email và số điện thoại đã tồn tại." });
    } else {
      res.status(500).json({ success: false, error: "Lỗi server." });
    }
  }
});

module.exports = router;
