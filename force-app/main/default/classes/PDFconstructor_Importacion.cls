public class PDFconstructor_Importacion {
  public Detalles_Guias_Importacion__c detmas {get;set;}
    public string Iddet {get;set;}
    public string fecha {get;set;}
  public PDFconstructor_Importacion(ApexPages.StandardController controller){
        
        Iddet = ApexPages.currentPage().getParameters().get('id');
     // Iddet ='a050v000002xa5VAAQ';
      system.debug('Iddet'+Iddet);
      detmas=[SELECT Id,Vendedor__c,Shipper_Address__c,Shipper_Town__c,Cod_Postal_Vendedor__c,Pais_Vendedor__c,
              Consignatario__c,Direccion_Consignatario__c,Comuna__c,Ciudad_Consignatario__c,Postal_Code__c,Consignee_Phone__c,
              Pieces__c,Descripcion__c,Valor__c FROM Detalles_Guias_Importacion__c where id=:Iddet];
      system.debug('detmas'+detmas);
      date fch=date.today();
      fecha=fch.format();
  }
    
    public PageReference  inicio(){
        return null;
    }
}