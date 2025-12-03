const express = require("express");
const mysql = require("mysql2");
const bodyParser = require("body-parser");
const cors = require("cors");
const bcrypt = require("bcrypt");

const app = express();
const port = 3000;

app.use(cors());
app.use(bodyParser.json());

// MySQL холболт
const db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "Wyn53trv.",
  database: "ace_app"
});

db.connect(err => {
  if (err) throw err;
  console.log("MySQL connected!");
});

// ---------------------
// БҮРТГЭЛ
// ---------------------
app.post("/register", async (req, res) => {
  const { username, email, password } = req.body;

  const hashedPassword = await bcrypt.hash(password, 10);

  db.query(
    "SELECT * FROM users WHERE username = ? OR email = ?",
    [username, email],
    (err, results) => {
      if (err) return res.json({ status: "error", message: err });

      if (results.length > 0) {
        return res.json({
          status: "error",
          message: "Хэрэглэгч өмнө нь бүртгүүлсэн байна"
        });
      }

      db.query(
        "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
        [username, email, hashedPassword],
        (err2, results2) => {
          if (err2) return res.json({ status: "error", message: err2 });

          res.json({ status: "success", message: "Бүртгэл амжилттай" });
        }
      );
    }
  );
});

// ---------------------
// НЭВТРЭХ
// ---------------------
app.post("/login", (req, res) => {
  const { username, password } = req.body;

  db.query(
    "SELECT * FROM users WHERE username = ?",
    [username],
    async (err, results) => {
      if (err) return res.json({ status: "error", message: err });

      if (results.length === 0) {
        return res.json({
          status: "error",
          message: "Хэрэглэгч олдсонгүй"
        });
      }

      const user = results[0];
      const match = await bcrypt.compare(password, user.password);

      if (!match) {
        return res.json({
          status: "error",
          message: "Нууц үг буруу байна"
        });
      }

      // ✅ username буцаана profile авахад хэрэг болно
      res.json({
        status: "success",
        message: "Амжилттай нэвтэрлээ",
        username: user.username
      });
    }
  );
});

// ---------------------
// МИНИЙ МЭДЭЭЛЭЛ (PROFILE)
// ---------------------
app.get("/profile/:username", (req, res) => {
  const { username } = req.params;

  db.query(
    "SELECT username, email FROM users WHERE username = ?",
    [username],
    (err, results) => {
      if (err) return res.json({ status: "error", message: err });

      if (results.length === 0) {
        return res.json({ status: "error", message: "Хэрэглэгч олдсонгүй" });
      }

      res.json({
        status: "success",
        profile: results[0]
      });
    }
  );
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
