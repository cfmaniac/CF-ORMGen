<!---ORM CFC Generator By J Harvey jharvey@cfmaniac.com
Creates a CFScript CFC for ORM Database Components
Version 1.0.2.4

Notes:
--Updated to crawl over all Tables within a Specified DataSource
--Updated to Support MySQL DataSources
--Updated to Add support for Foreign Key Constraints
--Updated to Dynamically Overwrite Pre-Existing Components for Updates
--Moved inline harcoded CSS to StyleSheet Reference

Still to Do:
--Create Application.cfc for ORM Config
--Create UI for ForeignKey Types (many-to-many, many-to-one, one-to-many)
--->
<cfscript>
	cformgen.author = 'J Harvey';
	cformgen.version = '1.0.2.4';
</cfscript>
<cfoutput>
<html>
	<head>
		<title>ORM CFC Generator - #cformgen.version#</title>
		<style>
			form {
			text-align: center; 
			margin-left: auto; 
			margin-right: auto; 
			width: 850px; 
			height: 250px; 
			border:2px solid ##f5f5f5; 
			border-radius:4px; 
			background: ##eeeeee;
			}
			
			form p:last-child{
			margin-bottom: 15px;
			}
			
			##results{
			margin-left: auto; 
			margin-right: auto; 
			overflow: auto; 
			width: 850px; 
			height: 450px; 
			border:2px solid ##f5f5f5; 
			border-radius:4px; 
			background: ##fff;
			}
			
			##results h2{
			text-align: center;
			}
			
		</style>
		
		
	</head>
</html>
<form method="post" style="">
<h2>ColdFusion ORM Component Generator</h2>
<p>Your Components will be created within the <em>/CFC/-datasourcename-</em> folder.</p>
Datasource:<input type="text" name="tempdsn" value=""><br>
<!---input type="checkbox" name="overwrite" value="true" <cfif structKeyExists(form, 'overwrite')>checked="checked"</cfif><em>Overwrite Existing CFCs for DataSource</em><br--->
<input type="submit">
<p>Version #cformgen.version#</p>
</form>

<cfif isdefined('form.tempdsn')>
<div id="results">
<h2>Generating your components...</h2>

<!--- We Run Some Checks First --->
<cfdbinfo datasource="#form.tempdsn#" name="result" type="version">
<cfdbinfo datasource="#form.tempdsn#" name="Database" type="tables">
<!--- <cfdump var="#database#" abort="true" /> --->

  <cfif (CompareNoCase(result.Database_ProductName, "MySQL") EQ 0)>
	  <!--- MYSQL --->
	  <cfset table_names = database />
	  <cfif (isDefined("Database.table_cat"))>
	  <cfquery name="table_names" datasource="#form.tempdsn#" >
			select table_name from information_schema.tables where table_schema='#Database.table_cat#'
		</cfquery>
		</cfif>
	<cfelseif (CompareNoCase(result.Database_ProductName, "Microsoft SQL Server") EQ 0)>
		<!--- SQL Server --->
		<cfquery dbtype="query" name="table_names">
			 Select TABLE_NAME from Database where TABLE_TYPE='table' and TABLE_SCHEM='dbo'
		</cfquery>
  </cfif>
  <cfset OrmDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "cfc/#form.tempdsn#/" />
	<cfif (DirectoryExists(OrmDir) EQ FALSE)>
		<cfdirectory action="create" directory="#OrmDir#" />
	</cfif>

	<cfloop query="table_names">
    Creating ORM Component for Table: <strong><em>#table_names.table_name#</em></strong><br>
    <cfquery name="temp" datasource="#form.tempdsn#" >
		SELECT * FROM information_schema.columns
		WHERE table_name = '#table_names.table_name#' and table_name !='trace_%'
		ORDER BY ordinal_position
		</cfquery>
		
	<cfdbinfo datasource="#form.tempdsn#" table="#table_names.table_name#" name="fKeys" type="foreignkeys">
    		
    <cfsavecontent variable="DBSchema">
component output="false" persistent="true" table="#temp.table_name#" accessors="true"

{<cfloop query="temp" ><cfset datatype = '' />
	<cfswitch expression="#temp.data_type#" >
		<cfcase value="int"><cfset datatype = 'cf_sql_integer'><cfset sqldt = 'numeric'></cfcase>
		<cfcase value="numeric"><cfset datatype = 'cf_sql_numeric'><cfset sqldt = 'numeric'></cfcase>
		<cfcase value="datetime"><cfset datatype = 'cf_sql_date'><cfset sqldt = 'datetime'></cfcase>
		<!---Boolean--->
		<cfcase value="bit"><cfset datatype = 'cf_sql_bit'><cfset sqldt = 'boolean'></cfcase>
		<!---The String Types--->
		<cfcase value="char"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="nchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="varchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="nvarchar"><cfset datatype = 'cf_sql_varchar'><cfset sqldt = 'string'></cfcase>
		<cfcase value="text"><cfset datatype = 'cf_sql_longvarchar'><cfset sqldt = 'string'></cfcase>
	</cfswitch>
	
	property name="#column_name#" column="#column_name#" getter="true" <cfif currentrow eq 1>setter="false" fieldtype="id" 	generator="identity"<cfelse> setter="true" <cfif sqldt eq 'datetime'>ORMtype="date"<cfelse>type="#sqldt#"</cfif> sqltype="#datatype#"</cfif>;</cfloop>
    <!---Foreign Key Constraints--->
    <cfif fKeys.recordCount GTE 1>
    <cfset local.relatedTable = '#fkeys.FKTABLE_NAME#'>
    <cfset local.relatedORM = 'property name="#rereplace(fkeys.PKTABLE_NAME, "_","","All")#" cfc="#temp.table_name#" fieldtype="many-to-many" type="array" getter="true" setter="true" linktable="#fkeys.PKTABLE_NAME#" inversejoincolumn="#fkeys.fkcolumn_name#" fkcolumn="#fkeys.pkcolumn_name#";'>
    //ORM RELATIONSHIPS:
    <cfloop query="fkeys">
       property name="#rereplace(fkeys.FKTABLE_NAME, "_","","All")#" cfc="#temp.table_name#" fieldtype="many-to-many" type="array" linktable="#fkeys.FKTABLE_NAME#" inversejoincolumn="#fkeys.fkcolumn_name#" fkcolumn="#fkeys.pkcolumn_name#";
    </cfloop>
    </cfif>
    
    <!---This is for Tables Referenced in Foreign Key Contraints - BI Directional--->
     <cfif isdefined('local.relatedTable') and local.relatedTable EQ #temp.table_name#>
    //ORM RELATIONSHIPS:
	<cfset relatedTable = #local.relatedTable#>
	#local.RelatedORM#       
    </cfif>
    <!---End Secondary Routine for Foreign Key--->
	public function init(){
		return this;
	}
}
   </cfsavecontent>

   <cffile action="write" file="#expandpath('cfc/#form.tempdsn#/#temp.table_name#.cfc')#" output="#DBSchema#" nameconflict="overwrite">

   

    </cfloop>
		
</div>

</cfif>
</cfoutput>
