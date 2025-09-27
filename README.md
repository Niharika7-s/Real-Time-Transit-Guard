# Real-Time-Transit-Guard

## Problem Statement
Local vendors, including kirana stores and HORECA businesses, rely on B2B platforms for supplies but face several operational challenges:

- **Product Visibility Issues:** Many relevant products go unnoticed, limiting inventory variety.  
- **Repetitive Purchasing:** Retailers often reorder the same items, missing opportunities for cross-selling.  
- **Flat Order Value:** Average Order Value (AOV) remains stagnant without personalized suggestions.  
- **Unclear Order Status:** Generic updates like “Dispatched” force vendors to make multiple follow-up calls.  
- **Low Platform Retention:** Around one-third of retailers stop using the platform within six months due to poor shopping experiences.  

These challenges cause inefficiencies in inventory management, staff scheduling, and revenue optimization.  

---

## Proposed Solution
We propose a **hybrid mobile and web prototype** integrating **real-time order tracking, AI-based product recommendations, dynamic notifications, feedback, and sharing features**, giving vendors complete visibility and actionable insights.  

### Core Components

#### 1. Unified Real-Time Tracking Map (RTGM)
- Real-time GPS tracking of inbound orders.  
- Traffic-aware routes and estimated time/distance remaining.  
- Accessible on both mobile (Flutter) and web platforms.  

#### 2. Predictive ETA & Alerts (P-ETA)
- Combines historical delivery patterns and live route conditions to forecast delays.  
- Sends early notifications to vendors for better operational planning.  

#### 3. Supplier Preparation Timeline
- Displays each stage from order confirmation to dispatch.  
- Helps vendors schedule staff and manage inventory efficiently.  

#### 4. AI-Driven Product Recommendation Engine
- Suggests products based on browsing patterns, searches, and past orders.  
- Hybrid approach: collaborative filtering + content-based filtering.  
- Detects seasonal trends and repeated orders.  
- Improves AOV by 15–20% and repeat purchase rate by 25%.  

#### 5. Contextual Notifications
- Alerts triggered by:  
  - Order updates and predicted delays  
  - Seasonal trends, festivals, and climate conditions  
  - Frequent combo packs and repeat purchases  
- Deep-linked notifications direct vendors to product pages, carts, or tracking views.  

#### 6. Feedback & Sharing
- Post-order feedback forms to capture vendor satisfaction.  
- Share products, bundles, or promotions to enhance engagement.  

#### 7. Web Platform
- Complementary website in development for dashboards, order tracking, and vendor analytics.  
- Enables desktop access for enhanced vendor visibility and management.  

---

## Distinctive Advantages
- **Predictive & Proactive:** Alerts vendors before issues occur.  
- **Operational Clarity:** Minimizes unnecessary calls and stress by up to 30%.  
- **Business Enhancement:** Supports cross-selling, upselling, and product diversity.  
- **Improved Engagement:** Personalized notifications and recommendations increase retention.  
- **Unified Ecosystem:** Combines order tracking, discovery, notifications, and feedback in one platform.  

---

## Key Features
- Real-time vehicle tracking map (mobile + web)  
- Predictive ETA alerts  
- Supplier preparation timeline  
- Personalized product recommendations  
- Contextual notifications (trends, climate, festivals, combos)  
- Post-order feedback forms  
- Sharing options for products and bundles  
- Cross-platform accessibility via mobile and web  

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Frontend | Flutter (mobile), React.js / Flutter Web (website), Google Maps / Mapbox, share_plus, Firebase Notifications |
| Backend | Node.js (Express/Fastify) or Python (Flask/FastAPI) |
| Database | PostgreSQL (structured), MongoDB (analytics & catalog) |
| AI/ML | Python scikit-learn, TensorFlow/PyTorch (recommendation engine) |
| APIs | REST/GraphQL, WebSocket for real-time updates, API Gateway |
| DevOps | Docker, Kubernetes (optional), CI/CD via GitHub Actions |

---

## Team Contributions

| Member | Responsibility |
|--------|----------------|
| Zainab Fathimah | Backend & ML engine (Recommendation + ETA prediction) |
| Grandhimi Niharika | Frontend UI (Mobile & Web interfaces) |
| Vallarapu Bindu Venkata Sai Sree| Map integration, notifications, and live tracking |
| Uppugandla Manjeera | Documentation, videos, testing |

---

## Future Enhancements
- Real-time GPS integration from delivery partners for precise tracking  
- Advanced ML models for better predictive capabilities  
- Automated SMS / WhatsApp notifications for vendors  
- Vendor dashboard analytics for performance and insights  
- Gamification and loyalty programs to increase engagement  

---

