-- Monthly Subscription Revenue & Retention Tracker Database Schema
-- This schema supports cohort analysis and metric calculations for monthly subscriptions

-- Enable UUID extension for PostgreSQL (comment out for SQLite)
-- CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Customers table - unified customer data from both Chargebee sites
CREATE TABLE customers (
    id VARCHAR(255) PRIMARY KEY,
    site_identifier VARCHAR(50) NOT NULL, -- 'MY' or 'NON_MY'
    original_customer_id VARCHAR(255) NOT NULL,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    email VARCHAR(255),
    company VARCHAR(255),
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE(site_identifier, original_customer_id)
);

-- Subscriptions table - core subscription data
CREATE TABLE subscriptions (
    id VARCHAR(255) PRIMARY KEY,
    customer_id VARCHAR(255) NOT NULL,
    site_identifier VARCHAR(50) NOT NULL,
    original_subscription_id VARCHAR(255) NOT NULL,
    plan_id VARCHAR(255) NOT NULL,
    plan_name VARCHAR(255),
    billing_period VARCHAR(50) NOT NULL, -- 'month' or 'year'
    status VARCHAR(50) NOT NULL, -- 'active', 'cancelled', 'non_renewing', etc.
    mrr DECIMAL(10, 2) NOT NULL DEFAULT 0,
    subscription_start_date TIMESTAMP NOT NULL,
    subscription_end_date TIMESTAMP,
    cancellation_date TIMESTAMP,
    next_billing_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    UNIQUE(site_identifier, original_subscription_id)
);

-- Cohorts table - monthly cohort definitions
CREATE TABLE cohorts (
    id VARCHAR(255) PRIMARY KEY,
    cohort_month DATE NOT NULL, -- First day of the cohort month (e.g., '2025-05-01')
    cohort_name VARCHAR(100) NOT NULL, -- e.g., 'May 2025'
    initial_customer_count INTEGER NOT NULL DEFAULT 0,
    initial_mrr DECIMAL(10, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    UNIQUE(cohort_month)
);

-- Cohort memberships - tracks which customers belong to which cohorts
CREATE TABLE cohort_memberships (
    id VARCHAR(255) PRIMARY KEY,
    cohort_id VARCHAR(255) NOT NULL,
    customer_id VARCHAR(255) NOT NULL,
    subscription_id VARCHAR(255) NOT NULL,
    initial_mrr DECIMAL(10, 2) NOT NULL,
    activation_date TIMESTAMP NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'active', -- 'active', 'churned', 'upgraded'
    churn_date TIMESTAMP,
    upgrade_date TIMESTAMP,
    created_at TIMESTAMP NOT NULL,
    updated_at TIMESTAMP NOT NULL,
    FOREIGN KEY (cohort_id) REFERENCES cohorts(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(id),
    UNIQUE(cohort_id, customer_id, subscription_id)
);

-- Metrics snapshots - pre-calculated metrics for performance
CREATE TABLE metrics_snapshots (
    id VARCHAR(255) PRIMARY KEY,
    cohort_id VARCHAR(255),
    metric_type VARCHAR(100) NOT NULL, -- 'new_monthly_mrr', 'churned_mrr', 'net_new_mrr', etc.
    metric_period DATE NOT NULL, -- The month this metric applies to
    metric_value DECIMAL(15, 2) NOT NULL,
    metric_count INTEGER DEFAULT 0, -- For count-based metrics
    calculation_date TIMESTAMP NOT NULL,
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (cohort_id) REFERENCES cohorts(id)
);

-- Subscription events - track important subscription lifecycle events
CREATE TABLE subscription_events (
    id VARCHAR(255) PRIMARY KEY,
    subscription_id VARCHAR(255) NOT NULL,
    customer_id VARCHAR(255) NOT NULL,
    event_type VARCHAR(100) NOT NULL, -- 'activation', 'cancellation', 'upgrade', 'downgrade'
    event_date TIMESTAMP NOT NULL,
    old_mrr DECIMAL(10, 2),
    new_mrr DECIMAL(10, 2),
    old_billing_period VARCHAR(50),
    new_billing_period VARCHAR(50),
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    created_at TIMESTAMP NOT NULL,
    FOREIGN KEY (subscription_id) REFERENCES subscriptions(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Indexes for performance optimization
CREATE INDEX idx_customers_site_original ON customers(site_identifier, original_customer_id);
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_customers_created_at ON customers(created_at);

CREATE INDEX idx_subscriptions_customer_id ON subscriptions(customer_id);
CREATE INDEX idx_subscriptions_site_original ON subscriptions(site_identifier, original_subscription_id);
CREATE INDEX idx_subscriptions_status ON subscriptions(status);
CREATE INDEX idx_subscriptions_billing_period ON subscriptions(billing_period);
CREATE INDEX idx_subscriptions_start_date ON subscriptions(subscription_start_date);
CREATE INDEX idx_subscriptions_mrr ON subscriptions(mrr);

CREATE INDEX idx_cohorts_month ON cohorts(cohort_month);

CREATE INDEX idx_cohort_memberships_cohort_id ON cohort_memberships(cohort_id);
CREATE INDEX idx_cohort_memberships_customer_id ON cohort_memberships(customer_id);
CREATE INDEX idx_cohort_memberships_status ON cohort_memberships(status);
CREATE INDEX idx_cohort_memberships_activation_date ON cohort_memberships(activation_date);

CREATE INDEX idx_metrics_snapshots_cohort_id ON metrics_snapshots(cohort_id);
CREATE INDEX idx_metrics_snapshots_type_period ON metrics_snapshots(metric_type, metric_period);

CREATE INDEX idx_subscription_events_subscription_id ON subscription_events(subscription_id);
CREATE INDEX idx_subscription_events_customer_id ON subscription_events(customer_id);
CREATE INDEX idx_subscription_events_type_date ON subscription_events(event_type, event_date);

-- Views for common queries
CREATE VIEW cohort_summary AS
SELECT 
    c.id,
    c.cohort_name,
    c.cohort_month,
    c.initial_customer_count,
    c.initial_mrr,
    COUNT(CASE WHEN cm.status = 'active' THEN 1 END) as current_active_customers,
    SUM(CASE WHEN cm.status = 'active' THEN s.mrr ELSE 0 END) as current_mrr
FROM cohorts c
LEFT JOIN cohort_memberships cm ON c.id = cm.cohort_id
LEFT JOIN subscriptions s ON cm.subscription_id = s.id
GROUP BY c.id, c.cohort_name, c.cohort_month, c.initial_customer_count, c.initial_mrr;

CREATE VIEW monthly_metrics_summary AS
SELECT 
    DATE_TRUNC('month', metric_period) as month,
    SUM(CASE WHEN metric_type = 'new_monthly_mrr' THEN metric_value ELSE 0 END) as new_monthly_mrr,
    SUM(CASE WHEN metric_type = 'churned_mrr' THEN metric_value ELSE 0 END) as churned_mrr,
    SUM(CASE WHEN metric_type = 'net_new_mrr' THEN metric_value ELSE 0 END) as net_new_mrr,
    SUM(CASE WHEN metric_type = 'new_monthly_deals' THEN metric_count ELSE 0 END) as new_monthly_deals,
    SUM(CASE WHEN metric_type = 'churned_accounts' THEN metric_count ELSE 0 END) as churned_accounts
FROM metrics_snapshots
GROUP BY DATE_TRUNC('month', metric_period)
ORDER BY month; 