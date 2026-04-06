/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME;

	BEGIN TRY
		SET @start_time = GETDATE();
		PRINT '================================================';
        PRINT 'Loading Silver Layer';
        PRINT '================================================';

		-- Loading silver.asia_fuel_prices_detailed
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.asia_fuel_prices_detailed';
		TRUNCATE TABLE silver.asia_fuel_prices_detailed;
		PRINT '>> Inserting Data Into: silver.asia_fuel_prices_detailed';
		INSERT INTO silver.asia_fuel_prices_detailed (
			country,
			sub_region,
			iso3,
			gasoline_usd_per_liter,
			diesel_usd_per_liter,
			lpg_usd_per_kg,
			avg_monthly_income_usd,
			fuel_affordability_index,
			oil_import_dependency_pct,
			refinery_capacity_kbpd,
			ev_adoption_pct,
			fuel_subsidy_active,
			subsidy_cost_bn_usd,
			co2_transport_mt,
			price_date,
			gasoline_pct_daily_wage
		)
		SELECT 
			country,
			sub_region,
			iso3,
			CAST(gasoline_usd_per_liter AS DECIMAL(6,3)) AS gasoline_usd_per_liter,
			CAST(diesel_usd_per_liter AS DECIMAL (6,3)) AS diesel_usd_per_liter,
			CAST(lpg_usd_per_kg AS DECIMAL (10,2)) AS lpg_usd_per_kg,
			CAST(avg_monthly_income_usd AS DECIMAL (6,2)) AS avg_monthly_income_usd,
			CAST(fuel_affordability_index AS DECIMAL (10,3)) AS fuel_affordability_index,
			CAST(oil_import_dependency_pct AS DECIMAL (6,3)) AS oil_import_dependency_pct,
			refinery_capacity_kbpd,
			CAST(ev_adoption_pct AS DECIMAL (6,2)) AS ev_adoption_pct,
			CAST(fuel_subsidy_active AS BIT) AS fuel_subsidy_active,
			CAST(subsidy_cost_bn_usd AS DECIMAL (10,2)) AS subsidy_cost_bn_usd,
			CAST(co2_transport_mt AS DECIMAL (10,2)) AS co2_transport_mt,
			price_date,
			CAST(gasoline_pct_daily_wage AS DECIMAL (6,3)) AS gasoline_pct_daily_wage
		FROM bronze.asia_fuel_prices_detailed
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.crude_oil_annual
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.crude_oil_annual';
		TRUNCATE TABLE silver.crude_oil_annual;
		PRINT '>> Inserting Data Into: crude_oil_annual';
		INSERT INTO silver.crude_oil_annual (
			year,
			brent_avg_usd_bbl,
			wti_avg_usd_bbl,
			brent_yoy_change_pct,
			wti_yoy_change_pct,
			key_event,
			brent_wti_spread,
			avg_price_usd_bbl
			)
		SELECT
			year,                    
			CAST(brent_avg_usd_bbl AS DECIMAL(6,3)) AS brent_avg_usd_bbl,
			CAST(wti_avg_usd_bbl AS DECIMAL(6,3)) AS wti_avg_usd_bbl,
			CAST(brent_yoy_change_pct AS DECIMAL(6,3)) AS brent_yoy_change_pct,
			CAST(wti_yoy_change_pct AS DECIMAL(6,3)) AS wti_yoy_change_pct,  
			key_event,
			CAST(brent_wti_spread AS DECIMAL(6,3)) AS brent_wti_spread,     
			CAST(avg_price_usd_bbl AS DECIMAL(6,3)) AS avg_price_usd_bbl          
		FROM bronze.crude_oil_annual
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		-- Loading silver.fuel_tax_comparison
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.fuel_tax_comparison';
		TRUNCATE TABLE silver.fuel_tax_comparison;
		PRINT '>> Inserting Data Into: fuel_tax_comparison';
		INSERT INTO silver.fuel_tax_comparison (
			country,
			region,
			gasoline_tax_pct,
			diesel_tax_pct,
			vat_pct,
			excise_usd_per_liter,
			carbon_tax_active,
			total_tax_usd_per_liter,
			tax_burden_category
			)
		SELECT
			country,
			region,
			CAST(gasoline_tax_pct AS DECIMAL(6,3)) AS gasoline_tax_pct,
			CAST(diesel_tax_pct AS DECIMAL(6,3)) AS diesel_tax_pct,
			CAST(vat_pct AS DECIMAL(6,3)) AS vat_pct,
			CAST(excise_usd_per_liter AS DECIMAL(6,3)) AS excise_usd_per_liter,  
			CAST(carbon_tax_active AS BIT) AS carbon_tax_active,
			CAST(total_tax_usd_per_liter AS DECIMAL(6,3)) AS total_tax_usd_per_liter,     
			tax_burden_category
		FROM bronze.fuel_tax_comparison
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		--Loading silver.asia_subsidy_tracker
		SET @start_time = GETDATE()
		PRINT '>> Truncating Table: silver.asia_subsidy_tracker';
		TRUNCATE TABLE silver.asia_subsidy_tracker;
		PRINT '>> Inserting Data Into: asia_subsidy_tracker';
		INSERT INTO silver.asia_subsidy_tracker (
			country,                         
			iso3,                           
			gasoline_subsidized,
			diesel_subsidized,
			subsidy_type, 
			annual_subsidy_cost_bn_usd,
			subsidy_pct_gdp,     
			subsidy_description,
			last_price_change,               
			pricing_mechanism,              
			regulator
			)
		SELECT
			country,
			iso3,
			CAST(gasoline_subsidized AS BIT) AS gasoline_subsidized,
			CAST(diesel_subsidized AS BIT) AS diesel_subsidized,
			subsidy_type,
			CAST(annual_subsidy_cost_bn_usd AS DECIMAL(6,3)) AS annual_subsidy_cost_bn_usd,
			CAST(subsidy_pct_gdp AS DECIMAL(6,3)) AS subsidy_pct_gdp,
			subsidy_description,
			last_price_change,
			pricing_mechanism,
			regulator
		FROM bronze.asia_subsidy_tracker
		SET @end_time = GETDATE();
		PRINT '>> Load Duration: ' + CAST(DATEDIFF(SECOND, @start_time, @end_time) AS NVARCHAR) + ' seconds';
        PRINT '>> -------------';

		SET @batch_end_time = GETDATE();
		PRINT '=========================================='
		PRINT 'Loading Silver Layer is Completed';
        PRINT '   - Total Load Duration: ' + CAST(DATEDIFF(SECOND, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds';
		PRINT '=========================================='

	END TRY
	BEGIN CATCH
		PRINT '=========================================='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST (ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST (ERROR_STATE() AS NVARCHAR);
		PRINT '=========================================='
	END CATCH
END



		


