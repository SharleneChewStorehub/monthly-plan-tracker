# Product Requirements Document: Monthly Subscription Revenue & Retention Tracker (PoC - One-Time Data Export)

**Document Version:** 1.4
**Date:** July 12, 2025

---

## 1. Introduction/Overview

This document outlines the requirements for a foundational **"Monthly Subscription Revenue & Retention Tracker,"** focusing on a **one-time data export from May 2025 onwards** for a **Proof of Concept (PoC)**. The primary objective of this PoC is to validate the entire data pipeline: from extracting raw subscription data from **both the MY Chargebee site and the Non-MY Chargebee site**, processing it to derive key metrics and cohort analyses, and finally presenting it in a clear dashboard. This static PoC aims to prove the correctness of calculations and the feasibility of the concept before investing in automated refresh mechanisms. Ultimately, this initiative supports the company's strategic pivot to monthly plans, allowing for validation of tracking capabilities for faster sales cycles and managing churn risks.

---

## 2. Problem Statement

Monthly subscriptions carry a higher risk of churn, posing a significant challenge to long-term revenue predictability. The core problem is the current lack of a dedicated tracking mechanism to monitor the performance and retention of these new monthly subscription cohorts. This PoC aims to definitively prove that a robust system can be built to extract, process, and display the necessary metrics for these cohorts, consolidating data from both Chargebee sites, thereby validating the core concept for future automation.

---

## 3. Goals & Objectives (SMART)

The primary goal for this PoC is to establish a functional, manually updated tracking system to prove the correctness of all calculations and the end-to-end data flow.

* **Specific:** Extract historical data from May 2025 onwards from both Chargebee sites, calculate key revenue and customer retention metrics for new monthly subscription deals, and present them in a dashboard.
* **Measurable:**
    * Successfully **extract data via Chargebee Exports API** from both MY and Non-MY Chargebee sites.
    * **Correctly calculate New Monthly MRR, Churned MRR, and Net New MRR** for May, June, and July cohorts (as of the export date).
    * **Accurately derive Customer/Logo Churn Rate and Monthly-to-Yearly Upgrade Rate** for each monthly cohort.
    * **Correctly count the Number of New Monthly Deals and Churned Accounts** per month.
    * **Accurately calculate and display Retention Rate (by Cohort/Month)** for both accounts and MRR.
* **Achievable:** Leverage Chargebee's Exports API for a one-time data extraction and build a static dashboard for visualization, hosted locally for the PoC.
* **Relevant:** Directly proves the technical feasibility and conceptual soundness of building a system to track monthly subscription performance, providing critical validation for future investment in automation.
* **Time-bound:** Initial dashboard with May onwards data to be operational for validation by **[Target Date - e.g., end of July 2025]**.

---

## 4. Target Audience/Personas

* **Head of Sales:** Will review the calculated metrics and cohort data to confirm their relevance and accuracy for understanding sales performance.
* **Head of Customer Experience (CX):** Will review churn rates and retention data to validate the insights for managing monthly subscribers.
* **Product Team/Development Lead:** Primary audience for validating the technical implementation, data accuracy, and feasibility of the pipeline.
* **Executive Leadership (CEO, CFO):** Will be presented with the PoC to gain confidence in the data's integrity and the project's potential.

---

## 5. User Stories/Use Cases (PoC Focus)

**As a Product Manager/Developer, I want to:**
* Execute a script to pull all relevant subscription data from May 2025 onwards from both Chargebee sites.
* Run a process that consolidates and calculates all specified MRR and retention metrics from this extracted data.
* View a static dashboard that displays these calculated metrics for each monthly cohort (May, June, July) to verify correctness.
* Compare the dashboard figures with manually calculated samples to ensure accuracy.

**As a Head of Sales/CX, I want to:**
* Review the presented dashboard containing May, June, and July data to understand the types of insights the full system will provide.
* Confirm that the definitions and calculations of metrics like "Net New MRR" and "Customer Churn Rate" align with my understanding.

---

## 6. Functional Requirements (PoC Scope)

The system shall:

* **FR1: Data Ingestion from Chargebee (Multi-Site - One-Time Export PoC):**
    * **Primary Mechanism for PoC:** Utilize the **Chargebee Exports API** (`https://apidocs.chargebee.com/docs/api/exports`) to perform a **one-time bulk data extraction** for data from May 2025 onwards.
    * The system will initiate export jobs for relevant data types (e.g., `subscriptions`, `customers`, `invoices`, etc.) from **both the MY and Non-MY Chargebee sites**.
    * Once export jobs are complete, the system will download the generated data files (CSV/JSON).
    * **Data Consolidation:** Consolidate and de-duplicate data from both Chargebee sites into a single, unified dataset. Ensure consistent identifiers or a strategy for handling potential overlaps if customer IDs could exist on both sites (e.g., prefixing with site identifier).
