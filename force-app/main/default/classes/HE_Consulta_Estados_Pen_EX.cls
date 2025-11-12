global class HE_Consulta_Estados_Pen_EX implements Schedulable {
    global void execute(SchedulableContext SC) {  
        
        HE_actualiza_estado_EX actualiza_DHL = new HE_actualiza_estado_EX(); 
        Id batchIdDHL = Database.executeBatch(actualiza_DHL,1);
        
         HE_actualiza_estado_EX_Fedex actualiza_fedex = new HE_actualiza_estado_EX_Fedex(); 
        Id batchIdfedex = Database.executeBatch(actualiza_fedex,1);
      
            }
       
     
}