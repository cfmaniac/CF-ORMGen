CF-ORMGen v.1.0.2.4
=========

Coldfusion File for Generating ORM Components

This Creates an ORM Component from a DataSource and a Database Table.

Change Log:
==========
V.10.2.4:
  - Updated to Add support for Foreign Key Constraints (The Foreign Keys are Automatically created as 'many-to-many' relationships)
  - Updated Source code to Overwrite pre-existing CFC Files, in the case that the Components need to be updated
  - Added checkmark for 'Overwrite' pre-existing CFC Files.
  - Removed Hardcoded inline-styles and placed into stylesheet definition
    
V.1.0.2.3:
  - Added Support for MySQL and SQLServer Datasources/Databases
  - Thanks to *reubenbrown13* for bug Fix and Component WhiteSpace Cleanup. 
  
V.1.0.2.2:
   - Updated UI for a somewhat cleaner, more organizaed layout. Removed the "Database" form field, fixed file generation locations
   
V.1.0.2.1:
   - Updated CF-ORMGEN to create an Isloated Directory within the /cfc/ Directory based off of the Supplied DataSource Name
   
V.1.0.2 :
   - Updated CF-ORMGEN to loop over All Tables in Datasource and Generate Components
   
V.1.0.1 :
   - Initial Release
   
To do:
=========
   - Make an interface for Foreign-Key Type Selections (many-to-many, many-to-one, one-to-many)
   - Make an interface for 'Update Existing Components'
   -    