* **FR2: Cohort Definition & Management:**
    * Define **cohorts** based on the month of unified subscription activation for new monthly plans, starting May 2025.
    * Each cohort will consist of all "New Monthly Deals" (Subscription Activation based on Chargebee: invoiced, paid, and with MRR, from either MY or Non-MY site) within that specific calendar month.
    * **Note:** While Chargebee's "Total MRR by Plan" report (`https://www.chargebee.com/docs/billing/1.0/reports-and-analytics/recurring-revenue` - refer to the "Total MRR by Plan" section for its conceptual output structure) provides useful high-level monthly MRR flows, the detailed **cohort retention analysis (churned MRR from a specific cohort over time)** will require processing individual subscription data extracted from exports and calculating changes over time.
* **FR3: Metric Calculation & Aggregation:**
    * Calculate all metrics defined in **Section 8: Metric Definitions** for each monthly cohort and in aggregate, leveraging the consolidated data extracted from the one-time export.
* **FR4: Dashboard Visualization:**
    * Provide an **Executive Summary View** presenting overall, aggregated metrics for all monthly cohorts (e.g., Total Net New MRR, Overall Customer Churn Rate, Overall Monthly-to-Yearly Upgrade Rate).
    * Include a **Monthly Flow View** displaying New Monthly MRR, Churned MRR, and Net New MRR month-over-month.
    * Implement **Cohort Analysis Tables** for both Customer Retention and Revenue Retention:
        * **Rows:** Cohort month (e.g., May 2025, June 2025, July 2025).
        * **Columns:** Months since activation (e.g., M0, M1, M2...).
        * **Cells:** Corresponding retention percentage or raw numbers.
    * Display **"Number of New Monthly Deals"** for each cohort.
    * Provide a **drill-down capability** for each cohort to see churned accounts and upgraded accounts.
* **FR5: Data Granularity & Filters:**
    * Allow filtering by specific cohort months (for the data available from May onwards).
    * Display data at monthly granularity.

---

## 7. Non-Functional Requirements (PoC Scope)

* **Performance:** The data processing script should complete within a reasonable time (e.g., minutes to an hour for the exported data). The dashboard should load quickly (within 5-10 seconds for primary views) after the data is loaded into the local database.
* **Security:** Adhere to best practices for API key management locally (using `.env` files).
* **Usability:** The dashboard must be intuitive and easy for the target audience to navigate and interpret.
* **Reliability:** The data extraction and processing script should be robust enough to handle common API errors or malformed data during the one-time run.
* **Maintainability:** The code base should be well-documented and modular for future enhancements and bug fixes.

---

## 8. Metric Definitions

This section provides clear definitions for all key metrics to be tracked in the Monthly Subscription Revenue & Retention Tracker. All calculations are specific to **new monthly subscriptions activated from May 2025 onwards** and are based on the consolidated data from both Chargebee sites.

* **New Monthly MRR (Monthly Recurring Revenue)**
    * **Definition:** The total recurring revenue added from new monthly subscriptions activated within a specific cohort month. This represents the initial value brought in by new customers opting for monthly plans.
    * **Calculation:** Sum of `mrr` (or equivalent monthly recurring value) for all `active` subscriptions whose `subscription_start_date` falls within the cohort month.
    * **Formula:** $\sum \text{MRR}_{\text{new monthly subscriptions activated in cohort month}}$

* **Churned MRR**
    * **Definition:** The total recurring revenue lost from the cohort of new monthly subscribers due to cancellations or downgrades to $0 MRR. This tracks the financial impact of lost customers from the new monthly initiative.
    * **Calculation:** Sum of `mrr` of subscriptions from the specific cohort that moved to `cancelled` or `non_renewing` status, or whose `mrr` became $0, within a given month.
    * **Formula:** $\sum \text{MRR}_{\text{subscriptions from cohort that churned in given month}}$

* **Net New MRR**
    * **Definition:** The ultimate measure of net growth from this initiative. It represents the new monthly recurring revenue generated minus the recurring revenue lost from churn within the new monthly cohorts.
    * **Calculation:** (New Monthly MRR from the cohort) - (Churned MRR from that cohort up to the current period). For a given month, it's generally (New MRR in that month) - (Churned MRR in that month).
    * **Formula:** $\text{New Monthly MRR} - \text{Churned MRR}$

