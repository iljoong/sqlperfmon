USE [database_name]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[sqldbstat] (
    [Id]                         INT            IDENTITY (1, 1) NOT NULL,
    [timestamp]                  DATETIME       NULL,
    [davg_avg_cpu_percent]       DECIMAL (5, 2) NULL,
    [dmax_avg_cpu_percent]       DECIMAL (5, 2) NULL,
    [davg_avg_data_io_percent]   DECIMAL (5, 2) NULL,
    [dmax_avg_data_io_percent]   DECIMAL (5, 2) NULL,
    [davg_avg_log_write_percent] DECIMAL (5, 2) NULL,
    [dmax_avg_log_write_percent] DECIMAL (5, 2) NULL,
    [davg_max_session_percent]   DECIMAL (5, 2) NULL,
    [dmax_max_session_percent]   DECIMAL (5, 2) NULL,
    [davg_max_worker_percent]    DECIMAL (5, 2) NULL,
    [dmax_max_worker_percent]    DECIMAL (5, 2) NULL
);

CREATE TABLE [dbo].[sqldbmon] (
    [Id]                 INT        IDENTITY (1, 1) NOT NULL,
    [timestamp]          DATETIME   NULL,
    [Down_CPU_Fit]       FLOAT (53) NULL,
    [Down_Log_Write_Fit] FLOAT (53) NULL,
    [Down_Data_IO_Fit]   FLOAT (53) NULL,
    [Up_CPU_Fit]         FLOAT (53) NULL,
    [Up_Log_Write_Fit]   FLOAT (53) NULL,
    [Up_Data_IO_Fit]     FLOAT (53) NULL
);