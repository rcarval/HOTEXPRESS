@istest(SeeAllData=false)
public class HE_codigo_aduaneroTEST {
static testMethod void test1() {
    Account  acc=new Account();
     acc.Name='1211';
     insert acc;
     Factura__c  f=new Factura__c();
     f.Cuenta__c=acc.id;
     f.Tipo_de_Servicio__c='IMPORT';
     insert f;
     
     Master__c  ma=new Master__c();
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
     
     Caja__c  bc=new Caja__c();
     bc.name='543245';
     bc.Master__c=ma.id;
     bc.Bag_Code__c='543245';
     insert bc;
     Codigo_Arancelario__c ca=new Codigo_Arancelario__c();
     ca.Name='usb';
     ca.Codigo__c='122412';
     ca.Descripcion_Ingles__c='usb';
     insert ca;
     Detalles_Master__c  dm=new Detalles_Master__c();
     dm.Name='13452';
     dm.Master__c=ma.id;
     dm.Bag_Code__c=bc.id;
     dm.Estado_Guia__c='Documental';
     dm.DIP_Confecionada__c=false; 
     dm.Descripcion__c='usb';
     insert dm;
    list<id>  ds=new  list<id>();
    ds.add(dm.id);
    HE_codigo_aduanero  heca=new HE_codigo_aduanero();
    HE_codigo_aduanero.HE_codigo_aduanero(ds);
}
    
}