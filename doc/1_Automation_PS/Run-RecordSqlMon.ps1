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
    Run-RecordSqlMon -SqlCredential $SomeSqlCred

.NOTES
    AUTHOR: iljoong@outlook.com
    LASTEDIT: Feb 11, 2016 
#>

workflow Run-RecordSqlMon
{
    param(
        [parameter(Mandatory=$True)]
        [string] $SqlServer,
             
        [parameter(Mandatory=$True)]
        [string] $Database,
        
        [parameter(Mandatory=$True)]
        [string] $Table,
		      
        [parameter(Mandatory=$True)]
        [PSCredential] $SqlCredential,
		
		[parameter(Mandatory=$True)]
        [int] $BoundValue
    )

    # Get the username and password from the SQL Credential
    $SqlUsername = $SqlCredential.UserName
    $SqlPass = $SqlCredential.GetNetworkCredential().Password
    
    inlinescript {
        # Define the connection string to the SQL Database        
		$master_connstr = "Server=tcp:$using:SqlServer,1433;Database=master;User ID=$using:SqlUsername;Password=$using:SqlPass;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;"
		$datadb_connstr = "Server=tcp:$using:SqlServer,1433;Database=$using:Database;User ID=$using:SqlUsername;Password=$using:SqlPass;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;"
		
		#= GET WEEK PERF STAT ==============
		$sqlcmd = "SELECT  `
            (COUNT(database_name) - SUM(CASE WHEN avg_cpu_percent >= $using:BoundValue THEN 1 ELSE 0 END) * 1.0) / COUNT(database_name) AS 'Down_CPU_Fit' `
            ,(COUNT(database_name) - SUM(CASE WHEN avg_log_write_percent >= $using:BoundValue THEN 1 ELSE 0 END) * 1.0) / COUNT(database_name) AS 'Down_Log_Write_Fit' `
            ,(COUNT(database_name) - SUM(CASE WHEN avg_data_io_percent >= $using:BoundValue THEN 1 ELSE 0 END) * 1.0) / COUNT(database_name) AS 'Down_Data_IO_Fit' `
            ,(COUNT(database_name) - SUM(CASE WHEN avg_cpu_percent >= 100 THEN 1 ELSE 0 END) * 1.0) / COUNT(database_name) AS 'Up_CPU_Fit' `
            ,(COUNT(database_name) - SUM(CASE WHEN avg_log_write_percent >= 100 THEN 1 ELSE 0 END) * 1.0) / COUNT(database_name) AS 'Up_Log_Write_Fit' `
            ,(COUNT(database_name) - SUM(CASE WHEN avg_data_io_percent >= 100 THEN 1 ELSE 0 END) * 1.0) / COUNT(database_name) AS 'Up_Data_IO_Fit' `
		FROM master.sys.resource_stats `
		WHERE database_name = '$using:Database' AND start_time > DATEADD(day, -1, GETDATE());"
		
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
            Down_CPU_Fit, `
            Down_Log_Write_Fit, `
            Down_Data_IO_Fit, `
            Up_CPU_Fit, `
            Up_Log_Write_Fit, `
            Up_Data_IO_Fit) `
		VALUES `
		    (GETDATE(), `
			{0}, `
		    {1}, `
		    {2}, `
		    {3}, `
		    {4}, `
		    {5})"
		
		$sqlcmd = [string]::Format($sqlstr,
		    $Ds.Tables[0].Down_CPU_Fit, $Ds.Tables[0].Down_Log_Write_Fit, $Ds.Tables[0].Down_Data_IO_Fit,
            $Ds.Tables[0].Up_CPU_Fit, $Ds.Tables[0].Up_Log_Write_Fit, $Ds.Tables[0].Up_Data_IO_Fit)
		
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
