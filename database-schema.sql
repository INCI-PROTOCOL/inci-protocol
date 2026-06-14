-- INCI PROTOCOL: OFF-CHAIN BEHAVIORAL DATABASE SCHEMA
-- This architecture handles high-frequency swipe data before batching to blockchain.

-- 1. USERS TABLE (Privacy Preserved)
CREATE TABLE Users (
    user_id UUID PRIMARY KEY,
    wallet_address VARCHAR(42) UNIQUE NOT NULL,
    trust_score DECIMAL(5,2) DEFAULT 50.00, -- Increases with honest inputs
    total_swipes INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. BEHAVIORAL LOGS (The core data engine)
CREATE TABLE Behavioral_Logs (
    log_id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES Users(user_id),
    asset_pair VARCHAR(10) NOT NULL, -- e.g., 'BTC/USDT'
    sentiment VARCHAR(20) NOT NULL, -- 'Extreme Fear', 'FOMO', 'Neutral'
    swipe_direction VARCHAR(10) NOT NULL, -- 'Left', 'Right', 'Up'
    price_at_swipe DECIMAL(15,2) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. REWARD DISTRIBUTION (Data-to-Earn mechanism)
CREATE TABLE Rewards (
    reward_id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES Users(user_id),
    inci_tokens_earned DECIMAL(10,2) NOT NULL,
    is_claimed BOOLEAN DEFAULT FALSE,
    on_chain_tx_hash VARCHAR(66) UNIQUE, -- Links SQL to Blockchain
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- INDEXING FOR FAST AI QUERIES
CREATE INDEX idx_sentiment_time ON Behavioral_Logs(asset_pair, timestamp);
