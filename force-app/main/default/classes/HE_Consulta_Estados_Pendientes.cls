global  class HE_Consulta_Estados_Pendientes implements Schedulable {
    global void execute(SchedulableContext SC) {  
        
        HE_actualiza_estado myBatchObject = new HE_actualiza_estado(); 
        Id batchId = Database.executeBatch(myBatchObject,75);
        
      
            }
       
     
}