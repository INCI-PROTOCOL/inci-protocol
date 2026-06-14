-- INCI PROTOCOL: BEHAVIORAL PREDICTION DATABASE SCHEMA
-- Core engine for the "Trojan Horse" behavioral data collection & Train-to-Earn mechanism.

-- 1. USERS (Anonymous Data Providers)
CREATE TABLE Users (
    user_id UUID PRIMARY KEY,
    wallet_address VARCHAR(42) UNIQUE NOT NULL,
    trust_score DECIMAL(5,2) DEFAULT 50.00, -- Increases with honest feedback
    total_predictions INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. PREDICTION REQUESTS (The Core Input Engine)
CREATE TABLE Prediction_Requests (
    request_id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES Users(user_id),
    target_type VARCHAR(50) NOT NULL, -- e.g., 'Boss', 'Spouse', 'Nation State'
    environment VARCHAR(50) NOT NULL, -- e.g., 'Office', 'Crisis', 'Public Event'
    target_emotion VARCHAR(50) NOT NULL, -- e.g., 'Cornered', 'Confident', 'Anxious'
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. THE FEEDBACK LOOP (Where the real value is created)
CREATE TABLE Actual_Outcomes (
    outcome_id BIGSERIAL PRIMARY KEY,
    request_id BIGSERIAL REFERENCES Prediction_Requests(request_id),
    actual_action_taken TEXT NOT NULL, -- What actually happened in real life
    resolved_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. REWARDS (Train-to-Earn Mechanism)
CREATE TABLE Token_Rewards (
    reward_id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES Users(user_id),
    outcome_id BIGSERIAL REFERENCES Actual_Outcomes(outcome_id),
    inci_tokens_awarded DECIMAL(10,2) NOT NULL,
    tx_hash VARCHAR(66) UNIQUE, -- On-chain transaction proof
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INDEXING FOR FAST AI TRAINING
CREATE INDEX idx_emotion_outcome ON Prediction_Requests(target_emotion);
