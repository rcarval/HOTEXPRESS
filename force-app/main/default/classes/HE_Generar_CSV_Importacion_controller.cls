public class HE_Generar_CSV_Importacion_controller {
 public string idm{get;set;}
   // public list<tempuriOrg.Estruct_Envio> listado_estado{get;set;}
    public HE_Generar_CSV_Importacion_controller(ApexPages.StandardController controller){
           idm = ApexPages.currentPage().getParameters().get('id');
    }
    public PageReference GenerarCSV() {
        
       Master_Importacion__c mst=[SELECT Estado__c, Id, Name FROM Master_Importacion__c where id=:idm];
       
        List<Detalles_Guias_Importacion__c> detmast = [SELECT Id,Master_Importacion__c, Master_Importacion__r.Name,  Consignatario__c,  Puerto_de_Destino__c,  Pieces__c,  Peso__c,  Descripcion__c, 
                                            Valor__c,  Vendedor__c,Master_Importacion__r.Aeropuerto_Origen__c,Master_Importacion__r.Fecha_Recepcion__c,Master_Importacion__r.N_Vuelo__c,  Name,Master_Importacion__r.Fecha_Vuelo__c,
                                            Seguro__c,  Rut_Consignatario__c,  Direccion_Consignatario__c,  Comuna__c,  Tipo_Flete__c,  Flete__c,  ID_empresa__c,  ID_Tipo__c 
                                            FROM Detalles_Guias_Importacion__c where Master_Importacion__c=:idm];
        string header='Master_Importacion__c, Master_Importacion__r.Name,  Consignatario__c,  Puerto_de_Destino__c,  Pieces__c,  Peso__c,  Descripcion__c,'+
                      'Valor__c,  Vendedor__c,Master_Importacion__r.Aeropuerto_Origen__c,Master_Importacion__r.Fecha_Recepcion__c,Master_Importacion__r.N_Vuelo__c,  Name,Master_Importacion__r.Fecha_Vuelo__c,'+
                      'Seguro__c,  Rut_Consignatario__c,  Direccion_Consignatario__c,  Comuna__c,  Tipo_Flete__c,  Flete__c,  ID_empresa__c,  ID_Tipo__c'+'\n';
        string finalstr =' ';
        for(Detalles_Guias_Importacion__c dt: detmast){
        decimal flete=0;
            if(dt.Flete__c!=0  && dt.Flete__c!=null){
              flete=dt.Flete__c;
            }
            decimal seguro=0;
            if(dt.Seguro__c!=0  && dt.Seguro__c!=null){
              seguro=dt.Seguro__c;
            }
           string fecha='';
             if(dt.Master_Importacion__r.Fecha_Vuelo__c!=null  ){
             datetime f=dt.Master_Importacion__r.Fecha_Vuelo__c;
            fecha   = f.format('dd/MM/yyyy'); 
            }
             string fecha2='';
             if(dt.Master_Importacion__r.Fecha_Recepcion__c!=null  ){
                 datetime f2=dt.Master_Importacion__r.Fecha_Recepcion__c;
              fecha2=f2.format('dd/MM/yyyy');
            }
            string destino='SCL';
             if(dt.Puerto_de_Destino__c!=null  ){
                 destino=dt.Puerto_de_Destino__c;
            }     

			  string vendedor='';
            if(dt.Vendedor__c!=null  ){
                 vendedor=dt.Vendedor__c;
            }
            
           
            string Consignatario=dt.Consignatario__c==null?'':remove1((dt.Consignatario__c).replace(',',' '));
            string descripcion=dt.Descripcion__c==null?'':remove1((dt.Descripcion__c).replace(',',' '));
            string direccion=dt.Direccion_Consignatario__c==null?'': remove1((dt.Direccion_Consignatario__c).replace(',',' '));
            string comuna=dt.Comuna__c==null?'': remove1((dt.Comuna__c).replace(',',' '));
            decimal peso=dt.Peso__c==null?null:dt.Peso__c.setscale(2);
            
           
       /* string recordString = dt.Master_Importacion__c+','+dt.Master_Importacion__r.Name+','+dt.Consignatario__c+','+'SCL'+','+dt.Pieces__c+','+dt.Peso__c+','+
                              dt.Descripcion__c+','+dt.Valor__c+','+dt.Vendedor__c+','+dt.Master_Importacion__r.Aeropuerto_Origen__c+','+dt.Master_Importacion__r.Fecha_Recepcion__c+','+
                              dt.Master_Importacion__r.N_Vuelo__c+','+dt.Name+','+dt.Master_Importacion__r.Fecha_Vuelo__c+','+''+','+dt.Rut_Consignatario__c+','+
                              dt.Direccion_Consignatario__c+','+dt.Comuna__c+','+''+','+'0'+','+'HOT'+','+'1'+'\n';
           finalstr = finalstr +recordString;*/
		     
              string recordString = dt.Name+' ,'+Consignatario+','+destino+','+dt.Pieces__c+','+Peso+','+
                              descripcion+','+dt.Valor__c+','+vendedor+','+dt.Master_Importacion__r.Aeropuerto_Origen__c+','+fecha+','+
                              dt.Master_Importacion__r.N_Vuelo__c+','+dt.Master_Importacion__r.Name+','+fecha2+','+''+','+dt.Rut_Consignatario__c+','+
                              direccion+','+comuna+','+seguro+','+flete+','+'HOT'+','+'1'+'\n';
        }
        blob csvBlob = Blob.valueOf(finalstr);
        Attachment csv=new Attachment();
        csv.Body=csvBlob;
        csv.ParentId=idm;
        csv.Name= detmast.get(0).Master_Importacion__r.Name+'.csv';
        insert csv;
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        
        string csvname= 'Detalles_Guias_Importacion__c.csv';
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
        
        
      //  mst.Estado__c='Enviado a Atrex';
      //  update mst;
          pageReference p = new PageReference('/'+idm);
         return p;      
}
 public  String remove1(String texto) {
     String[] original = ('À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,ÿ').split(',');
    
    
    String[] ascii =     ('A,A,A,A,A,A,A,C,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,O,U,U,U,U,Y,B,a,a,a,a,a,a,a,c,e,e,e,e,i,i,i,i,o,n,o,o,o,o,o,o,u,u,u,u,y,y').split(',');
    String output = texto;
    for (integer i=0; i<original.size(); i++) {
         output = output.replace(original[i], ascii[i]);

    }
     system.debug('output='+output);
     return output;
}
}