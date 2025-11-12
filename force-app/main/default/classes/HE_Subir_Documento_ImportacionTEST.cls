@istest( )
public class HE_Subir_Documento_ImportacionTEST {
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
        
        Detalles_Guias_Importacion__c  dm=new Detalles_Guias_Importacion__c();
        dm.Name='99805443861';
        dm.Master_Importacion__c=ma.id;
        dm.Valija__c=bc.id;
        dm.Estado_Guia__c='Documental';
        dm.DIP_Confecionada__c=false;
        insert dm;
        system.debug('dm'+dm);
        
        //apexPages.Currentpage().getParameters().put('id',ma.id);
        ApexPages.StandardController ast=new ApexPages.StandardController(ma);   
        HE_Subir_Documento_Importacion  he=new HE_Subir_Documento_Importacion(ast);  
        
        
        string xml='<Row>'+
            '<NumeroDoc>99805443861</NumeroDoc>'+
            '<MotivoSeleccion></MotivoSeleccion>'+
            '<ResultadoSeleccion></ResultadoSeleccion>'+
            '<Detalle>Más Info.</Detalle>'+
            '</Row>';
        HE_Subir_Documento_Importacion.estado(ma.id, 'ejemplo', 'test', '12345', xml);
        
    }
}