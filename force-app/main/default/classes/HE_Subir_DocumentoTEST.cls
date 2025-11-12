@istest(SeeAllData=false)
public class HE_Subir_DocumentoTEST {
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
        
        Detalles_Master__c  dm=new Detalles_Master__c();
        dm.Name='99805443861';
        dm.Master__c=ma.id;
        dm.Bag_Code__c=bc.id;
        dm.Estado_Guia__c='Documental';
        dm.DIP_Confecionada__c=false;
        dm.Pieces__c=1;
        insert dm;
          Detalles_Master__c  dm1=new Detalles_Master__c();
        dm1.Name='99805443862';
        dm1.Master__c=ma.id;
        dm1.Bag_Code__c=bc.id;
        dm1.Estado_Guia__c='libre';
        dm1.DIP_Confecionada__c=false;
        dm1.Pieces__c=1;
        insert dm1;
          Detalles_Master__c  dm2=new Detalles_Master__c();
        dm2.Name='99805443863';
        dm2.Master__c=ma.id;
        dm2.Bag_Code__c=bc.id;
       
        dm2.DIP_Confecionada__c=false;
        dm2.Pieces__c=1;
        insert dm2;
       
        
        //apexPages.Currentpage().getParameters().put('id',ma.id);
        ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
        HE_Subir_Documento  he=new HE_Subir_Documento(ast);  
        
        
        string xml='<?xml version="1.0" encoding="ISO-8859-1"?>'+
             '<Rows>'+
            '<Row>'+
            '<NumeroDoc>99805443861</NumeroDoc>'+
            '<MotivoSeleccion></MotivoSeleccion>'+
            '<ResultadoSeleccion></ResultadoSeleccion>'+
            '<Detalle>Más Info.</Detalle>'+
            '</Row>'+
            '<Row>'+
            '<NumeroDoc>99805443862</NumeroDoc>'+
            '<MotivoSeleccion>D-DECLARACION</MotivoSeleccion>'+
            '<ResultadoSeleccion></ResultadoSeleccion>'+
            '<Detalle>Más Info.</Detalle>'+
            '</Row>'+
            '<Row>'+
            '<NumeroDoc>99805443863</NumeroDoc>'+
            '<MotivoSeleccion>LIBRE-LIBRE</MotivoSeleccion>'+
            '<ResultadoSeleccion></ResultadoSeleccion>'+
            '<Detalle>Más Info.</Detalle>'+
            '</Row>'+
            '</Rows>';
        HE_Subir_Documento.estado(ma.id, 'ejemplo', 'test', '12345', xml);
        
    }
}