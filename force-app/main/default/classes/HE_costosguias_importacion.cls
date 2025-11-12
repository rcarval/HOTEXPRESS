public class HE_costosguias_importacion {
    @InvocableMethod
    public static List<string>  costos(List<String> ids) {
        SYSTEM.debug(ids);
         List<Id> listid=new List<Id>();
        List<Costos_de_Importacion__c> ci = [SELECT Id,Costo__c,Estado__c,Guias_Importacion__c,Valor__c
                                             FROM Costos_de_Importacion__c WHERE Id in :ids order by Guias_Importacion__c];
        SYSTEM.debug(ci);
        string dato1='';
        for (Costos_de_Importacion__c cos_inp : ci) {
             
            if(dato1!=STRING.valueOf(cos_inp.Guias_Importacion__c) ){
                 listid.add(cos_inp.Guias_Importacion__c);
                 dato1=cos_inp.Guias_Importacion__c;
            }
        }
        
        List<Costos_de_Importacion__c> sumar_costos= [SELECT id, Valor__c,Guias_Importacion__c
                                                      FROM Costos_de_Importacion__c WHERE Guias_Importacion__c in :listid and Estado__c=:'Pendiente de Facturar'
                                                      order by Guias_Importacion__c];
         
        List<Costos_de_Importacion__c> sumar_costos_facturados= [SELECT id, Valor__c,Guias_Importacion__c
                                                                 FROM Costos_de_Importacion__c WHERE Guias_Importacion__c in :listid and Estado__c=:'Facturado'
                                                                 order by Guias_Importacion__c];
        
        List<Detalles_Guias_Importacion__c> det_guia= [SELECT id,Monto_por_Facturar__c,Monto_Facturado__c FROM Detalles_Guias_Importacion__c WHERE id in :listid];
        
        
        
        for(integer i=0;i<det_guia.size();i++){
            if(sumar_costos.size()>0){
                det_guia.get(i).Monto_por_Facturar__c=0;
                for (Costos_de_Importacion__c cost : sumar_costos) { 
                    if(det_guia.get(i).id==cost.Guias_Importacion__c){
                        det_guia.get(i).Monto_por_Facturar__c=det_guia.get(i).Monto_por_Facturar__c+cost.Valor__c;
                    }
                    
                }
            }
        }
        for(integer i=0;i<det_guia.size();i++){
            if(sumar_costos_facturados.size()>0){
                det_guia.get(i).Monto_Facturado__c=0;
                for (Costos_de_Importacion__c cost : sumar_costos_facturados) { 
                    if(det_guia.get(i).id==cost.Guias_Importacion__c){
                        det_guia.get(i).Monto_Facturado__c=det_guia.get(i).Monto_Facturado__c+cost.Valor__c;
                    }
                    
                }
            }
        }
        
        SYSTEM.debug(det_guia);
        update det_guia;
        
        return null;
    }
}