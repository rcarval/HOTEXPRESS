global class HE_actualiza_estado_EX implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string str='SELECT Id, Name, Agente__c, N_de_Guia__c,Estado_Guia__c,Detalle_Tracking__c,Codigo_Tracking__c, Fecha_Ultimo_Estado__c, Estado__c FROM Guias_de_Exportacion__c'+
            ' WHERE Estado__c =\''+'Despachado'+'\' AND Agente__c=\''+'DHL'+'\' AND N_de_Guia__c!=null '+ 
            ' AND (Codigo_Tracking__c!=\''+'BR'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'CS'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'DD'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'DS'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'OK'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'RT'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'SS'+'\' '+
            ' AND Codigo_Tracking__c!=\''+'TP'+'\' )';
        
        
        // BR  BROKER RELEASE
        // CS  CLOSED SHIPMENT
        // DD  DELIVERED DAMAGED
        // DS  DESTROYED / DISPOSAL
        // OK  DELIVERY
        // RT  RETURNED TO CONSIGNOR
        // SS  SHIPMENT STOPPED
        // TP  FORWARDED TO 3RD PARTY - NO DD's
        
        
        
        return Database.getQueryLocator(str);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Guias_de_Exportacion__c> dtmt){
        // process each batch of records
        HE_Consulta_Servicio_DHL.respuesta_Tracking resp=new HE_Consulta_Servicio_DHL.respuesta_Tracking();     
        HE_Consulta_Servicio_DHL ser=new HE_Consulta_Servicio_DHL();   
        List<Guias_de_Exportacion__c> listupdate=new  List<Guias_de_Exportacion__c>();
        for (integer j=0; j<dtmt.size(); j++) { 
            
            resp=ser.Tracking(dtmt.get(j).N_de_Guia__c);
            if(resp.estado!=null &&  resp.fecha!=null){
                if(resp.codigo!=dtmt.get(j).Codigo_Tracking__c ||  resp.estado!=dtmt.get(j).Estado_Guia__c){
                    dtmt.get(j).Fecha_Ultimo_Estado__c=date.valueOf(resp.fecha);
                    dtmt.get(j).Estado_Guia__c=resp.estado;
                    dtmt.get(j).Codigo_Tracking__c=resp.codigo;
                    if(resp.descripcion!=null){
                        string descripcion=resp.descripcion.replace('\r\n',' ').replace('\n',' ').replace('\r',' ').replace('\r\n',' ').replace('\n\r',' '); 
                        if(descripcion.length()<255){
                            dtmt.get(j).Detalle_Tracking__c=descripcion;
                        }else{
                            dtmt.get(j).Detalle_Tracking__c=descripcion.substring(0,254);
                        }
                    }
                    listupdate.add(dtmt.get(j));
                }
            }
            
        }
        if(listupdate.size()>0){
            
            update listupdate;
        }
        
        
    }    
    
    global void finish(Database.BatchableContext bc){
        System.debug(  'fin proceso...');
        
    }    
    
    
}