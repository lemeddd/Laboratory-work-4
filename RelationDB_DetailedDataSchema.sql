-- Видалення таблиць у випадку їх існування
DROP TABLE IF EXISTS Recommendation CASCADE;
DROP TABLE IF EXISTS Discussion CASCADE;
DROP TABLE IF EXISTS DiscussionRoom CASCADE;
DROP TABLE IF EXISTS CultureTopic CASCADE;
DROP TABLE IF EXISTS User CASCADE;

-- Таблиця: User
CREATE TABLE User (
    user_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор користувача
    name VARCHAR(50) NOT NULL CHECK (name ~ '^[A-Za-zА-Яа-я ]+$'), -- Ім'я користувача
    currentSituation VARCHAR(255) NOT NULL, -- Поточна ситуація
    mood VARCHAR(100) NOT NULL -- Настрій користувача
);

-- Таблиця: Recommendation
CREATE TABLE Recommendation (
    recommendation_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор рекомендації
    type VARCHAR(50), -- Тип рекомендації
    description VARCHAR(500), -- Опис рекомендації (до 500 символів)
    stressLevel INT CHECK (stressLevel BETWEEN 1 AND 10), -- Рівень стресу
    emotionalComfort INT CHECK (emotionalComfort BETWEEN 1 AND 10), -- Рівень емоційного комфорту
    user_id INT NOT NULL REFERENCES User(user_id) ON DELETE CASCADE -- Зовнішній ключ на User
);

-- Таблиця: DiscussionRoom
CREATE TABLE DiscussionRoom (
    room_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор кімнати обговорення
    topic VARCHAR(255) NOT NULL, -- Тема обговорення
    participants TEXT, -- Список учасників
    user_id INT REFERENCES User(user_id) ON DELETE SET NULL -- Зовнішній ключ на User
);

-- Таблиця: CultureTopic
CREATE TABLE CultureTopic (
    culture_topic_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор теми культури
    name VARCHAR(100) UNIQUE NOT NULL CHECK (name ~ '^[A-Za-zА-Яа-я0-9 ]+$'), -- Назва теми
    description VARCHAR(300) -- Опис теми (до 300 символів)
);

-- Таблиця: Discussion
CREATE TABLE Discussion (
    discussion_id SERIAL PRIMARY KEY, -- Унікальний ідентифікатор обговорення
    comments TEXT[], -- Масив коментарів
    questions TEXT[], -- Масив запитань
    room_id INT NOT NULL REFERENCES DiscussionRoom(room_id) ON DELETE CASCADE -- Зовнішній ключ на DiscussionRoom
);

-- Регулярні вирази для текстових полів
-- Обмеження для name (User): тільки букви та пробіли
-- Обмеження для name (CultureTopic): букви, цифри, пробіли

-- Додаткові обмеження:
-- Обмеження на кількість коментарів і запитань
ALTER TABLE Discussion ADD CONSTRAINT max_comments CHECK (array_length(comments, 1) <= 100);
ALTER TABLE Discussion ADD CONSTRAINT max_questions CHECK (array_length(questions, 1) <= 50);
