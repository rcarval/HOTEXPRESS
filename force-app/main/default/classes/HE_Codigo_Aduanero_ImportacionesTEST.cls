@istest 
public class HE_Codigo_Aduanero_ImportacionesTEST {
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
     ca.Descripcion_Ingles__c='usb';
     insert ca;
     Detalles_Guias_Importacion__c  dm=new Detalles_Guias_Importacion__c();
     dm.Name='13452';
     dm.Master_Importacion__c=ma.id;
     dm.Valija__c=bc.id;
     dm.Estado_Guia__c='Documental';
     dm.DIP_Confecionada__c=false; 
     dm.Descripcion__c='usb';
     insert dm;
    list<id>  ds=new  list<id>();
    ds.add(dm.id);
    HE_Codigo_Aduanero_Importaciones  heca=new HE_Codigo_Aduanero_Importaciones();
    HE_Codigo_Aduanero_Importaciones.HE_codigo_aduanero(ds);
}
    
}