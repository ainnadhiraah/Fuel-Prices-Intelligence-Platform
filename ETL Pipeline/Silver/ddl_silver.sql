/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables 
    if they already exist.
	  Run this script to re-define the DDL structure of 'silver' Tables
      
      
===============================================================================
*/

IF OBJECT_ID('silver.asia_fuel_prices_detailed', 'U') IS NOT NULL
    DROP TABLE silver.asia_fuel_prices_detailed;
GO

CREATE TABLE silver.asia_fuel_prices_detailed (
    country                        NVARCHAR(50),
    sub_region                     NVARCHAR(50),
    iso3                           NVARCHAR(3),
    gasoline_usd_per_liter         DECIMAL(6,3),
    diesel_usd_per_liter           DECIMAL(6,3),
    lpg_usd_per_kg                 DECIMAL(10,2),
    avg_monthly_income_usd         DECIMAL(6,2),
    fuel_affordability_index       DECIMAL(5,3),
    oil_import_dependency_pct      DECIMAL(6,3),
    refinery_capacity_kbpd         INT,
    ev_adoption_pct                DECIMAL(5,2),
    fuel_subsidy_active            BIT,
    subsidy_cost_bn_usd            DECIMAL(10,2),
    co2_transport_mt               DECIMAL(10,2),
    price_date                     DATE,
    gasoline_pct_daily_wage        DECIMAL(6,3),
    dwh_create_date                DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.crude_oil_annual', 'U') IS NOT NULL
    DROP TABLE silver.crude_oil_annual;
GO

CREATE TABLE silver.crude_oil_annual (
    year                    INT,
    brent_avg_usd_bbl       DECIMAL(6,3),
    wti_avg_usd_bbl         DECIMAL(6,3),
    brent_yoy_change_pct    DECIMAL(6,3),
    wti_yoy_change_pct      DECIMAL(6,3),
    key_event               NVARCHAR(50),
    brent_wti_spread        DECIMAL (6,3),
    avg_price_usd_bbl       DECIMAL (6,3),
    dwh_create_date         DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.fuel_tax_comparison', 'U') IS NOT NULL
    DROP TABLE silver.fuel_tax_comparison;
GO

CREATE TABLE silver.fuel_tax_comparison (
    country                     NVARCHAR(50),
    region                      NVARCHAR(50),
    gasoline_tax_pct            DECIMAL(6,3),
    diesel_tax_pct              DECIMAL(6,3),
    vat_pct                     DECIMAL(6,3),
    excise_usd_per_liter        DECIMAL(6,3),
    carbon_tax_active           BIT,
    total_tax_usd_per_liter     DECIMAL(6,3),
    tax_burden_category         NVARCHAR(50),
    dwh_create_date             DATETIME2 DEFAULT GETDATE()
);
GO

IF OBJECT_ID('silver.asia_subsidy_tracker', 'U') IS NOT NULL
    DROP TABLE silver.asia_subsidy_tracker;
GO

CREATE TABLE silver.asia_subsidy_tracker (
    country                         NVARCHAR(50),
    iso3                            NVARCHAR(3),
    gasoline_subsidized             BIT,
    diesel_subsidized               BIT,
    subsidy_type                    NVARCHAR(50),
    annual_subsidy_cost_bn_usd      DECIMAL(6,3),
    subsidy_pct_gdp                 DECIMAL(6,3),
    subsidy_description             NVARCHAR(MAX),
    last_price_change               DATE,
    pricing_mechanism               NVARCHAR(50),
    regulator                       NVARCHAR(10),
    dwh_create_date                 DATETIME2 DEFAULT GETDATE()
);
GO

