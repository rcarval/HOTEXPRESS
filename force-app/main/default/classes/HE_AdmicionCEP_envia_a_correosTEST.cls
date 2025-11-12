@istest
public class HE_AdmicionCEP_envia_a_correosTEST {
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
        dm.Direccion_Normalizada__c=true;
       dm.Pieces__c=1;
        insert dm;
      Detalles_Master__c  dm1=new Detalles_Master__c();
        dm1.Name='134522';
        dm1.Master__c=ma.id;
        dm1.Bag_Code__c=bc.id;
        dm1.Estado_Guia__c='Documental';
        dm1.DIP_Confecionada__c=false;
        dm1.Direccion_Normalizada__c=true;
     dm1.Pieces__c=1;
        insert dm1;
   /*  Historial_de_Tracking__c ht=new Historial_de_Tracking__c();
        ht.Detalles_Master__c=dm.id;
        ht.Fecha__c=system.now();
        ht.Estado_Tracking__c='entregado';
        ht.Name='test'; 
        insert ht;*/
        
     
         apexPages.Currentpage().getParameters().put('id',ma.id);
        ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
        HE_AdmicionCEP_envia_a_correos  ce=new HE_AdmicionCEP_envia_a_correos(ast);  
       ce.redirecion();
        ce.enviar_a_correos();
      
        
        
    }
    static testMethod void test2() {
        
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
        dm.Direccion_Normalizada__c=true;
        dm.Pieces__c=1;
        insert dm;
      Detalles_Master__c  dm1=new Detalles_Master__c();
        dm1.Name='134522';
        dm1.Master__c=ma.id;
        dm1.Bag_Code__c=bc.id;
        dm1.Estado_Guia__c='Documental';
        dm1.DIP_Confecionada__c=false;
        dm1.Direccion_Normalizada__c=true;
        dm1.Pieces__c=1;
        insert dm1;
    
        
     
         apexPages.Currentpage().getParameters().put('id',ma.id);
        ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
        HE_AdmicionCEP_envia_a_correos  ce=new HE_AdmicionCEP_envia_a_correos(ast);  
       ce.genera_CSV_Correos();
      
        
        
    }
}