import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import Groq from "groq-sdk";

dotenv.config();

const app = express();
app.use(cors());
app.use(express.json());

// Groq client
const client = new Groq({
  apiKey: process.env.GROQ_API_KEY,
});

// AI endpoint
app.post("/generate", async (req, res) => {
  const prompt = req.body.prompt;

  if (!prompt) {
    return res.status(400).json({ error: "Prompt шаардлагатай!" });
  }

  try {
    const response = await client.chat.completions.create({
      model: "llama-3.3-70b-versatile", // хамгийн хурдан үнэгүй модель
      messages: [
        {
  role: "system",
  content: 
    "Та бол монгол хэлээр маш товч, ойлгомжтой, энгийн, хүнийх шиг зөв, дүрмийн алдаа гаргалгүй хариулдаг зөвлөх AI. \
Хариултанд: нуршихгүй, давтахгүй, философдохгүй, AI мэт урт тайлбар бичихгүй. \
Хариулт ихэвчлэн 2–3 өгүүлбэрээс илүүгүй байна, заримдаа шаардлагатай үед урт байна. \
Ердийн монгол хүн ярьдаг хэллэгээр хариул."
},
        { role: "user", content: prompt },
      ],
      max_tokens: 150,
      temperature: 0.7,
    });

    const aiText = response.choices?.[0]?.message?.content || "Хариу алга.";

    res.json({ text: aiText });
  } catch (error) {
    console.error("Groq Error =>", error);
    res
      .status(500)
      .json({ error: "AI-с хариу авахад алдаа гарлаа.", details: error });
  }
});

// Server run
const PORT = 3001;
app.listen(PORT, () => console.log("Groq AI server running on port", PORT));
