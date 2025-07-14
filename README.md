# Monthly Subscription Revenue & Retention Tracker

**Version:** 1.0.0-alpha  
**Status:** Proof of Concept (PoC)  
**Started:** July 12, 2025

## Overview

This project is a **Proof of Concept (PoC)** for tracking monthly subscription revenue and retention metrics. It focuses on a **one-time data export** from May 2025 onwards to validate the entire data pipeline from both MY and Non-MY Chargebee sites.

## 🎯 Project Goals

- **Extract** historical subscription data from both Chargebee sites (May 2025+)
- **Calculate** key revenue and retention metrics for monthly subscription cohorts
- **Visualize** metrics in an intuitive dashboard
- **Validate** concept feasibility before investing in automation

## 📊 Key Metrics Tracked

1. **New Monthly MRR** - Revenue from new monthly subscriptions
2. **Churned MRR** - Revenue lost from cancellations
3. **Net New MRR** - Net growth from monthly initiative
4. **Number of New Monthly Deals** - Volume of new acquisitions
5. **Churned Accounts** - Customer accounts lost
6. **Customer/Logo Churn Rate** - Percentage of customers churning
7. **Monthly-to-Yearly Upgrade Rate** - Conversion to annual plans
8. **Retention Rate** - Both customer and revenue retention by cohort

## 🏗️ Architecture

### Technology Stack
- **Backend:** Node.js + Express.js
- **Frontend:** React + Chart.js
- **Database:** PostgreSQL (Docker) / SQLite (alternative)
- **Data Source:** Chargebee Exports API
- **Hosting:** Local development environment

### Project Structure
```
monthly-sub-tracker/
├── src/
│   ├── backend/          # Express.js API server
│   ├── frontend/         # React dashboard
│   ├── scripts/          # Data processing scripts
│   └── database/         # Database schemas and migrations
├── docs/                 # Project documentation
├── tests/                # Test suites
├── config/               # Configuration files
├── PRD.md               # Product Requirements Document
├── PROJECT_BREAKDOWN.md # Detailed project phases
└── CHANGELOG.md         # Project change log
```

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ and npm
- PostgreSQL (via Docker) or SQLite
- Chargebee TEST site access (both MY and Non-MY sites)

### Installation

1. **Clone the repository:**
   ```bash
   git clone <your-repo-url>
   cd monthly-sub-tracker
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Set up environment variables:**
   ```bash
   cp .env.example .env
   # Edit .env with your actual Chargebee TEST API keys
   ```

4. **Set up database:**
   ```bash
   # Using Docker PostgreSQL
   docker run --name monthly-tracker-db -e POSTGRES_PASSWORD=yourpassword -p 5432:5432 -d postgres

   # Or use SQLite (simpler setup)
   # No additional setup needed - file will be created automatically
   ```

5. **Run database migrations:**
   ```bash
   npm run migrate
   ```

6. **Start the application:**
   ```bash
   # Start backend
   npm run start:backend

   # Start frontend (in another terminal)
   npm run start:frontend
   ```

### Data Processing

1. **Extract data from Chargebee:**
   ```bash
   npm run extract-data
   ```

2. **Process and calculate metrics:**
   ```bash
   npm run process-metrics
   ```

3. **Access dashboard:**
   Open http://localhost:3000 in your browser

## 📖 Documentation

- **[PRD.md](./PRD.md)** - Complete Product Requirements Document
- **[PROJECT_BREAKDOWN.md](./PROJECT_BREAKDOWN.md)** - Detailed project phases and tasks
- **[CHANGELOG.md](./CHANGELOG.md)** - Project progress and changes
- **[docs/](./docs/)** - Technical documentation and API docs

## 🧪 Testing

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test suite
npm run test:backend
npm run test:frontend
```

## 📊 Dashboard Views

### Executive Summary
- Net New MRR overview
- Overall churn rate
- Monthly-to-yearly upgrade rate

### Monthly Flow
- New Monthly MRR trends
- Churned MRR patterns
- Net growth visualization

### Cohort Analysis
- Customer retention tables
- Revenue retention matrices
- Drill-down capabilities

## 🔒 Security

- **API Keys:** Store in `.env` file (never commit)
- **TEST Environment:** Use only TEST Chargebee sites
- **Local Hosting:** No external access required for PoC

## 📈 Current Status

**Phase 1: Project Setup & Environment Configuration** ✅ In Progress
- [x] Project structure and documentation
- [x] GitHub repository setup
- [ ] Local development environment
- [ ] Chargebee API configuration
- [ ] Database schema design

See [CHANGELOG.md](./CHANGELOG.md) for detailed progress updates.

## 🔮 Future Enhancements

After PoC validation:
- **Automated daily refreshes** with schedulers
- **Real-time updates** via Chargebee webhooks
- **Cloud deployment** for production use
- **Advanced analytics** and predictive modeling

## 🤝 Contributing

This is a PoC project. For any changes or suggestions:
1. Check the [PROJECT_BREAKDOWN.md](./PROJECT_BREAKDOWN.md) for current tasks
2. Update [CHANGELOG.md](./CHANGELOG.md) with your changes
3. Follow the established project structure

## 📞 Support

For questions or issues:
- Review the [PRD.md](./PRD.md) for requirements
- Check [CHANGELOG.md](./CHANGELOG.md) for recent changes
- Consult [PROJECT_BREAKDOWN.md](./PROJECT_BREAKDOWN.md) for task details

## 📄 License

This project is proprietary and confidential.

---

**Built with ❤️ for better subscription analytics** 