# retail-analytics-databricks-tableau
End-to-end retail analytics project using Databricks SQL, Medallion architecture, data quality validation, and Tableau Public dashboards.
Overview

This project demonstrates an end-to-end retail analytics workflow using Azure Databricks, SQL, Delta Lake, Medallion Architecture, and Tableau Public.

The goal is to transform raw retail data into reliable analytical datasets and visualize business metrics that support data-driven decision-making.

Technology Stack

Azure Databricks — data processing and analytics

SQL — data transformations, joins, aggregations, and validation

Delta Lake — managed tables and data version history

Medallion Architecture — Bronze, Silver, and Gold data layers

Tableau Public — business intelligence and data visualization

GitHub — source code and project documentation
Data Model

The project uses three core datasets:

Customers: customer identifiers, names, emails, countries, and signup dates.

Products: product identifiers, names, categories, and catalog prices.

Orders: order identifiers, customer and product references, dates, quantities, and historical transaction prices.

The datasets are synthetic and designed for learning and demonstration purposes.

Data Engineering and Quality

The project implements the following transformations and validation rules:

Standardization of customer names and country values.

Email normalization and format validation.

Customer deduplication using window functions.

Validation of order quantities and unit prices.

Detection of orders with missing customer or product references.

Calculation of transaction line totals using historical order prices.

Aggregation of revenue and sales metrics for analytical reporting.

Invalid customer references are excluded from the validated Silver orders dataset in this project. In a production implementation, rejected records should be retained for investigation and remediation.

Gold Layer

The analytical tables support reporting across three business dimensions:

Revenue by Product: units sold and revenue by product.

Revenue by Category: units sold and revenue by product category.

Customers by Country: customer distribution by country.

Tableau Dashboard

Explore the published visualization:

View the Retail Analytics Dashboard on Tableau Public

The dashboard uses exported CSV results from the Gold layer.
Key Skills Demonstrated

SQL joins and aggregations

Common table expressions and window functions

Data cleaning and deduplication

Data quality validation

Delta Lake fundamentals and time travel

Medallion data architecture

Analytical data modeling

Tableau dashboard development

Technical documentation

Future Improvements

Automate data ingestion and transformations with Databricks Workflows.

Implement incremental processing and MERGE operations.

Add a dedicated quarantine table for rejected records.

Integrate Tableau with an appropriate production data source.

Expand business metrics and dashboard interactivity.

Disclaimer

This is a portfolio project built with synthetic data for educational and demonstration purposes. It does not represent production financial or customer data.
