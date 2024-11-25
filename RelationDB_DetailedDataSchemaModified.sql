-- Видалення таблиць у випадку їх існування
DROP TABLE IF EXISTS recommendation CASCADE;
DROP TABLE IF EXISTS discussion CASCADE;
DROP TABLE IF EXISTS discussion_room CASCADE;
DROP TABLE IF EXISTS culture_topic CASCADE;
DROP TABLE IF EXISTS "user" CASCADE;

-- Таблиця: user
CREATE TABLE "user" (
    user_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    name VARCHAR(50) NOT NULL
    CHECK (name ~ '^[A-Za-zА-Яа-я ]+$'), -- Ім'я користувача
    current_situation VARCHAR(255) NOT NULL, -- Поточна ситуація
    mood VARCHAR(100) NOT NULL -- Настрій користувача
);

-- Таблиця: recommendation
CREATE TABLE recommendation (
    recommendation_id SERIAL
    PRIMARY KEY, -- Унікальний ідентифікатор рекомендації
    type VARCHAR(50), -- Тип рекомендації
    description VARCHAR(500), -- Опис рекомендації (до 500 символів)
    stress_level INT CHECK (stress_level BETWEEN 1 AND 10), -- Рівень стресу
    emotional_comfort INT CHECK
    (emotional_comfort BETWEEN 1 AND 10), -- Рівень емоційного комфорту
    user_id INT NOT NULL REFERENCES "user" (user_id)
    ON DELETE CASCADE -- Зовнішній ключ на user
);

-- Таблиця: discussion_room
CREATE TABLE discussion_room (
    room_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор кімнати обговорення
    topic VARCHAR(255) NOT NULL, -- Тема обговорення
    participants TEXT, -- Список учасників
    user_id INT REFERENCES "user" (user_id)
    ON DELETE SET NULL -- Зовнішній ключ на user
);

-- Таблиця: culture_topic
CREATE TABLE culture_topic (
    culture_topic_id SERIAL PRIMARY KEY,
    -- Унікальний ідентифікатор теми культури
    name VARCHAR(100) UNIQUE NOT NULL
    CHECK (name ~ '^[A-Za-zА-Яа-я0-9 ]+$'), -- Назва теми
    description VARCHAR(300) -- Опис теми (до 300 символів)
);

-- Таблиця: discussion
CREATE TABLE discussion (
    discussion_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор обговорення
    comments TEXT [], -- Масив коментарів
    questions TEXT [], -- Масив запитань
    room_id INT NOT NULL REFERENCES discussion_room (room_id)
    ON DELETE CASCADE -- Зовнішній ключ на discussion_room
);

-- Регулярні вирази для текстових полів
-- Обмеження для name (user): тільки букви та пробіли
-- Обмеження для name (culture_topic): букви, цифри, пробіли

-- Додаткові обмеження:
-- Обмеження на кількість коментарів і запитань
ALTER TABLE discussion ADD CONSTRAINT max_comments
CHECK (array_length(comments, 1) <= 100);
ALTER TABLE discussion ADD CONSTRAINT max_questions
CHECK (array_length(questions, 1) <= 50);
