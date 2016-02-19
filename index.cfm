<cfscript>
	local.ORMGen = {
		author = "J Harvey",
		authorEmail = "jharvey@cfmaniac.com",
		systemName = 'ColdFusion ORM Component Generator',
		version = '2.0.0',
		comDir = '#expandPath('/generated/')#',
		updates = 'Migrated Layout to BootStrap4 | Updates for ColdFusion | Code Generation Clean-up from previous Versions | Updated to Include Foreign Key Relationships
		          | Fixed Foreign Key Generation (ORM Relationships)'
	};
	
	//Removes WhiteSpace from The Component
	public function  removeWhitepace(required string stringtoclean){
		var tempstring ='';
		tempstring = arguments.stringtoclean;
		//tempstring = replace(tempstring, "#Chr(9)#", "","ALL"); 
        //tempstring = replace(tempstring, "#Chr(13)##Chr(10)#", "","ALL"); 
        //tempstring = replace(tempstring, "#Chr(13)#", "", "ALL");
        //tempstring = replace(tempstring, "#Chr(10)#", "", "ALL");
        return tempstring;
	}
</cfscript>

<cfoutput>
	<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <title>#local.ORMGen.systemName# #local.ORMGen.version#</title>
  <meta name="description" content="#local.ORMGen.systemName# #local.ORMGen.version#" />
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimal-ui" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="mobile-web-app-capable" content="yes">
  <!-- style -->
  <link rel="stylesheet" href="assets/animate.css/animate.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/font-awesome/css/font-awesome.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/bootstrap/dist/css/bootstrap.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/styles/app.min.css" type="text/css" />
  <link rel="stylesheet" href="assets/styles/font.css" type="text/css" />
</head>
<body>
  <header>
      <nav class="navbar navbar-md navbar-fixed-top white">
        <div class="container">
          <a data-toggle="collapse" data-target="##navbar-1" class="navbar-item pull-right hidden-md-up m-a-0 m-l">
            <i class="fa fa-bars"></i>
          </a>
          
          <!-- brand -->
          <a class="navbar-brand md" href="##home" ui-scroll-to="home">
            
            <span class="hidden-folded inline">#local.ORMGen.systemName#</span>
          </a>
          <!-- / brand -->

          <!-- nabar right -->
          <ul class="nav navbar-nav pull-right">
            <li class="nav-item">
              
            </li>
          </ul>
          <!-- / navbar right -->
          <!-- navbar collapse -->
          <div class="collapse navbar-toggleable-sm text-center white" id="navbar-1">
            
            <!-- / link and dropdown -->
          </div>
          <!-- / navbar collapse -->
        </div>
      </nav>
  </header>
  
  <div class="page-content" id="home">
        <div class="p-y-lg white" id="demos">
      <div class="container p-y-lg text-primary-hover">
        <p class="text-muted m-b-lg">#local.ormgen.systemname# automatically generates ColdFusion Components (CFC's) based off of your
        Datasource's Database tables.</p>
        <div class="alert alert-dismissible alert-warning">
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">
		        <span aria-hidden="true">&times;</span>
		    </button>
        <p>What's New & Updated:</p>
        <ul>
        <cfloop list="#local.ORMGen.updates#" delimiters="|" index="update">
	        <li>#update#</li>
        </cfloop>
	    </ul>    
	    </div>
        
        <form role="form" method="post" class="ng-pristine ng-valid">
        <div class="form-group">
        <label for="exampleInputEmail1"><strong>Put your Datasource Name Below</strong></label>
            <input type="text" class="form-control" name="dsn" id="dsn" placeholder="myDataSource">
        </div>
        
        <button type="submit" class="btn btn-outline rounded b-success text-success">Submit</button>
        </form>
        
        
        <cfif isdefined('form.dsn')>
        <h5 class="m-y-lg text-muted text-center">Generating your Components from <em>#form.dsn#</em></h5>
        <div style="height: 350px; overflow: auto;">
        <!---SET and Create the Component Directory--->
        <cfset local.compDir = GetDirectoryFromPath(GetCurrentTemplatePath()) & "generated/#form.dsn#/" />
		<cfif (DirectoryExists(local.compDir) EQ FALSE)>
			<cfdirectory action="create" directory="#local.compDir#" />
		</cfif>
		<!---End Component Directory Creation--->
		<!---Begin the Generation--->
        <cfdbinfo datasource="#form.dsn#" name="dsnTables" type="tables" />
	        <cfquery name="getNonSysTables" dbtype="query">
				SELECT REMARKS, TABLE_NAME, TABLE_TYPE
				FROM dsnTables
				WHERE TABLE_TYPE <> 'SYSTEM TABLE'
				AND TABLE_TYPE <> 'VIEW'
				AND TABLE_NAME NOT Like '%trace_%'
			</cfquery>
		    
		    <cfdbinfo datasource="#form.dsn#" name="getColumns" type="columns" table="#getNonSysTables.TABLE_NAME#" />
		    <cfdbinfo datasource="#form.dsn#" name="getfKeys" type="foreignkeys" table="#getNonSysTables.TABLE_NAME#">
		    	   <!---cfdump var="#getfKEys#" abort="true"---> 
			<cfloop query="getNonSysTables">
			<!---The CFSAVECONTENT has been Shifted "Against the Wall" to Preserve Component Formatting--->
	        <cfsavecontent variable="ORMcomp">/**Component #getNonSysTables.table_name#.cfc Generated by #local.ormGen.systemName# v.#local.ormgen.version#**/