* **Number of New Monthly Deals (May onwards)**
    * **Definition:** The count of unique customer accounts or logos that activated a new monthly subscription plan within a specific cohort month. This provides a raw volume count of new customer acquisitions for monthly plans.
    * **Calculation:** Count of unique `customer_id` or `account_id` where at least one new monthly subscription was activated in the cohort month.

* **Churned Accounts (by Month)**
    * **Definition:** The number of unique customer accounts from the new monthly cohorts that have cancelled all their monthly subscriptions, or whose monthly subscriptions have all moved to a non-revenue generating status, within a specific reporting month.
    * **Calculation:** Count of unique `customer_id` from the target cohort whose `subscription_status` for all active monthly plans changed to `cancelled` or `non_renewing` in the reporting month.

* **Customer/Logo Churn Rate (by Cohort & Month)**
    * **Definition:** The percentage of customers from a specific new monthly cohort who churned in a given subsequent month, relative to the number of active customers from that cohort at the start of that month. This indicates how many customers are being lost from a specific cohort over time.
    * **Calculation:** (Number of churned customers from cohort in month X) / (Total number of *active* customers from that cohort at the *start* of month X).
    * **Formula:** $\frac{\text{Churned Accounts from cohort in month X}}{\text{Active Accounts from cohort at start of month X}} \times 100\%$

* **Monthly-to-Yearly Upgrade Rate (by Cohort & Month)**
    * **Definition:** The percentage of customers from a specific new monthly cohort who converted from a monthly plan to an annual plan within a given month. This is a critical success metric as it secures long-term revenue and improves cash flow.
    * **Calculation:** (Number of customers from cohort who upgraded from a monthly to an annual plan in month X) / (Total number of *active* monthly customers from that cohort at the *start* of month X). This requires tracking `subscription_changed` events where the `billing_period` changes from monthly to yearly.
    * **Formula:** $\frac{\text{Upgraded Accounts from cohort in month X}}{\text{Active Monthly Accounts from cohort at start of month X}} \times 100\%$

* **Retention Rate (by Cohort/Month)**
    * **Account Retention Rate:**
        * **Definition:** The percentage of initial customer accounts from a cohort that remain active (have at least one active monthly subscription) at the end of each subsequent month.
        * **Calculation:** (Number of active customers from cohort at end of month X) / (Number of initial customers in cohort at M0).
        * **Formula:** $\frac{\text{Active Accounts from cohort at end of month X}}{\text{Initial Accounts in cohort at M0}} \times 100\%$
    * **Revenue Retention Rate:**
        * **Definition:** The percentage of initial MRR from a cohort that is retained at the end of each subsequent month, accounting for churn, upgrades, and any downgrades within the remaining customers. This is also known as Net Revenue Retention (NRR) if considering expansions, or Gross Revenue Retention (GRR) if only considering churn. For this PoC, it will focus on the remaining MRR.
        * **Calculation:** (Sum of MRR from all *active* subscriptions belonging to the cohort at the end of month X) / (Initial New Monthly MRR of cohort at M0).
        * **Formula:** $\frac{\text{MRR from cohort at end of month X}}{\text{Initial New Monthly MRR of cohort at M0}} \times 100\%$

---

## 9. Out-of-Scope Items (for PoC)

* **Automated data refreshes (daily or real-time).** The dashboard will be static once the one-time export and processing are complete.
* Deep-dive analysis into the *reasons* for churn.
* Predictive churn modeling.
* Forecasting future MRR.
* Full CRM integration.
* Detailed P&L or full financial reporting.
* Deployment to a cloud/publicly accessible environment (PoC is purely local).

---

## 10. High-Level Architectural Considerations (PoC Scope)

For this one-time data export PoC, the architecture is streamlined:

* **Data Sources:** Chargebee MY site and Chargebee Non-MY site.
* **Data Extraction & Processing (One-Time Batch):**
    * **Primary API for PoC:** Chargebee **Exports API** (`https://apidocs.chargebee.com/docs/api/exports`).
    * A single, manually executed script will:
        * Initiate export jobs for relevant data (e.g., `subscriptions`, `customers`, `invoices`) from **both Chargebee sites**, specifying a date range from May 2025 onwards.
        * Poll the Exports API until the export jobs are `completed`.
        * Download the generated data files (CSV/JSON).
        * **Merge and consolidate data from both sites into a single, unified dataset.**
        * Process this raw data into the required format for cohort analysis and metric calculation.
        * Load the processed data into the persistent data store.
