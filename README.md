# RetailDB
In this project, we set up Transactional and Analytical Databases in SQL for an online retail business. We also created a data catalog in a document file that explains the details and rationale for our design decisions.

# 🛒 RetailDB Project

RetailDB is a demo project that showcases **data modeling and reporting design** for a retail company.

# Project Structure
- `sql/` → Database schema, sample data, star schema, and queries
- `docs/` → Data catalog + ERD diagram
- `data/` → Raw CSV data samples


# Schema Overview
- **OLTP (Operational DB):** Normalized 3NF schema for transactions
- **OLAP (Analytics DB):** Star schema for reporting

![ERD Diagram](docs/ERD.png)

# How to Run
1. Clone the repo:
   ```bash
   git clone https://github.com/unclesteve2k4/RetailDB.git
   cd RetailDB/sql
