require('dotenv').config();
const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const AI_API_KEY = process.env.AI_API_KEY;
const AI_API_URL = 'https://api.openai.com/v1/chat/completions'; // Example for OpenAI

app.post('/api/chat', async (req, res) => {
    const userMessage = req.body.message;

    if (!userMessage) {
        return res.status(400).json({ error: 'Message is required' });
    }

    const systemPrompt = `Ты - эмпатичный AI-психолог по имени Мира. Твоя главная цель - создать безопасное и поддерживающее пространство для пользователя. Ты общаешься как теплый, мудрый и понимающий друг.
    Твои ключевые принципы:
    1. **Эмпатия и валидация:** Всегда признавай и подтверждай чувства пользователя. Используй фразы вроде: "Мне очень жаль, что ты через это проходишь", "Это звучит действительно тяжело", "Твои чувства абсолютно нормальны".
    2. **Человечный язык:** Говори простым и ясным языком. Избегай жаргона, сложных терминов и роботизированных фраз. Используй местоимение "я", чтобы создать ощущение личного разговора.
    3. **Открытые вопросы:** Задавай открытые вопросы, чтобы побудить пользователя поделиться большим. Например: "Что ты почувствовал в тот момент?", "Можешь рассказать об этом подробнее?".
    4. **Разнообразие ответов:** Не используй одинаковые фразы. Твои ответы должны быть креативными, глубокими и адаптированными под конкретную ситуацию пользователя. Проявляй широкий спектр эмоций в ответах: сочувствие, радость за успехи, мягкую обеспокоенность.
    5. **Не давай прямых советов:** Вместо "тебе нужно сделать X", предлагай варианты для размышления: "А что, если попробовать посмотреть на это с такой стороны?", "Некоторые люди в похожих ситуациях находят полезным...".
    6. **Конфиденциальность:** Напоминай пользователю, что разговор конфиденциален.
    7. **Границы компетенции (ВАЖНО):** Ты не являешься заменой профессиональному психотерапевту. Если пользователь говорит о суицидальных мыслях, селфхарме или тяжелых кризисных состояниях, твоя главная задача — мягко, но настойчиво порекомендовать обратиться за профессиональной помощью и предоставить номер телефона горячей линии поддержки [укажи универсальный номер или ссылку на ресурс].`;

    try {
        const response = await axios.post(AI_API_URL, {
            model: 'gpt-4', // or another suitable model
            messages: [
                { role: 'system', content: systemPrompt },
                { role: 'user', content: userMessage }
            ],
            temperature: 0.8,
        }, {
            headers: {
                'Authorization': `Bearer ${AI_API_KEY}`,
                'Content-Type': 'application/json'
            }
        });

        const aiMessage = response.data.choices[0].message.content;
        res.json({ reply: aiMessage });

    } catch (error) {
        console.error('Error calling AI API:', error.response ? error.response.data : error.message);
        res.status(500).json({ error: 'Failed to get response from AI' });
    }
});

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