* **Data Storage:** A lightweight, local relational database (e.g., SQLite for simplicity, or PostgreSQL/MySQL running locally). This will hold the processed, static data for the dashboard.
* **Back-end (API/Logic):**
    * A local API layer to serve the processed data from the database to the front-end dashboard.
    * Preferred languages/frameworks: **Python with Flask/Django** or **Node.js with Express**.
* **Front-end (Dashboard):**
    * A web-based dashboard application.
    * Key technologies/frameworks: **React, Vue.js**, or a lightweight dashboarding library like **D3.js or Chart.js**.
* **Infrastructure/Deployment:**
    * **Purely Local Host:** The entire stack (data processing script, local database, backend API, frontend dashboard) will run on your local machine for the PoC. No external hosting is required at this stage.
* **Security:**
    * API keys for Chargebee (using **TEST SITE API keys**) should be stored securely in local environment variables (e.g., `.env` file).

---

## 11. Implementation Approach and Resources (PoC Focused)

For this "one-time export" PoC, **Full-Code Development** is the recommended approach to achieve the necessary customization and data processing logic.

**Why Full-Code Development is Recommended:**

* **Customization:** Precise control over data extraction, merging from two Chargebee sites, and complex cohort calculations, which are critical for proving the concept.
* **Control:** Full control over the logic and verification of each step.
* **Data Transformation:** The raw data from exports will require significant transformation to create the required metrics and cohort views.

**Detailed Plan for PoC (Local Host & One-Time Export):**

1.  **Project Setup & Version Control (GitHub):**
    * Create a new Git repository on GitHub (e.g., `monthly-mrr-tracker-poc`).
    * Clone this repository to your local development machine.
    * **All code for the data ingestion script, backend API, and frontend dashboard MUST be stored in this GitHub repository.**
    * Use a `main` branch for the PoC code.
    * Maintain a comprehensive `README.md` file with setup and run instructions.
    * **Crucially, add `.env` files and any sensitive configuration files to `.gitignore` to prevent API keys from being committed to the repo.**

2.  **Local Environment Setup:**
    * Install your chosen language runtime (**Python 3.x / Node.js**).
    * Set up a local database (e.g., install **PostgreSQL locally via Docker**, or use **SQLite** for extreme simplicity in the PoC).
    * Create a `.env` file in your project root with placeholders for your **Chargebee Test Site API keys** (one for each MY and Non-MY site) and local database connection string.

