# Online Test Platform - Requirements

## 1. Overview
A backend system where hosts create tests and students attempt them online.
Built with Spring Boot, MySQL and JWT security.
Scope: backend REST APIs only (frontend is separate).

## 2. Actors
- **Admin**: manages users and hosts
- **Host**: creates and manages tests
- **Student**: attempts tests and views results

## 3. Functional Requirements

### Host
- FR-1: Create, edit and delete tests
- FR-2: Add MCQ, coding and text questions to a test
- FR-3: Set start time, end time and duration
- FR-4: Assign tests to students
- FR-5: View submissions and results

### Student
- FR-6: Register and log in
- FR-7: View and attempt only assigned, live tests
- FR-8: Save answers and submit the test
- FR-9: View own result after submission

### Admin
- FR-10: Manage users and hosts

## 4. Non-Functional Requirements
- NFR-1: Support 100 concurrent students
- NFR-2: Submit API responds in under 2 seconds
- NFR-3: A submitted answer must never be lost
- NFR-4: Passwords hashed with BCrypt; APIs protected by JWT
- NFR-5: Suspicious activity (tab switch, duplicate login) is logged

## 5. Core Flows

### Student attempt flow
1. Student logs in and receives a JWT
2. Student sees the list of live tests
3. Student starts an attempt; timer begins
4. Answers are saved while attempting
5. Student submits; MCQs are auto-scored
6. Student views the result

### Host test creation flow
1. Host logs in
2. Host creates a test with title, time and duration
3. Host adds questions
4. Host assigns students
5. Host views results after the test ends

## 6. Out of Scope (for now)
- Frontend UI
- Payments
- Video proctoring