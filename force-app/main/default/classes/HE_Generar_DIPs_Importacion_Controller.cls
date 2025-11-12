public class HE_Generar_DIPs_Importacion_Controller {
  public string idm{get;set;}
   // public list<tempuriOrg.Estruct_Envio> listado_estado{get;set;}
    public HE_Generar_DIPs_Importacion_Controller(ApexPages.StandardController controller){
           idm = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference Generar_DIP() {
        system.debug('idm'+idm);
        string guia='Documental';
         List<Detalles_Guias_Importacion__c> detmast;
        if(!test.isRunningTest()){
         detmast = [SELECT Id,name, Master_Importacion__r.Name,  Puerto_de_Destino__c,Master_Importacion__r.Aeropuerto_Origen__c, Cod_Arancelario__c,DIP_Confecionada__c,Master_Importacion__r.Master_AirwayBill__c,
                    Nombre_Cod_Arancelario__r.Codigo__c, Nombre_Cod_Arancelario__r.Name,Pais_de_Origen__r.Cod_Pais__c,Pais_de_Adquisicion__r.Cod_Pais__c
                                            FROM Detalles_Guias_Importacion__c where Master_Importacion__c=:idm  and DIP_Confecionada__c=:false  and Estado_Guia__c=:guia];
        }else{
         detmast = [SELECT Id,name, Master_Importacion__r.Name,  Puerto_de_Destino__c,Master_Importacion__r.Aeropuerto_Origen__c, Cod_Arancelario__c,DIP_Confecionada__c,Master_Importacion__r.Master_AirwayBill__c,
                    Nombre_Cod_Arancelario__r.Codigo__c,Nombre_Cod_Arancelario__r.Name,Pais_de_Origen__r.Cod_Pais__c,Pais_de_Adquisicion__r.Cod_Pais__c
                                            FROM Detalles_Guias_Importacion__c where Master_Importacion__c=:idm  and DIP_Confecionada__c=:false];
        }
            system.debug('detmast'+detmast);
        string finalstr='';
        for(Detalles_Guias_Importacion__c dt: detmast){
            
     
       // string recordString = dt.Master_Importacion__r.Name+','+dt.name+','+''+dt.Puerto_de_Destino__c+','+','+dt.Master_Importacion__r.Aeropuerto_Origen__c+','+dt.Cod_Arancelario__c+'\n';
        string recordString = dt.Master_Importacion__r.Name+','+dt.name+','+','+dt.Pais_de_Adquisicion__r.Cod_Pais__c+','+dt.Pais_de_Origen__r.Cod_Pais__c+','+dt.Nombre_Cod_Arancelario__r.Codigo__c+','+','+dt.Nombre_Cod_Arancelario__r.Name+'\n';
         
            finalstr = finalstr +recordString;
        }
        
         for(integer i=0;i<detmast.size();i++){
              detmast.get(i).DIP_Confecionada__c=true;
         }
        update detmast;
        blob csvBlob = Blob.valueOf(finalstr);
        Attachment csv=new Attachment();
        csv.Body=csvBlob;
        csv.ParentId=idm;
        csv.Name= detmast.get(0).Master_Importacion__r.Master_AirwayBill__c+'_DIPs.xls';
        insert csv;
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        
        string csvname= detmast.get(0).Master_Importacion__r.Name+'_DIPs.xls';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'jcarvajal@nectia.com'};
            String subject ='Detalles_Guias_Importacion__c CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Detalles_Guias_Importacion__c_CSV ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
          pageReference p = new PageReference('/'+idm);
            
        
        return p; 
    }
}