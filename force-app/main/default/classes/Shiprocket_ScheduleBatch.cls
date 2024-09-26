global class Shiprocket_ScheduleBatch implements Schedulable{
    global void execute(SchedulableContext sc) {
        // Trigger the batch class
        Shiprocket_DeliveryStatus_Batch batchJob = new Shiprocket_DeliveryStatus_Batch();
        Database.executeBatch(batchJob, 50);
    }
    
    // Method to schedule the batch to run at specified intervals
   public static void scheduleJob() {
        String cronExpression = '0 25 * * * ?'; // Every 15 minutes
        Shiprocket_ScheduleBatch schedulable = new Shiprocket_ScheduleBatch();
        String jobID = System.schedule('Shiprocket_DeliveryStatus_15mnts', cronExpression, schedulable);
    }
    
   
  
	
	// Method to schedule the batch job every day at 7 PM
    
}