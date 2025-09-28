# Real-Time Transit Guard (RTG) & Smart Product Recommendation

## Problem Statement ... 

Small retailers, such as kirana shops and HORECA outlets, rely on B2B platforms for sourcing daily supplies.  
However, their experience is affected by multiple challenges that impact efficiency, satisfaction, and retention:  

### Key Challenges  
1. **Poor Product Discovery**  
   - Large catalogs exist, but many useful items remain hidden.  
   - Retailers keep buying the same known products, missing chances to diversify inventory.  

2. **Routine, Repetitive Buying**  
   - Vendors reorder the same items without exploring alternatives.  
   - Cross-selling and upselling opportunities are often lost.  

3. **Flat Average Order Value (AOV)**  
   - Lack of tailored suggestions keeps basket size stagnant.  
   - No personalized promotions or bundling to increase AOV.  

4. **Unclear Delivery Timelines**  
   - Order updates are vague (e.g., “Dispatched”).  
   - Retailers make repeated follow-up calls due to uncertainty.  

5. **Weak User Retention**  
   - Many retailers leave the platform within months.  
   - Poor personalization and communication reduce loyalty.  

---

###  Impact  
- **Inventory inefficiencies** → Overstocking or stock-outs.  
- **Operational delays** → Staff scheduling becomes unpredictable.  
- **Revenue stagnation** → Missed cross-selling/upselling limits growth.  
- **User frustration** → Vendors disengage and return to offline suppliers.  

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

| **Layer**    | **Technology Used** |
|--------------|----------------------|
| **Frontend** | Flutter (Mobile), React.js with HTML, CSS, JavaScript (Web) |
| **Backend**  | Node.js (running locally for development) |
| **Database** | No external DB integrated; using local/in-memory storage |
| **AI/ML**    | Rule-based recommendation engine |
| **APIs**     | Custom local APIs, Google Maps API, Socket.io (real-time), Flutter platform APIs, Local storage APIs |

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

