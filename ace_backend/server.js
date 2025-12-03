require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

// POST endpoint: текст генераци хийх
app.post('/generate', async (req, res) => {
    const prompt = req.body.prompt;

    if (!prompt) {
        return res.status(400).json({ error: 'Prompt шаардлагатай' });
    }

    try {
        const response = await axios.post(
            'https://api-inference.huggingface.co/routers/text-generation',
            {
                model: 'google/flan-t5-small',
                inputs: prompt,
                // optional: та хүсвэл additional options нэмэх боломжтой
                parameters: {
                    max_new_tokens: 150
                }
            },
            {
                headers: {
                    Authorization: `Bearer ${process.env.HF_API_KEY}`,
                    'Content-Type': 'application/json'
                }
            }
        );

        // Hugging Face router JSON response нь массивтай ирдэг
        const generatedText =
            response.data?.[0]?.generated_text || 'No response from model';

        res.json({ text: generatedText });
    } catch (err) {
        console.error(err.response?.data || err.message);
        res.status(500).json({ error: 'Error generating text' });
    }
});

// Орчны хувьсагч эсвэл default порт
const SERVER_PORT = process.env.PORT || 3001;

app.listen(SERVER_PORT, () =>
    console.log(`Server running on port ${SERVER_PORT}`)
);
