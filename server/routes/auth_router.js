const express = require("express");
const User = require("../models/user_model");
const auth = require("../middlewares/auth_middleware");
const jwt = require("jsonwebtoken");

const authRouter = express.Router();

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;
    let user = await User.findOne({
      email,
    });

    if (!user) {
      user = User({
        name,
        email,
        profilePic,
      });
      user = await user.save();
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_KEY);

    res.json({ user, token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

authRouter.get("/", auth, async (req, res) => {
  const user = await User.findById(res.user);
  res.json({ user, token: req.token });
});

module.exports = authRouter;
