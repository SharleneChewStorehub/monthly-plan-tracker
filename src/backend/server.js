/**
 * Monthly Subscription Revenue & Retention Tracker
 * Backend API Server
 * 
 * This is the main Express.js server that will serve the API endpoints
 * for the dashboard and handle data processing requests.
 */

const express = require('express');
const cors = require('cors');
const helmet = require('helmet');
const compression = require('compression');
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Security middleware
app.use(helmet());
app.use(cors());
app.use(compression());

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});
app.use('/api/', limiter);

// Body parsing middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Basic health check endpoint
app.get('/health', (req, res) => {
  res.json({ 
    status: 'OK', 
    timestamp: new Date().toISOString(),
    version: process.env.npm_package_version || '1.0.0-alpha'
  });
});

// API routes placeholder
app.get('/api', (req, res) => {
  res.json({
    message: 'Monthly Subscription Revenue & Retention Tracker API',
    version: '1.0.0-alpha',
    endpoints: {
      health: '/health',
      metrics: '/api/metrics (coming soon)',
      cohorts: '/api/cohorts (coming soon)'
    }
  });
});

// Future API route imports will go here
// app.use('/api/metrics', require('./routes/metrics'));
// app.use('/api/cohorts', require('./routes/cohorts'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).json({ 
    error: 'Something went wrong!',
    message: process.env.NODE_ENV === 'development' ? err.message : 'Internal server error'
  });
});

// 404 handler
app.use('*', (req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`📊 Monthly Subscription Tracker API v1.0.0-alpha`);
  console.log(`🔗 Health check: http://localhost:${PORT}/health`);
  console.log(`📡 API base: http://localhost:${PORT}/api`);
});

module.exports = app; 