component output="false" persistent="true" table="#getNonSysTables.table_name#" accessors="true"{
<cfloop query="getColumns" ><cfset datatype = '' />
	<cfswitch expression="#getColumns.type_name#" >
	    <!---Numeric/Iteger Types--->
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
	property name="#column_name#" column="#column_name#" getter="true" <cfif currentrow eq 1>setter="false" fieldtype="id" generator="identity"<cfelse> setter="true" <cfif sqldt eq 'datetime'>ORMtype="date"<cfelse>type="#sqldt#"</cfif> sqltype="#datatype#"</cfif>;
</cfloop>
<!---Foreign Keys--->
<cfif GetfKeys.recordCount GTE 1 and #GetfKeys.FKTABLE_NAME# NEQ #getNonSysTables.table_name#>
    
    <cfset local.relatedTable = '#getNonSysTables.table_name#'>
    <cfset local.relatedORM = 'property name="#rereplace(GetfKeys.PKCOLUMN_NAME, "_","","All")#" cfc="#GetfKeys.FKTABLE_NAME#" fieldtype="many-to-many" type="array" getter="true" setter="true" linktable="#GetfKeys.FKTABLE_NAME#" inversejoincolumn="#GetfKeys.fkcolumn_name#" fkcolumn="#GetfKeys.FKCOLUMN_NAME#";'>
    //ORM RELATIONSHIPS:
    <cfloop query="GetfKeys">
    property name="#rereplace(GetfKeys.FKTABLE_NAME, "_","","All")#" cfc="#GetfKeys.FKTABLE_NAME#" fieldtype="many-to-many" type="array" linktable="#GetfKeys.FKTABLE_NAME#" inversejoincolumn="#GetfKeys.fkcolumn_name#" fkcolumn="#GetfKeys.FKCOLUMN_NAME#";
    </cfloop>
    </cfif>
    
    
    
    <!---Init this Component--->
	public function init(){
		return this;
	}
}
	        </cfsavecontent>
	        <cfscript>
		       ORMcomp = removeWhitepace(ORMcomp);
	        </cfscript>
	        <cffile action="write" file="#expandpath('generated/#form.dsn#/#getNonSysTables.TABLE_NAME#.cfc')#" output="#ORMcomp#" nameconflict="overwrite">
	        <div class="alert alert-info">
		       Component <strong>#getNonSysTables.TABLE_NAME#.cfc</strong> Generated 
		       <!---cfdump var="#getfKEys#" collapse="true"--->
	        </div>
	        </cfloop>
        <!---END The Generation--->
        </div>
        
        <p></p>
        <div class="alert alert-success">
        Your Components now Reside in the folder: <em>#local.compDir#</em>
        </div>
        </cfif>
        
      </div>
    </div>
  </div>
  
  <footer class="black pos-rlt">
    <div class="footer dk">
      
      <div class="b b-b"></div>
      <div class="p-a-md">
        <div class="row footer-bottom">
          <div class="col-sm-8">
            <small class="text-muted">&copy; Copyright 2014-#dateFormat(now(), "YYYY")#. All rights reserved.</small>
          </div>
          <div class="col-sm-4">
            <div class="text-sm-right text-xs-left">
              <strong>#local.ormgen.systemNAme# v.#local.ormgen.version# by #local.ormgen.author#</strong>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer> 
  <script src="libs/jquery/jquery/dist/jquery.js"></script>
  <script src="libs/jquery/bootstrap/dist/js/bootstrap.js"></script>
  <!---<script src="libs/jquery/tether/dist/js/tether.min.js"></script>
  <script src="html/scripts/ui-scroll-to.js"></script>--->
</body>
</html>  
</cfoutput>