public class HE_Generar_DIPs_Controler {
 public string idm{get;set;}
    public list<tempuriOrg.Estruct_Envio> listado_estado{get;set;}
    public HE_Generar_DIPs_Controler(ApexPages.StandardController controller){
           idm = ApexPages.currentPage().getParameters().get('id');
    }
    
    public PageReference Generar_DIP() {
        system.debug('idm'+idm);
        string guia='Documental';
         List<Detalles_Master__c> detmast;
        if(!test.isRunningTest()){
         detmast = [SELECT Id,name, Master__r.Name,  Puerto_de_Destino__c,Master__r.Aeropuerto_Origen__c, Cod_Arancelario__c,Nombre_Cod_Arancelario__r.Codigo__c,
                    Nombre_Cod_Arancelario__r.Name,DIP_Confecionada__c,Master__r.Master_AirwayBill__c,Descripcion__c
                                            FROM Detalles_Master__c where Master__c=:idm  and DIP_Confecionada__c=:false  and Estado_Guia__c=:guia];
        }else{
         detmast = [SELECT Id,name, Master__r.Name,  Puerto_de_Destino__c,Master__r.Aeropuerto_Origen__c, Cod_Arancelario__c,DIP_Confecionada__c,Master__r.Master_AirwayBill__c,
                    Nombre_Cod_Arancelario__r.Codigo__c,Nombre_Cod_Arancelario__r.Name,Descripcion__c
                                            FROM Detalles_Master__c where Master__c=:idm  and DIP_Confecionada__c=:false];
        }
            system.debug('detmast'+detmast);
        string finalstr='';
        for(Detalles_Master__c dt: detmast){
            
     
      //  string recordString = dt.Master__r.Name+','+dt.name+','+','+dt.Puerto_de_Destino__c+','+dt.Master__r.Aeropuerto_Origen__c+','+dt.Nombre_Cod_Arancelario__r.Codigo__c+','+','+dt.Nombre_Cod_Arancelario__r.Name+'\n';
       string recordString = dt.Master__r.Name+','+dt.name+','+','+'HK'+','+'HK'+','+dt.Nombre_Cod_Arancelario__r.Codigo__c+','+','+dt.Descripcion__c+'\n';
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
        csv.Name= detmast.get(0).Master__r.Master_AirwayBill__c+'_DIPs.xls';
        insert csv;
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        
        string csvname= detmast.get(0).Master__r.Name+'_DIPs.xls';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'jcarvajal@nectia.com'};
            String subject ='Detalles_Master__c CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Detalles_Master__c_CSV ');
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
          pageReference p = new PageReference('/'+idm);
            
        
        return p; 
    }
}