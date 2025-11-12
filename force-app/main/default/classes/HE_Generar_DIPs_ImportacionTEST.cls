@istest()
public class HE_Generar_DIPs_ImportacionTEST {
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
     system.debug('ma'+ma);
     
     Valija__c  bc=new Valija__c();
     bc.name='543245';
     bc.Master_Importacion__c=ma.id;
   
     insert bc;
     Codigo_Arancelario__c ca=new Codigo_Arancelario__c();
     ca.Name='usb';
     ca.Codigo__c='122412';
     insert ca;
     Detalles_Guias_Importacion__c  dm=new Detalles_Guias_Importacion__c();
     dm.Name='13452';
     dm.Master_Importacion__c=ma.id;
     dm.Valija__c=bc.id;
     dm.Estado_Guia__c='Documental';
     dm.DIP_Confecionada__c=false;
     dm.Nombre_Cod_Arancelario__c=ca.id;
     insert dm;
     system.debug('dm'+dm);
     
      apexPages.Currentpage().getParameters().put('id',dm.Master_Importacion__c);
      ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
      HE_Generar_DIPs_Importacion_Controller  he=new HE_Generar_DIPs_Importacion_Controller(ast);   
     he.Generar_DIP();
     
 }
}