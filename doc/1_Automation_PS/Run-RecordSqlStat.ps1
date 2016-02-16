<#
.SYNOPSIS
    Outputs the number of records in the specified SQL Server database table.

.DESCRIPTION
	This runbook get weekly perf stat from sys.resource_stat and insert this stat into user database table
	
.PARAMETER SqlServer
    String name of the SQL Server to connect to

.PARAMETER Database
    String name of the SQL Server database to connect to

.PARAMETER Table
    String name of the database table to output the number of records of 
	
.PARAMETER SqlCredential
    PSCredential containing a username and password with access to the SQL Server  

.EXAMPLE
    Run-RecordSqlStat -SqlCredential $SomeSqlCred

.NOTES
    AUTHOR: iljoong@outlook.com
    LASTEDIT: Feb 07, 2016 
#>

workflow Run-RecordSqlStat
{
    param(
        [parameter(Mandatory=$True)]
        [string] $SqlServer,
             
        [parameter(Mandatory=$True)]
        [string] $Database,
        
        [parameter(Mandatory=$True)]
        [string] $Table,
		      
        [parameter(Mandatory=$True)]
        [PSCredential] $SqlCredential
    )

    # Get the username and password from the SQL Credential
    $SqlUsername = $SqlCredential.UserName
    $SqlPass = $SqlCredential.GetNetworkCredential().Password
    
    inlinescript {
        # Define the connection string to the SQL Database        
		$master_connstr = "Server=tcp:$using:SqlServer,1433;Database=master;User ID=$using:SqlUsername;Password=$using:SqlPass;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;"
		$datadb_connstr = "Server=tcp:$using:SqlServer,1433;Database=$using:Database;User ID=$using:SqlUsername;Password=$using:SqlPass;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;"
		
		#= GET WEEK PERF STAT ==============
		$sqlcmd = "SELECT `
		    avg(avg_cpu_percent) AS davg_avg_cpu_percent, `
		    max(avg_cpu_percent) AS dmax_avg_cpu_percent, `
		    avg(avg_data_io_percent) AS davg_avg_data_io_percent, `
		    max(avg_data_io_percent) AS dmax_avg_data_io_percent, `
		    avg(avg_log_write_percent) AS davg_avg_log_write_percent, `
		    max(avg_log_write_percent) AS dmax_avg_log_write_percent, `
		    avg(max_session_percent) AS davg_max_session_percent, `
		    max(max_session_percent) AS dmax_max_session_percent, `
		    avg(max_worker_percent) AS davg_max_worker_percent, `
		    max(max_worker_percent) AS dmax_max_worker_percent `
		FROM master.sys.resource_stats `
		WHERE database_name = '$using:Database' AND start_time > DATEADD(day, -7, GETDATE());"
		
		Write-Output $sqlcmd
		
		$Conn = New-Object System.Data.SqlClient.SqlConnection($master_connstr)
		        
		# Open the SQL connection
		$Conn.Open()
		
		# Define the SQL command to run. In this case we are getting the number of rows in the table
		$Cmd=new-object system.Data.SqlClient.SqlCommand($sqlcmd, $Conn)
		$Cmd.CommandTimeout=120
		
		# Execute the SQL command
		$Ds=New-Object system.Data.DataSet
		$Da=New-Object system.Data.SqlClient.SqlDataAdapter($Cmd)
		[void]$Da.fill($Ds)
		
		# Output the count
		$Ds.Tables[0]
		
		# Close the SQL connection
		$Conn.Close()
		
		#= INSERT WEEK PERF DATA ===========================================================================================
		$sqlstr = "INSERT INTO $using:Table `
		    (timestamp, `
		    davg_avg_cpu_percent, `
		    dmax_avg_cpu_percent, `
		    davg_avg_data_io_percent, `
		    dmax_avg_data_io_percent, `
		    davg_avg_log_write_percent, `
		    dmax_avg_log_write_percent, `
		    davg_max_session_percent, `
		    dmax_max_session_percent, `
		    davg_max_worker_percent, `
		    dmax_max_worker_percent) `
		VALUES `
		    (GETDATE(), `
			{0}, `
		    {1}, `
		    {2}, `
		    {3}, `
		    {4}, `
		    {5}, `
		    {6}, `
		    {7}, `
		    {8}, `
		    {9})"
		
		$sqlcmd = [string]::Format($sqlstr,
		    $Ds.Tables[0].davg_avg_cpu_percent, $Ds.Tables[0].dmax_avg_cpu_percent,
		    $Ds.Tables[0].davg_avg_data_io_percent, $Ds.Tables[0].dmax_avg_data_io_percent,
		    $Ds.Tables[0].davg_avg_log_write_percent, $Ds.Tables[0].davg_avg_log_write_percent,
		    $Ds.Tables[0].davg_max_session_percent, $Ds.Tables[0].davg_max_session_percent,
		    $Ds.Tables[0].davg_max_worker_percent, $Ds.Tables[0].davg_max_worker_percent)
		
		#debug output
		Write-Output $sqlcmd
		
		$Conn = New-Object System.Data.SqlClient.SqlConnection($datadb_connstr)
		        
		# Open the SQL connection
		$Conn.Open()
		
		# Define the SQL command to run. In this case we are getting the number of rows in the table
		$Cmd=new-object system.Data.SqlClient.SqlCommand($sqlcmd, $Conn)
		$Cmd.CommandTimeout=120
		
		# Execute the SQL command
		$Cmd.CommandText = $sqlcmd
		$Cmd.ExecuteReader()
		
		# Close the SQL connection
		$Conn.Close()

    }
}
