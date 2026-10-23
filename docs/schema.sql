CREATE DATABASE IF NOT EXISTS online_test_platform;
USE online_test_platform;

-- FR-6, FR-10: all users (admin, host, student)
CREATE TABLE users (
                       id            BIGINT AUTO_INCREMENT PRIMARY KEY,
                       name          VARCHAR(100) NOT NULL,
                       email         VARCHAR(150) NOT NULL UNIQUE,
                       password_hash VARCHAR(255) NOT NULL,
                       role          ENUM('ADMIN', 'HOST', 'STUDENT') NOT NULL,
                       created_at    DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- FR-1, FR-3: tests created by hosts
CREATE TABLE tests (
                       id               BIGINT AUTO_INCREMENT PRIMARY KEY,
                       host_id          BIGINT NOT NULL,
                       title            VARCHAR(200) NOT NULL,
                       description      TEXT,
                       start_time       DATETIME NOT NULL,
                       end_time         DATETIME NOT NULL,
                       duration_minutes INT NOT NULL,
                       created_at       DATETIME DEFAULT CURRENT_TIMESTAMP,
                       FOREIGN KEY (host_id) REFERENCES users(id),
                       CHECK (end_time > start_time),
                       INDEX idx_tests_time (start_time, end_time)
);

-- FR-2: questions inside a test
CREATE TABLE questions (
                           id            BIGINT AUTO_INCREMENT PRIMARY KEY,
                           test_id       BIGINT NOT NULL,
                           type          ENUM('MCQ', 'CODING', 'TEXT') NOT NULL,
                           question_text TEXT NOT NULL,
                           marks         INT NOT NULL DEFAULT 1,
                           FOREIGN KEY (test_id) REFERENCES tests(id) ON DELETE CASCADE
);

-- Options for MCQ questions
CREATE TABLE question_options (
                                  id          BIGINT AUTO_INCREMENT PRIMARY KEY,
                                  question_id BIGINT NOT NULL,
                                  option_text VARCHAR(500) NOT NULL,
                                  is_correct  BOOLEAN NOT NULL DEFAULT FALSE,
                                  FOREIGN KEY (question_id) REFERENCES questions(id) ON DELETE CASCADE
);

-- FR-4: which student can take which test
CREATE TABLE test_assignments (
                                  id         BIGINT AUTO_INCREMENT PRIMARY KEY,
                                  test_id    BIGINT NOT NULL,
                                  student_id BIGINT NOT NULL,
                                  FOREIGN KEY (test_id)    REFERENCES tests(id) ON DELETE CASCADE,
                                  FOREIGN KEY (student_id) REFERENCES users(id),
                                  UNIQUE (test_id, student_id)
);

-- FR-7, FR-8: one attempt per student per test
CREATE TABLE attempts (
                          id           BIGINT AUTO_INCREMENT PRIMARY KEY,
                          test_id      BIGINT NOT NULL,
                          student_id   BIGINT NOT NULL,
                          started_at   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                          submitted_at DATETIME NULL,
                          status       ENUM('IN_PROGRESS', 'SUBMITTED', 'EXPIRED') NOT NULL DEFAULT 'IN_PROGRESS',
                          score        DECIMAL(6,2) NULL,
                          FOREIGN KEY (test_id)    REFERENCES tests(id),
                          FOREIGN KEY (student_id) REFERENCES users(id),
                          UNIQUE (test_id, student_id)
);

-- FR-8, NFR-3: one answer per question per attempt
CREATE TABLE answers (
                         id                 BIGINT AUTO_INCREMENT PRIMARY KEY,
                         attempt_id         BIGINT NOT NULL,
                         question_id        BIGINT NOT NULL,
                         selected_option_id BIGINT NULL,
                         answer_text        TEXT NULL,
                         FOREIGN KEY (attempt_id)         REFERENCES attempts(id) ON DELETE CASCADE,
                         FOREIGN KEY (question_id)        REFERENCES questions(id),
                         FOREIGN KEY (selected_option_id) REFERENCES question_options(id),
                         UNIQUE (attempt_id, question_id)
);

-- NFR-5: suspicious activity (tab switch etc.)
CREATE TABLE activity_logs (
                               id         BIGINT AUTO_INCREMENT PRIMARY KEY,
                               attempt_id BIGINT NOT NULL,
                               event_type VARCHAR(50) NOT NULL,
                               created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (attempt_id) REFERENCES attempts(id) ON DELETE CASCADE
);