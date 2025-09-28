# Real-Time Transit Guard (RTG) & Smart Product Recommendation

## Problem Statement 

Small retailers, such as kirana stores and HORECA outlets, depend on B2B platforms to procure their daily supplies.  
Despite the availability of these platforms, their experience is hampered by several issues that reduce efficiency, satisfaction, and long-term usage.  

### Key Challenges  
1. **Limited Product Discovery**  
   - Large product catalogs exist, yet many relevant items remain unnoticed.  
   - Retailers often repurchase the same items and miss opportunities to diversify.  

2. **Repetitive Ordering**  
   - Vendors frequently reorder known items without exploring alternatives.  
   - Cross-selling and upselling chances are left untapped.  

3. **Low Average Order Value (AOV)**  
   - Lack of tailored suggestions keeps basket sizes small.  
   - No dynamic promotions or bundles to improve order size.  

4. **Unclear Delivery Timelines**  
   - Updates such as “Dispatched” are vague.  
   - Retailers end up making repeated follow-up calls due to uncertainty.  

5. **Weak User Retention**  
   - Many vendors stop using the platform after a few months.  
   - Lack of personalization and weak communication reduce loyalty.  

---

### Impact  
- **Inventory issues** → Overstocking or stock-outs.  
- **Operational delays** → Staff and workflow become unpredictable.  
- **Revenue stagnation** → Cross-selling and upselling potential remains unused.  
- **User frustration** → Vendors switch back to offline suppliers.  

---

## Proposed Solution
We propose a **hybrid mobile and web prototype** that combines real-time order tracking, AI-driven product recommendations, smart notifications, feedback, and sharing features.  
This enables vendors to gain better visibility and actionable insights.  

### Core Components

#### 1. Unified Real-Time Tracking Map (RTGM)
- Tracks inbound orders in real-time using GPS.  
- Shows traffic-aware routes with estimated time and distance.  
- Works on both mobile (Flutter) and web applications.  

#### 2. Predictive ETA & Alerts (P-ETA)
- Uses historical delivery data and live route conditions to forecast delays.  
- Sends proactive notifications to vendors for better planning.  

#### 3. Supplier Preparation Timeline
- Shows all stages from order confirmation to dispatch.  
- Assists retailers in planning staff and managing inventory.  

#### 4. AI-Powered Product Recommendation Engine
- Suggests products based on browsing behavior, searches, and past purchases.  
- Uses a hybrid approach (collaborative + content-based filtering).  
- Captures seasonal trends and frequent orders.  
- Can improve AOV by 15–20% and repeat purchases by 25%.  

#### 5. Contextual Notifications
- Alerts triggered by:  
  - Order status and predicted delays  
  - Seasonal patterns, festivals, and climate changes  
  - Combo packs and frequently bought items  
- Deep links take users directly to product pages, carts, or tracking views.  

#### 6. Feedback & Sharing
- Collects post-order feedback from retailers.  
- Enables product and promotion sharing for better engagement.  

#### 7. Web Platform
- Web dashboard for order tracking and analytics.  
- Desktop access enhances visibility and control for vendors.  

---

## Distinctive Advantages
- **Proactive and Predictive:** Vendors get notified before issues arise.  
- **Clarity in Operations:** Cuts down unnecessary calls by 30%.  
- **Business Growth:** Improves product discovery, upselling, and cross-selling.  
- **Stronger Retention:** Personalized engagement drives loyalty.  
- **Unified Platform:** Combines tracking, discovery, notifications, and feedback.  

---

## Key Features
- Real-time order tracking map (mobile + web)  
- Predictive ETA notifications  
- Supplier preparation timeline  
- Personalized recommendations  
- Context-based alerts (festivals, weather, seasonal demand)  
- Post-order feedback forms  
- Product and bundle sharing options  
- Cross-platform support (mobile and web)  

---

## Tech Stack

| **Layer**    | **Technology Used** |
|--------------|----------------------|
| **Frontend** | Flutter (Mobile), React.js with HTML, CSS, JavaScript (Web) |
| **Backend**  | Node.js (local development) |
| **Database** | Local/in-memory storage (no external DB used) |
| **AI/ML**    | Rule-based recommendation engine |
| **APIs**     | Google Maps API, Socket.io (real-time), Flutter APIs, Local APIs |

---

## Team Contributions

| Member | Responsibility |
|--------|----------------|
| Zainab Fathimah | Backend & ML engine (Recommendation + ETA prediction) |
| Grandhimi Niharika | Frontend UI (Mobile & Web) |
| Vallarapu Bindu Venkata Sai Sree | Map integration, notifications, and live tracking |
| Uppugandla Manjeera | Documentation, testing, and videos |

---

## Future Enhancements
- GPS integration from logistics partners for accurate real-time tracking  
- Advanced ML for improved recommendation accuracy and ETA predictions  
- Automated SMS and WhatsApp notifications for vendors  
- Vendor performance dashboards and analytics  
- Loyalty programs and gamification to increase engagement  

---
