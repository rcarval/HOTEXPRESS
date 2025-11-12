global class HE_actualiza_estado_EX_Fedex implements Database.Batchable<sObject>, Database.AllowsCallouts {
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string str='SELECT Id, Name, Agente__c,Codigo_Tracking__c,Detalle_Tracking__c, N_de_Guia__c,Estado_Guia__c, Fecha_Ultimo_Estado__c, Estado__c FROM Guias_de_Exportacion__c'+
            ' WHERE Estado__c =\''+'Despachado'+'\' AND Agente__c=\''+'Fedex'+'\' AND N_de_Guia__c!=null AND Codigo_Tracking__c!=\''+'DL'+'\' ';
        //AND Estado_Guia__c!=\''+'Entregado'+'\'
        //AND Codigo_Tracking__c!=\''+'DL'+'\' 
        return Database.getQueryLocator(str);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Guias_de_Exportacion__c> dtmt){
        // process each batch of records
           
        HE_Consulta_Servicio_Fedex ser=new HE_Consulta_Servicio_Fedex();   
        fedexComWsTrackV18.TrackReply resp=new fedexComWsTrackV18.TrackReply();
        List<Guias_de_Exportacion__c> listupdate=new  List<Guias_de_Exportacion__c>();
        for (integer j=0; j<dtmt.size(); j++) { 
            
            resp=ser.Track_Validation(dtmt.get(j).N_de_Guia__c);
            if(test.isRunningTest()){
                 list<fedexComWsTrackV18.CompletedTrackDetail> listCompletedTrackDetails=new list<fedexComWsTrackV18.CompletedTrackDetail>();
                 fedexComWsTrackV18.CompletedTrackDetail CompletedTrackDetails=new fedexComWsTrackV18.CompletedTrackDetail();
                  list<fedexComWsTrackV18.TrackDetail> listTrackDetails=new list<fedexComWsTrackV18.TrackDetail>();
                 fedexComWsTrackV18.TrackDetail TrackDetails=new fedexComWsTrackV18.TrackDetail();
                  
                 fedexComWsTrackV18.TrackStatusDetail StatusDetail=new fedexComWsTrackV18.TrackStatusDetail();
                 StatusDetail.CreationTime=system.now();
                 StatusDetail.Description='test';
                
                TrackDetails.StatusDetail=StatusDetail;
                listTrackDetails.add(TrackDetails);
                CompletedTrackDetails.TrackDetails=listTrackDetails;
                listCompletedTrackDetails.add(CompletedTrackDetails);
                resp.CompletedTrackDetails=listCompletedTrackDetails;
            }
            if(resp.CompletedTrackDetails!=null){
                 if(resp.CompletedTrackDetails[0].TrackDetails!=null){
            if(resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail!=null){
                dtmt.get(j).Fecha_Ultimo_Estado__c=date.valueOf(resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail.CreationTime);
                if(resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail.Code=='DL'){
                dtmt.get(j).Estado_Guia__c=resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail.Description+' - '+resp.CompletedTrackDetails[0].TrackDetails[0].DeliverySignatureName; 
               }else{
                dtmt.get(j).Estado_Guia__c=resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail.Description;    
                }
                dtmt.get(j).Codigo_Tracking__c=resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail.Code;
                dtmt.get(j).Detalle_Tracking__c='fecha de estado :'+resp.CompletedTrackDetails[0].TrackDetails[0].StatusDetail.CreationTime; 
                
              
                listupdate.add(dtmt.get(j));
            }
            }  
            }
         
        }
        if(listupdate.size()>0){
            system.debug('listupdate'+listupdate);
            update listupdate;
        }
        
        
    }    
    
    global void finish(Database.BatchableContext bc){
        System.debug(  'fin proceso...');
        
    }    
    
}