3.  **Data Extraction & Processing Script Development (One-Time Execution):**
    * **Focus:** This script will execute manually to pull and process the data.
    * **Using Chargebee Exports API:**
        * Write code to initiate export jobs for `subscriptions` and `invoices` (and potentially `customers` if needed) from **both Chargebee sites** using their respective **TEST API keys**.
        * **Crucially, specify the `created_at` or `updated_at` filters in the export request to fetch data from May 1, 2025, onwards.**
        * Implement a mechanism to poll the Exports API until the export jobs are `completed` and then download the generated CSV/JSON files.
        * **Cursor Guidance:** When writing this code, **instruct Cursor to refer to the Chargebee Exports API documentation (`https://apidocs.chargebee.com/docs/api/exports`)** for correct endpoint usage, parameters (e.g., `entity_type`, filters like `created_at[after]`), and how to handle `export_id` and download URLs. Also, refer to the [Chargebee Python library documentation on PyPI](https://pypi.org/project/chargebee/) or [Node.js library documentation on GitHub](https://github.com/chargebee/chargebee-node) for using `Export.wait_for_export_completion`.
    * **Data Processing & Merging:**
        * Parse the downloaded export files.
        * Implement logic to **merge the data from both Chargebee sites**, handling potential overlaps or de-duplication based on your business rules.
        * Transform the raw subscription and invoice data to calculate the required metrics and construct the cohort structure. This will involve tracking subscription statuses and MRR changes over time from the extracted data.
    * **Database Loading:** Load the processed and structured data into your local database. Design a schema that supports your cohort analysis.

4.  **Backend API Development (Local):**
    * Create API endpoints (e.g., `/api/metrics`, `/api/cohort-retention`) that query your local database to serve the calculated, static metrics to the frontend.

5.  **Frontend Dashboard Development (Local):**
    * Build the user interface.
    * **Cursor's Role in Layout:** You will provide the conceptual layout based on **FR4 (Dashboard Visualization)**. For example, you can tell Cursor: "Generate a React component for an executive summary at the top with three large cards for Net New MRR, Overall Churn, and Upgrade Rate." Then, "Below that, create a line chart for Monthly MRR Flow. And at the bottom, two tables side-by-side for customer and revenue cohort retention." Cursor can generate the *code structure* for these components and their basic styling based on your descriptions, but you will guide the overall visual design and arrangement.
    * Connect the frontend to your local backend API endpoints.

6.  **Local Testing & Validation:**
    * **Crucially, use your Chargebee TEST SITE API keys.**
    * Execute the data extraction and processing script manually.
    * Run your local backend and frontend.
    * Verify that data is flowing correctly from the exported files, calculations are accurate, and the dashboard displays information as expected for May, June, and July data. Compare with any manual sample calculations you have.

---

## 12. Future Considerations/Phases (Post-PoC & Scalability)

Once the PoC is validated, scaling the system will involve enhancing the data ingestion mechanism and potentially optimizing the underlying architecture.

* ### **A. Automated Daily Refreshes:**
    * **Implementation:** Implement a scheduler (e.g., cron job on a VM, cloud scheduler like **AWS EventBridge/GCP Cloud Scheduler**) to automatically trigger the data extraction and processing script daily (e.g., overnight).
    * **Scalability for Daily Refresh:**
        * **Incremental Exports:** If the volume of data grows significantly, explore using `updated_at` filters more effectively in the Exports API or standard List APIs to fetch only changes since the last run, rather than re-exporting all data.
        * **Batch Processing Optimization:** Use libraries optimized for large data processing (e.g., **Pandas in Python**, or distributed processing frameworks if volumes become truly massive like **Apache Spark/Flink**).
        * **Database Indexing:** Ensure proper indexing on `subscription_start_date`, `cancellation_date`, `customer_id`, etc., in your database to optimize query performance for metric calculations.
        * **Compute Resources:** Scale up the compute resources (CPU/RAM) of the server/function running the daily processing job as data volume increases.

* ### **B. Real-time Updates (Live Dashboard):**
    * **Implementation:**
        * **Chargebee Webhooks:** Set up webhooks (`https://apidocs.chargebee.com/docs/api/webhooks`) for critical events (`subscription_created`, `subscription_cancelled`, `subscription_changed`, `invoice_generated`, `invoice_paid`) in *both* your Chargebee MY and Non-MY sites.
        * **Webhook Listener Backend:** Develop a dedicated, publicly accessible endpoint on your server that listens for these incoming webhook notifications.
        * **Event Processing:** Upon receiving a webhook, your backend processes the specific event (e.g., new subscription, churn), updates the relevant record(s) in your database immediately.
        * **Reconciliation Job:** Maintain a daily or hourly reconciliation job (using standard Chargebee List APIs with `updated_at` filters) to catch any webhook events that might have been missed or failed.
    * **Scalability for Real-time:**
        * **Asynchronous Processing:** Use message queues (e.g., **AWS SQS, Google Pub/Sub, Kafka**) to decouple webhook ingestion from processing. Webhooks push messages to the queue, and dedicated workers consume and process them, preventing bottlenecks.
        * **Serverless Functions:** Webhook listeners are ideal candidates for serverless functions (**AWS Lambda, Google Cloud Functions**) as they scale automatically with incoming requests.
        * **Database Sharding/Replication:** For very high read/write loads, consider database replication (read replicas) or sharding to distribute the load.
        * **Caching:** Implement a caching layer (e.g., **Redis**) for frequently accessed dashboard data to reduce database load.
        * **Event Streaming:** For ultimate scale, consider an event streaming platform (e.g., **Apache Kafka, Amazon Kinesis**) to build a robust, real-time data pipeline.

* ### **C. Cloud Deployment:**
    * **Infrastructure:** Deploy the application (backend, database, frontend) to a a robust cloud hosting environment (e.g., **Render, Heroku, AWS, GCP, Azure**). This involves configuring compute instances, managed databases, and potentially static site hosting for the frontend.

* ### **D. Advanced Analytics & Integrations:**
    * **Churn Reason Analysis:** Integrate surveys or feedback mechanisms.
    * **Customer Health Score:** Develop predictive customer health scores.
    * **Advanced Data Warehousing:** For complex analytics beyond current scope, consider a dedicated data warehouse (e.g., **Snowflake, Google BigQuery, AWS Redshift**).

---