public class HE_CustomerDocsController {
    public string attachmentId {get;set;}
    public string id {get;set;}
    public string userId {get;set;}
    public string resultJSON {get;set;} 

    public PageReference docs(){
        
        return null;  
    }
    
    //Retorna adjuntos
    public void attachments(){    
        
        /*id = ApexPages.currentPage().getParameters().get('id');
        userId = ApexPages.currentPage().getParameters().get('userId'); 
        
        Endpoint__mdt endpoint = [select url__c from EndPoint__mdt where label = 'Url descarga archivos' limit 1];        
        List<Attachment> attachments = new List<Attachment>();
        attachments = [select id from Attachment where parentId =: id and createdbyId =: userId LIMIT 1];
        if(attachments.size() > 0){
           resultJSON ='{"success":true, "attachentUrl":'+ endpoint.url__c.replace('{ID}', attachments[0].id) +'}';
        }
        else{*/
           resultJSON ='{"success":false}';
        //}
    }
}