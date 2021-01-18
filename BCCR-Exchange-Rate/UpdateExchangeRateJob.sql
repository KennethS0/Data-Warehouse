USE msdb ;  
GO  

--EXEC dbo.sp_delete_job @job_name = N'Exchange Rate update from BCCR web service' ;  

EXEC dbo.sp_add_job  
    @job_name = N'Exchange Rate update from BCCR web service' ;  
GO  
EXEC sp_add_jobstep  
    @job_name = N'Exchange Rate update from BCCR web service',  
    @step_name = N'Update exchange rate table',  
    @subsystem = N'TSQL',  
    @command = N'USE [ROCKET-BD2] EXEC dbo.GetExchangeRateForToday',   
    @retry_attempts = 5,  
    @retry_interval = 5 ;  
GO  
EXEC dbo.sp_add_schedule  
    @schedule_name = N'ExchangeRateUpdate',  
    @freq_type = 4, -- daily  
	@freq_interval = 1,
    @active_start_time = 061500; -- 6:15am  
USE msdb ;  
GO  
EXEC sp_attach_schedule  
   @job_name = N'Exchange Rate update from BCCR web service',  
   @schedule_name = N'ExchangeRateUpdate';  
GO  
EXEC dbo.sp_add_jobserver  
    @job_name = N'Exchange Rate update from BCCR web service';  
GO  