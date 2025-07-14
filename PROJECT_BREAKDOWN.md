# Monthly Subscription Revenue & Retention Tracker - Project Breakdown

**Document Version:** 1.0  
**Date:** July 12, 2025  
**Based on:** PRD v1.4

---

## Project Overview

This document breaks down the **Monthly Subscription Revenue & Retention Tracker PoC** into structured phases and tasks. The project focuses on a **one-time data export** from May 2025 onwards to validate the entire data pipeline and prove concept feasibility before investing in automation.

---

## Phase 1: Project Setup & Environment Configuration

**Duration:** 1-2 days  
**Objective:** Establish foundational infrastructure and development environment

### Tasks:

#### 1.1 Repository & Version Control Setup
- **Description:** Create GitHub repository with proper project structure
- **Deliverables:**
  - GitHub repository: `monthly-sub-tracker`
  - Initial project structure with folders: `/src`, `/docs`, `/scripts`, `/tests`
  - Comprehensive `.gitignore` (exclude `.env`, `node_modules`, database files)
  - Initial `README.md` with project overview
- **Success Criteria:** Repository accessible, proper folder structure, sensitive files excluded

#### 1.2 Local Development Environment
- **Description:** Set up local development stack
- **Technical Requirements:**
  - **Language:** Node.js (preferred per user rules) or Python 3.x
  - **Database:** PostgreSQL (Docker) or SQLite for simplicity
  - **Package Management:** npm/yarn or pip with requirements.txt
- **Deliverables:**
  - Working local development environment
  - Package.json/requirements.txt with dependencies
  - Database connection established
- **Success Criteria:** Environment runs without errors, database accessible

#### 1.3 Chargebee API Configuration
- **Description:** Configure secure API access for both Chargebee sites
- **Requirements:**
  - **TEST API keys only** for both MY and Non-MY Chargebee sites
  - Secure environment variable management
- **Deliverables:**
  - `.env.example` file with placeholder variables
  - Secure API key storage in local `.env`
  - API connection validation script
- **Success Criteria:** Both Chargebee sites accessible via TEST APIs

#### 1.4 Database Schema Design
- **Description:** Design database schema optimized for cohort analysis
- **Key Tables:**
  - `subscriptions` (consolidated from both sites)
  - `customers` (unified customer data)
  - `cohorts` (monthly cohort definitions)
  - `metrics` (calculated metrics storage)
- **Deliverables:**
  - Database schema SQL files
  - Migration scripts
  - Indexing strategy for performance
- **Success Criteria:** Schema supports all required metrics and cohort analysis

---

## Phase 2: Data Extraction & Processing (One-Time Export)

**Duration:** 3-4 days  
**Objective:** Implement robust data extraction and processing pipeline

### Tasks:

#### 2.1 Chargebee Exports API Integration
- **Description:** Implement data extraction using Chargebee Exports API
- **Technical Approach:**
  - Use Chargebee Exports API (`https://apidocs.chargebee.com/docs/api/exports`)
  - Export types: `subscriptions`, `invoices`, `customers`
  - Date filter: May 1, 2025 onwards (`created_at[after]`)
- **Deliverables:**
  - Export initiation script for both sites
  - Polling mechanism for export completion
  - File download and parsing logic
- **Success Criteria:** Successfully exports and downloads data from both sites

#### 2.2 Data Consolidation & Deduplication
- **Description:** Merge data from both Chargebee sites into unified dataset
- **Technical Challenges:**
  - Handle potential customer ID overlaps
  - Implement site identifier prefixing
  - Resolve data inconsistencies
- **Deliverables:**
  - Data consolidation algorithms
  - Deduplication logic
  - Data quality validation checks
- **Success Criteria:** Clean, unified dataset with no duplicates

#### 2.3 Cohort Definition Implementation
- **Description:** Implement cohort logic based on subscription activation dates
- **Business Rules:**
  - Cohorts defined by calendar month of activation
  - Only "New Monthly Deals" (invoiced, paid, with MRR)
  - Starting May 2025
- **Deliverables:**
  - Cohort assignment algorithms
  - Cohort validation logic
  - Cohort summary reports
- **Success Criteria:** Accurate cohort assignments for May, June, July data

#### 2.4 Metrics Calculation Engine
- **Description:** Implement all 8 metrics defined in PRD Section 8
- **Metrics to Calculate:**
  1. New Monthly MRR
  2. Churned MRR
  3. Net New MRR
  4. Number of New Monthly Deals
  5. Churned Accounts
  6. Customer/Logo Churn Rate
  7. Monthly-to-Yearly Upgrade Rate
  8. Retention Rate (Customer & Revenue)
