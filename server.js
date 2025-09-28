const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Sample data for recommendations
const sampleProducts = [
  {
    id: 'p001',
    name: 'Premium Basmati Rice',
    category: 'Grains',
    price: 120.0,
    reason: 'Popular in your area'
  },
  {
    id: 'p002',
    name: 'Fresh Tomatoes',
    category: 'Vegetables',
    price: 45.0,
    reason: 'Bought together often'
  },
  {
    id: 'p003',
    name: 'Onions',
    category: 'Vegetables',
    price: 35.0,
    reason: 'Bought together often'
  },
  {
    id: 'p004',
    name: 'Cooking Oil',
    category: 'Cooking Essentials',
    price: 150.0,
    reason: 'Popular in your area'
  },
  {
    id: 'p005',
    name: 'Wheat Flour',
    category: 'Grains',
    price: 40.0,
    reason: 'Bought together often'
  },
  {
    id: 'p006',
    name: 'Sugar',
    category: 'Sweeteners',
    price: 50.0,
    reason: 'Popular in your area'
  },
  {
    id: 'p007',
    name: 'Salt',
    category: 'Spices',
    price: 20.0,
    reason: 'Bought together often'
  },
  {
    id: 'p008',
    name: 'Red Lentils (Masoor Dal)',
    category: 'Pulses',
    price: 80.0,
    reason: 'Popular in your area'
  },
  {
    id: 'p009',
    name: 'Chickpeas (Chana)',
    category: 'Pulses',
    price: 70.0,
    reason: 'Bought together often'
  },
  {
    id: 'p010',
    name: 'Green Chilies',
    category: 'Vegetables',
    price: 60.0,
    reason: 'Popular in your area'
  }
];

// Store events for analytics
const events = [];

// Routes

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'OK', message: 'RTG Local Backend is running' });
});

// Recommendations endpoint
app.get('/recommendations', (req, res) => {
  try {
    const { retailerId, limit = 10 } = req.query;
    
    if (!retailerId) {
      return res.status(400).json({ error: 'retailerId is required' });
    }

    // Simple recommendation logic - return random products
    const shuffled = [...sampleProducts].sort(() => 0.5 - Math.random());
    const recommendations = shuffled.slice(0, parseInt(limit));

    res.json({
      retailerId,
      recommendations,
      timestamp: new Date().toISOString()
    });
  } catch (error) {
    console.error('Recommendations error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Events endpoint
app.post('/events', (req, res) => {
  try {
    const { retailerId, type, productId, metadata } = req.body;
    
    if (!retailerId || !type) {
      return res.status(400).json({ error: 'retailerId and type are required' });
    }

    const event = {
      retailerId,
      type,
      productId: productId || null,
      metadata: metadata || {},
      timestamp: new Date().toISOString()
    };

    events.push(event);
    
    // Keep only last 1000 events to prevent memory issues
    if (events.length > 1000) {
      events.splice(0, events.length - 1000);
    }

    res.json({ 
      ok: true, 
      message: 'Event logged successfully',
      eventId: events.length - 1
    });
  } catch (error) {
    console.error('Events error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Get all events (for debugging)
app.get('/events', (req, res) => {
  res.json({
    events,
    count: events.length,
    timestamp: new Date().toISOString()
  });
});

// Get analytics summary
app.get('/analytics', (req, res) => {
  const { retailerId } = req.query;
  
  let filteredEvents = events;
  if (retailerId) {
    filteredEvents = events.filter(e => e.retailerId === retailerId);
  }

  const summary = {
    totalEvents: filteredEvents.length,
    eventsByType: {},
    recentEvents: filteredEvents.slice(-10),
    timestamp: new Date().toISOString()
  };

  // Count events by type
  filteredEvents.forEach(event => {
    summary.eventsByType[event.type] = (summary.eventsByType[event.type] || 0) + 1;
  });

  res.json(summary);
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 RTG Local Backend running at http://localhost:${PORT}`);
  console.log(`📊 Available endpoints:`);
  console.log(`   GET  /health - Health check`);
  console.log(`   GET  /recommendations?retailerId=xxx&limit=10 - Get recommendations`);
  console.log(`   POST /events - Log events`);
  console.log(`   GET  /events - View all events`);
  console.log(`   GET  /analytics?retailerId=xxx - Get analytics`);
  console.log(`\n🔗 Test recommendations: http://localhost:${PORT}/recommendations?retailerId=test123`);
});
