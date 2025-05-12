const express = require("express");
const router = express.Router();
const User = require("../../Model/User");

router.post("/login", async (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ success: false, error: "Thiếu thông tin bắt buộc." });
    }

    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ success: false, error: "Email không tồn tại." });
        }

        if (password !== user.password) {
            return res.status(400).json({ success: false, error: "Sai mật khẩu." });
        }

        res.json({ success: true, message: "Đăng nhập thành công!" });
    } catch (err) {
        res.status(500).json({ success: false, error: "Lỗi server." });
    }
});

module.exports = router;