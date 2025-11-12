@istest
public class PDFconstructorTEST {
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
     
     Caja__c  bc=new Caja__c();
     bc.name='543245';
     bc.Master__c=ma.id;
     bc.Bag_Code__c='543245';
     insert bc;
     
     Detalles_Master__c  dm=new Detalles_Master__c();
     dm.Name='13452';
     dm.Master__c=ma.id;
     dm.Bag_Code__c=bc.id;
     dm.Estado_Guia__c='Documental';
     dm.DIP_Confecionada__c=false;
    dm.Pieces__c=1;
    
     insert dm;
     
      apexPages.Currentpage().getParameters().put('id',dm.id);
      ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
      PDFconstructor  ce=new PDFconstructor(ast);   
     ce.inicio();
     
 }
}