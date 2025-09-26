# Real-Time Transit Guard (RTG)

## Problem Understanding
Local vendors, such as Kirana stores and HORECA businesses, rely on B2B platforms for supplies but lack real-time, predictive visibility into their inbound orders. Current systems only show vague statuses like “Dispatched,” forcing vendors to make repeated calls for updates. This uncertainty leads to poor staff scheduling, inventory mismanagement, lost revenue, and wasted time.

## Proposed Prototype Solution
We propose **Real-Time Transit Guard (RTG)** — an integration layer leveraging logistics, AI, and GPS data to give vendors complete transparency into their orders. **We are focused on three key modules:**

### Unified Real-Time Tracking Map (RTGM)
Displays live vehicle GPS, traffic-aware routes, and remaining distance/time.

### Predictive ETA & Delay Alert Engine (P-ETA)
Uses historical delivery data, real-time speed, and route conditions to predict delays and send proactive alerts.

### Supplier Preparation Timeline
Provides visibility from order confirmation to dispatch, ensuring vendors are confident about inbound stock.

## Uniqueness and Impact
Unlike generic tracking systems, RTG is proactive and predictive — it foresees disruptions and alerts vendors early. This reduces operational inefficiencies, minimizes vendor stress, and cuts down customer support calls by up to 30%. For B2B platforms, it enhances trust, retention, and loyalty, while for vendors, it turns uncertainty into operational certainty.

## Features
- Live tracking map with vehicle location
- Predictive ETA and proactive delay alerts
- Supplier preparation timeline
- Simple notification system

## Tech Stack
- Frontend: Flutter / React Native
- Backend: Python / Node.js
- Maps: Google Maps API
- ML: Scikit-learn / Rules Engine
- Notifications: Twilio / mock alerts

## Team Contributions
| Member Name | Contribution |
|-------------|--------------|
| Member 1    | Backend & ML engine |
| Member 2    | Frontend UI |
| Member 3    | Mapping & Notifications |
| Member 4    | Documentation & Video |

## Future Scope
- Integrate with real-time vehicle GPS from delivery partners
- Expand the predictive engine using advanced ML algorithms
- Add automated SMS/WhatsApp notifications for vendors
- Dashboard analytics for vendor performance insights
