/**********************************************************************************
Desarrollado por: Nectia / SEIDOR Chile.
Autor: Jorge Carvajal (JC)
Proyecto:  
Modificado por: Rodrigo López (RL)
Descripción:  
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 19-06-2020            JC                   Creación de la Clase.
1.1 05-06-2023            RL                   Se modifica método obtener_pdf para obtener PDF de campo PDF_Base64__c del Objeto Documento
***********************************************************************************/

public class HE_servicio_Factura {
    public Transient String  base64{get;set;} 
    public Transient String  base64CSV{get;set;} 
    public  String  id{get;set;} 
    public  HE_servicio_Factura(){
        
    }
    public  HE_servicio_Factura(ApexPages.StandardController  Controller) {
        id=ApexPages.currentPage().getParameters().get('id');
        system.debug('id'+id);  
    }
    public PageReference ver_factura_de_costos(){
        Costo_de_Exportacion__c cos=[select id,name, Factura__c,Factura__r.name,Factura__r.ID_Documento__c from Costo_de_Exportacion__c where id=:id];
        obtener_pdf(integer.valueOf(cos.Factura__r.ID_Documento__c));
        return null;
    }
    public PageReference ver_factura_desde_factura(){
        Factura__c fac=[select id,name,ID_Documento__c  from Factura__c where id=:id];
        obtener_pdf(integer.valueOf(fac.ID_Documento__c));
        return null;
    }
    public string token(string rutCliente,string rutUsuario,string contrasena,string sistema,integer numeroSerie){
        
        
        
        AutentificadorServipymeClPerfilamientoWs.AutenticadorSoap   au=new AutentificadorServipymeClPerfilamientoWs.AutenticadorSoap();
        string str;
        if(!test.isRunningTest()){
            //   str=au.Autenticar('99537600-8','7128378-K','cobo2020','1', 1); 
            str=au.Autenticar(rutCliente,rutUsuario,contrasena,sistema, numeroSerie); 
        }
        system.debug('str'+str);
        return str;   
    }
    public ArchivoDeVentasElectronicas.CargarYEmitirResult_element validar(string base64CSV,string rutCliente,string rutUsuario,string contrasena,string sistema,integer numeroSerie ){
        string token=token( rutCliente, rutUsuario, contrasena, sistema, numeroSerie);
        
        ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap  ar=new ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap();
        ArchivoDeVentasElectronicas.CargarYEmitirResult_element  arch=new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
        if(!test.isRunningTest()){
            arch=ar.CargarYEmitir(token, base64CSV, 1, 1, 1);//sandbox //produccion
            //arch=ar.CargarYEmitir(token, base64CSV, 0, 0, 0);//produccion
            // arch=ar.CargarYEmitir(token, base64CSV, 1, 0, 0);//produccion
        }
        
        system.debug('ar'+arch);
        
        
        return arch;
    }
    public ArchivoDeVentasElectronicas.CargarYEmitir2Result_element validar2(string base64CSV,string base64CSVOC,string rutCliente,string rutUsuario,string contrasena,string sistema,integer numeroSerie){
        string token=token( rutCliente, rutUsuario, contrasena, sistema, numeroSerie);
        
        ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap  ar=new ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap();
        ArchivoDeVentasElectronicas.CargarYEmitir2Result_element  arch=new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
        
        
        if(!test.isRunningTest()){
            arch=ar.CargarYEmitir2(token,base64CSV,base64CSVOC,1,1,1);//sandbox //produccion
            //arch=ar.CargarYEmitir2(token,base64CSV,base64CSVOC,0,0,0);//produccion
            // arch=ar.CargarYEmitir2(token,base64CSV,base64CSVOC,1,0,0);//produccion
        }
        
        system.debug('ar'+arch);
        return arch;
    }
    
    public PageReference ver_pdf(){
        try{
            integer identificador=integer.valueOf(ApexPages.currentPage().getParameters().get('id'));
            obtener_pdf(identificador);
        }catch(Exception ex){
            System.debug(ex.getMessage());
            System.debug(ex.getStackTraceString());
        }
        return null;
    }
    public string obtener_pdf(integer identificador){
        Factura__c datosFactura = [SELECT Id, Name, Pdf_Base64__c FROM Factura__c WHERE ID_Documento__c =: String.valueOf(identificador)];

        if(datosFactura != null){
            if(!String.isBlank(datosFactura.Pdf_Base64__c)){
                base64=datosFactura.Pdf_Base64__c;
            }else{
                EndPoint_Factura__mdt ef= [SELECT Id, DeveloperName, EndPoint__c, rutCliente__c, rutUsuario__c, contrasena__c, sistema__c, numeroSerie__c FROM EndPoint_Factura__mdt where DeveloperName=:'Autenticar'];
                
                string token=token( ef.rutCliente__c, ef.rutUsuario__c, ef.contrasena__c, ef.sistema__c, integer.valueOf(ef.numeroSerie__c) );
                ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap  ar=new ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap();
                string str;
                if(!test.isRunningTest()){
                    str= ar.ObtenerPDF(token, identificador);
                } 
                system.debug('str='+str);
                base64=str;
            }
        }
        return null;
    }
    
}