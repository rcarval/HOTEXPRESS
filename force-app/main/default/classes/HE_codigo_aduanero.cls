public class HE_codigo_aduanero {
  @InvocableMethod
    public static void HE_codigo_aduanero(List<Id> Ids) {
        system.debug('Ids'+Ids);
        list<Detalles_Master__c> detmas=new list<Detalles_Master__c>();
        list<Detalles_Master__c> ListDM= [SELECT Id, Descripcion__c, Nombre_Cod_Arancelario__c FROM Detalles_Master__c WHERE Id in:Ids];
         system.debug('ListDM'+ListDM);
       list<Codigo_Arancelario__c> ListCA= [SELECT Id, Name, Descripcion_Ingles__c FROM Codigo_Arancelario__c ];
        system.debug('ListCA'+ListCA);
        for(Detalles_Master__c DM: ListDM){
            for(Codigo_Arancelario__c CA: ListCA){
                if( DM.Descripcion__c == CA.Descripcion_Ingles__c ){
                    DM.Nombre_Cod_Arancelario__c=CA.id;
                    detmas.add(DM);
                }
            } 
        }  
         system.debug('detmas'+detmas);
        if(detmas.size()>0){
            update detmas;
        }
    }
}