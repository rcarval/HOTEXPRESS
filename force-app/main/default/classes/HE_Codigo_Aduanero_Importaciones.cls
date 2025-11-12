public class HE_Codigo_Aduanero_Importaciones {
 @InvocableMethod
    public static void HE_codigo_aduanero(List<Id> Ids) {
        system.debug('Ids'+Ids);
        list<Detalles_Guias_Importacion__c> detmas=new list<Detalles_Guias_Importacion__c>();
        list<Detalles_Guias_Importacion__c> ListDMI= [SELECT Id, Descripcion__c, Nombre_Cod_Arancelario__c FROM Detalles_Guias_Importacion__c WHERE Id in:Ids];
         system.debug('ListDMI'+ListDMI);
       list<Codigo_Arancelario__c> ListCA= [SELECT Id, Name, Descripcion_Ingles__c FROM Codigo_Arancelario__c ];
        system.debug('ListCA'+ListCA);
        for(Detalles_Guias_Importacion__c DMI: ListDMI){
            for(Codigo_Arancelario__c CA: ListCA){
                if( DMI.Descripcion__c == CA.Descripcion_Ingles__c ){
                    DMI.Nombre_Cod_Arancelario__c=CA.id;
                    detmas.add(DMI);
                }
            } 
        }  
         system.debug('detmas'+detmas);
        if(detmas.size()>0){
            update detmas;
        }
    }
}