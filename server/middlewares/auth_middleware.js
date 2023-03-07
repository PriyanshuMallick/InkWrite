const jwt = require("jsonwebtoken");

const auth = async (req, res, next) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) {
      return res.status(401).json({ msg: "No auth token, access denied." });
    }
    const verified = jwt.verify(token, process.env.JWT_KEY);
    if (!verified) {
      return res
        .status(401)
        .json({ msg: "Token is not valid, authorization DENIED!" });
    }

    req.user = verified.id;
    req.token = token;
    next();
  } catch (e) {
    res.status(500).json({ msg: e.message });
  }
};

module.exports = auth;
