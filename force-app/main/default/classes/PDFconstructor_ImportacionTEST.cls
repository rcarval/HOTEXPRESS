@istest
public class PDFconstructor_ImportacionTEST {
 static testMethod void test1() {
    
     Account  acc=new Account();
     acc.Name='1211';
     insert acc;
     Factura__c  f=new Factura__c();
     f.Cuenta__c=acc.id;
     f.Tipo_de_Servicio__c='IMPORT';
     insert f;
     Master_Importacion__c  ma=new Master_Importacion__c();
     ma.Cuenta__c=acc.id;
     ma.Aeropuerto_Destino__c='stg';
     ma.Aeropuerto_Origen__c='stg';
     ma.Fecha_Recepcion__c=date.today();
     ma.Fecha_Vuelo__c=date.today();
     ma.Master_AirwayBill__c='1234';
     ma.name='1234';
     ma.Estado__c='activo';
     insert ma;
     Valija__c  bc=new Valija__c();
     bc.name='543245';
     bc.Master_Importacion__c=ma.id;
     
     insert bc;
     Detalles_Guias_Importacion__c  dm=new Detalles_Guias_Importacion__c();
     dm.Name='13452';
     dm.Master_Importacion__c=ma.id;
     dm.Valija__c=bc.id;
     insert dm;
      apexPages.Currentpage().getParameters().put('id',dm.id);
      ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
      PDFconstructor_Importacion  he=new PDFconstructor_Importacion(ast);   
     he.inicio();
     
 }
}