- **Deliverables:**
  - Metric calculation functions
  - Formula validation against PRD definitions
  - Unit tests for each metric
- **Success Criteria:** All metrics calculated correctly per PRD formulas

#### 2.5 Database Loading & Storage
- **Description:** Load processed data into local database
- **Requirements:**
  - Efficient bulk loading
  - Data integrity constraints
  - Performance optimization
- **Deliverables:**
  - Data loading scripts
  - Database population logic
  - Data verification queries
- **Success Criteria:** All processed data stored correctly in database

---

## Phase 3: Backend API Development

**Duration:** 2-3 days  
**Objective:** Create API layer to serve processed data to frontend

### Tasks:

#### 3.1 API Endpoint Development
- **Description:** Build REST API endpoints for dashboard data
- **Required Endpoints:**
  - `GET /api/metrics/summary` - Executive summary data
  - `GET /api/metrics/monthly-flow` - Monthly MRR flow data
  - `GET /api/cohorts/retention` - Cohort retention tables
  - `GET /api/cohorts/{cohort_id}/details` - Drill-down data
  - `GET /api/filters/cohorts` - Available cohort filters
- **Technical Stack:** Express.js (Node.js) or Flask/Django (Python)
- **Deliverables:**
  - API server implementation
  - Route handlers with business logic
  - Response formatting and validation
- **Success Criteria:** All endpoints return correct data format

#### 3.2 API Testing & Validation
- **Description:** Comprehensive testing of API endpoints
- **Testing Approach:**
  - Unit tests for each endpoint
  - Integration tests with database
  - Response validation
- **Deliverables:**
  - Test suite for all endpoints
  - API documentation
  - Performance benchmarks
- **Success Criteria:** All tests pass, API responds within 5-10 seconds

---

## Phase 4: Frontend Dashboard Development

**Duration:** 4-5 days  
**Objective:** Build intuitive dashboard for metric visualization

### Tasks:

#### 4.1 Executive Summary View
- **Description:** Create high-level metrics overview
- **Components:**
  - Three large metric cards: Net New MRR, Overall Churn Rate, Upgrade Rate
  - Key performance indicators
  - Summary statistics
- **Technical Stack:** React (preferred) or Vue.js
- **Deliverables:**
  - Executive summary component
  - Metric cards with styling
  - Responsive design
- **Success Criteria:** Clear, visually appealing summary view

#### 4.2 Monthly Flow Visualization
- **Description:** Implement MRR flow charts over time
- **Components:**
  - Line chart for New Monthly MRR
  - Line chart for Churned MRR
  - Line chart for Net New MRR
  - Month-over-month comparison
- **Technical Tools:** Chart.js or D3.js
- **Deliverables:**
  - Interactive line charts
  - Data point tooltips
  - Time series navigation
- **Success Criteria:** Clear trend visualization with interactive features

#### 4.3 Cohort Analysis Tables
- **Description:** Build cohort retention analysis tables
- **Table Structure:**
  - **Rows:** Cohort months (May 2025, June 2025, July 2025)
  - **Columns:** Months since activation (M0, M1, M2...)
  - **Two Tables:** Customer Retention & Revenue Retention
- **Deliverables:**
  - Cohort table components
  - Percentage and raw number views
  - Color-coded retention rates
- **Success Criteria:** Accurate cohort data presentation with clear visual hierarchy

#### 4.4 Drill-Down Functionality
- **Description:** Implement detailed view for each cohort
- **Features:**
  - Clickable cohort cells
  - Detailed customer lists
  - Churned vs. upgraded account breakdowns
  - Export capabilities
- **Deliverables:**
  - Modal/detail views
  - Customer detail components
  - Data export functionality
- **Success Criteria:** Seamless navigation from summary to detail views

#### 4.5 Filtering & Controls
- **Description:** Add user controls for data exploration
- **Features:**
  - Cohort month filters
  - Date range selection
  - Metric type toggles
  - Data granularity controls
- **Deliverables:**
  - Filter components
  - State management for filters
  - URL parameter handling
- **Success Criteria:** Intuitive filtering with persistent state

---

## Phase 5: Testing & Validation

**Duration:** 2-3 days  
**Objective:** Comprehensive validation of entire system

### Tasks:

#### 5.1 End-to-End Testing
- **Description:** Complete pipeline testing with TEST data
- **Testing Scope:**
  - Data extraction from both Chargebee sites
  - Data processing and metric calculations
  - API responses and dashboard rendering
