@istest
public class HE_Generar_CSV_ImportacionTEST {
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
     Valija__c  vj=new Valija__c();
     vj.name='543245';
     vj.Master_Importacion__c=ma.id;
     //vj.='543245';
     insert vj;
     Detalles_Guias_Importacion__c  dm=new Detalles_Guias_Importacion__c();
     dm.Name='13452';
     dm.Master_Importacion__c=ma.id;
     dm.Valija__c=vj.id;
     insert dm;
      apexPages.Currentpage().getParameters().put('id',ma.id);
      ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
      HE_Generar_CSV_Importacion_controller  he=new HE_Generar_CSV_Importacion_controller(ast);   
     he.GenerarCSV();
     
 }
}