- **Deliverables:**
  - E2E test scripts
  - Test data validation
  - Performance benchmarks
- **Success Criteria:** Complete pipeline works without errors

#### 5.2 Manual Validation
- **Description:** Verify calculations against manual samples
- **Validation Process:**
  - Manual calculation of key metrics for sample data
  - Comparison with system-generated results
  - Edge case testing
- **Deliverables:**
  - Validation spreadsheets
  - Accuracy reports
  - Bug fixes if needed
- **Success Criteria:** <1% variance between manual and system calculations

#### 5.3 Stakeholder Review
- **Description:** Present PoC to stakeholders for validation
- **Stakeholders:**
  - Head of Sales
  - Head of Customer Experience
  - Product Team/Development Lead
  - Executive Leadership
- **Deliverables:**
  - Demo presentation
  - Stakeholder feedback collection
  - Metric definition confirmation
- **Success Criteria:** Stakeholder approval and metric validation

#### 5.4 Documentation
- **Description:** Create comprehensive project documentation
- **Documentation Required:**
  - Setup and installation guide
  - API documentation
  - User guide for dashboard
  - Technical architecture overview
- **Deliverables:**
  - Updated README.md
  - API documentation
  - User manual
  - Technical documentation
- **Success Criteria:** Complete, clear documentation for future development

---

## Phase 6: Future Enhancement Planning (Post-PoC)

**Duration:** 1-2 days  
**Objective:** Plan next phases for production deployment

### Tasks:

#### 6.1 Automation Design
- **Description:** Design automated daily refresh mechanism
- **Components:**
  - Scheduler implementation (cron jobs)
  - Incremental data processing
  - Error handling and monitoring
- **Deliverables:**
  - Automation architecture design
  - Implementation timeline
  - Resource requirements
- **Success Criteria:** Clear roadmap for automation

#### 6.2 Real-time Architecture Planning
- **Description:** Plan real-time updates using webhooks
- **Components:**
  - Chargebee webhook integration
  - Event processing pipeline
  - Message queue architecture
- **Deliverables:**
  - Real-time architecture design
  - Scalability considerations
  - Implementation strategy
- **Success Criteria:** Comprehensive real-time system design

#### 6.3 Cloud Deployment Strategy
- **Description:** Plan production cloud deployment
- **Considerations:**
  - Cloud provider selection (AWS/GCP/Azure)
  - Infrastructure as Code
  - Security and compliance
  - Monitoring and alerting
- **Deliverables:**
  - Cloud deployment plan
  - Cost estimates
  - Security requirements
- **Success Criteria:** Production-ready deployment strategy

---

## Success Metrics & Acceptance Criteria

### Technical Success Criteria:
- [ ] Data extraction completes successfully from both Chargebee sites
- [ ] All 8 metrics calculated correctly per PRD definitions
- [ ] Dashboard loads within 5-10 seconds
- [ ] API responses within acceptable time limits
- [ ] Zero data integrity issues

### Business Success Criteria:
- [ ] Stakeholder validation of metric definitions
- [ ] Accurate cohort analysis for May, June, July data
- [ ] Clear insights into monthly subscription performance
- [ ] Proof of concept for automated system feasibility

### Quality Assurance:
- [ ] Comprehensive test coverage (>80%)
- [ ] Code follows best practices and is well-documented
- [ ] Security best practices implemented
- [ ] Performance benchmarks met
- [ ] Error handling and logging implemented

---

## Risk Mitigation

### Technical Risks:
- **API Rate Limits:** Use TEST environments and implement proper rate limiting
- **Data Quality Issues:** Implement robust validation and error handling
- **Performance Bottlenecks:** Monitor and optimize database queries

### Business Risks:
- **Metric Definition Misalignment:** Regular stakeholder validation
- **Data Accuracy Concerns:** Comprehensive manual validation process
- **Scope Creep:** Strict adherence to PoC scope as defined in PRD

---

## Timeline Summary

| Phase | Duration | Key Deliverables |
|-------|----------|------------------|
| Phase 1 | 1-2 days | Environment setup, API configuration |
| Phase 2 | 3-4 days | Data extraction and processing pipeline |
| Phase 3 | 2-3 days | Backend API development |
| Phase 4 | 4-5 days | Frontend dashboard |
| Phase 5 | 2-3 days | Testing and validation |
| Phase 6 | 1-2 days | Future planning |
| **Total** | **13-19 days** | **Complete PoC system** |

---

*This breakdown follows the PRD requirements and user rules for thorough planning, Node.js preference, and proactive consideration of future enhancements.* 