public class HE_Generar_CSV_Controler {
    public string idm{get;set;}
    public list<tempuriOrg.Estruct_Envio> listado_estado{get;set;}
    public HE_Generar_CSV_Controler(ApexPages.StandardController controller){
           idm = ApexPages.currentPage().getParameters().get('id');
    }
     public HE_Generar_CSV_Controler(){
    }
    public PageReference GenerarCSV() {
        
        
               
         
        
        Master__c mst=[SELECT Estado__c, Id, Name FROM Master__c where id=:idm];
       
        List<Detalles_Master__c> detmast = [SELECT Id,Master__c, Master__r.Name,  Consignatario__c,  Puerto_de_Destino__c,  Pieces__c,  Peso__c,  Descripcion__c, 
                                            Valor__c, Estado_IVA__c, Vendedor__c,Master__r.Aeropuerto_Origen__c,Master__r.Fecha_Recepcion__c,Master__r.N_Vuelo__c,  Name,Master__r.Fecha_Vuelo__c,
                                            Seguro__c,  Rut_Consignatario__c,  Direccion_Consignatario__c,  Comuna__c,  Tipo_Flete__c,  Flete__c,  ID_empresa__c,  ID_Tipo__c 
                                            FROM Detalles_Master__c where Master__c=:idm];
       /* string header='Master__c, Master__r.Name,  Consignatario__c,  Puerto_de_Destino__c,  Pieces__c,  Peso__c,  Descripcion__c,'+
                      'Valor__c,  Vendedor__c,Master__r.Aeropuerto_Origen__c,Master__r.Fecha_Recepcion__c,Master__r.N_Vuelo__c,  Name,Master__r.Fecha_Vuelo__c,'+
                      'Seguro__c,  Rut_Consignatario__c,  Direccion_Consignatario__c,  Comuna__c,  Tipo_Flete__c,  Flete__c,  ID_empresa__c,  ID_Tipo__c'+'\n';*/
       Transient  string finalstr ='';
       //Lista para guardar los datos concatenados
       List<String> stringList = new List<String>();
        if(detmast.size()>0)
        {
            for(Detalles_Master__c dt: detmast)
            {
                // numero de guia , consignatario ,puerto destino,  cantidad, peso ,descripcion, valor dolar  ,  nombre proveedor,  dir origen ,  fecha  , numero vuelo , numero master ,fecha ingreso,n , rut consignatario, direccion,  comuna ,0,flete ,hot,1 
                //     a                b                c             d        e       f            g                   h             i             j          k              l               m        n      o                  p           q   r   s     t  u                 
                decimal flete=0;
                if(dt.Flete__c!=0  && dt.Flete__c!=null){
                flete=dt.Flete__c;
                }
                decimal seguro=0;
                if(dt.Seguro__c!=0  && dt.Seguro__c!=null){
                seguro=dt.Seguro__c;
                }
            string fecha='';
                if(dt.Master__r.Fecha_Vuelo__c!=null  ){
                datetime f=dt.Master__r.Fecha_Vuelo__c;
                fecha   = f.format('dd/MM/yyyy'); 
                }
                string fecha2='';
                if(dt.Master__r.Fecha_Recepcion__c!=null  ){
                    datetime f2=dt.Master__r.Fecha_Recepcion__c;
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
                
            
                string Consignatario=dt.Consignatario__c==null?'':((dt.Consignatario__c).replace(',',' '));
                string descripcion=dt.Descripcion__c==null?'':((dt.Descripcion__c).replace(',',' '));
                string direccion=dt.Direccion_Consignatario__c==null?'': ((dt.Direccion_Consignatario__c).replace(',',' '));
                string comuna=dt.Comuna__c==null?'': ((dt.Comuna__c).replace(',',' '));
                decimal peso=dt.Peso__c==null?null:dt.Peso__c.setscale(2);
                
                string recordString = dt.Name+' ,'+Consignatario+','+destino+','+dt.Pieces__c+','+Peso+','+
                                descripcion+','+dt.Valor__c+','+vendedor+','+dt.Master__r.Aeropuerto_Origen__c+','+fecha+','+
                                dt.Master__r.N_Vuelo__c+','+dt.Master__r.Name+','+fecha2+','+dt.Estado_IVA__c +','+dt.Rut_Consignatario__c+','+
                                direccion+','+comuna+','+seguro+','+flete+','+'HOT'+','+'1'+'\n';
                
                /*string recordString = dt.Master__c+','+dt.Master__r.Name+','+dt.Consignatario__c+','+'SCL'+','+dt.Pieces__c+','+dt.Peso__c+','+
                                dt.Descripcion__c+','+dt.Valor__c+','+dt.Vendedor__c+','+dt.Master__r.Aeropuerto_Origen__c+','+dt.Master__r.Fecha_Recepcion__c+','+
                                dt.Master__r.N_Vuelo__c+','+dt.Name+','+dt.Master__r.Fecha_Vuelo__c+','+''+','+dt.Rut_Consignatario__c+','+
                                dt.Direccion_Consignatario__c+','+dt.Comuna__c+','+''+','+'0'+','+'HOT'+','+'1'+'\n';*/
                // FFC - 21-02-2024
                //    finalstr = finalstr +recordString;
                recordString = remove1(recordString);
                stringList.add(recordString);

            }
            
            system.debug('082 - ffc - finalstr ' + String.join(stringList, ''));
        }
        //FFC - 21-02-2024 -- finalstr se caia por el tamaño
        // finalstr=remove1(finalstr);
        // blob csvBlob = Blob.valueOf(finalstr);
        //Se reemplaza por un listado
        blob csvBlob = Blob.valueOf(String.join(stringList, ''));
        Attachment csv=new Attachment();
        csv.Body=csvBlob;
        csv.ParentId=idm;
        csv.Name= mst.Name+'.csv';
        insert csv;
        Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
        
        string csvname= 'Detalles_Master__c.csv';
        csvAttc.setFileName(csvname);
        csvAttc.setBody(csvBlob);
        Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
        String[] toAddresses = new list<string> {'jcarvajal@nectia.com'};
            String subject ='Detalles_Master__c CSV';
        email.setSubject(subject);
        email.setToAddresses( toAddresses );
        email.setPlainTextBody('Detalles_Master__c_CSV ');
        if(csvBlob.size()>0){
        email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
        }
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        
        
       // mst.Estado__c='Enviado a Atrex';
      //  update mst;
      //  
        if(ApexPages.hasMessages()) {
            return null;
                } else{
                    
      //  enviar_atrex(idm);
          pageReference p = new PageReference('/'+idm);
           return p; 
                }
    }
    public  PageReference volver(){
        pageReference p = new PageReference('/'+idm);
           return p;  
    }
    /*   @future(callout=true)
    public static  void enviar_atrex(string id){
        HE_ServicioAtexManifiestoWS sam=new  HE_ServicioAtexManifiestoWS();
        Transient  string xml=HE_ServicioAtexManifiestoWS.XMLRequest(id);
        HE_ServicioAtexManifiestoWS.TESTIngresoManielecResult  resp=new HE_ServicioAtexManifiestoWS.TESTIngresoManielecResult();
        resp=sam.AtrexManifiestoCallout(xml);
        if(resp.Retorno.COD_OPERACION=='00'){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.CONFIRM,'master enviado a atrex exitosamente');
            ApexPages.addMessage(msg);
        }else{
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.ERROR,resp.Retorno.DESC_RETORNO);
            ApexPages.addMessage(msg); 
            if(resp.RespuestaManifiesto!=null){
               msg=new ApexPages.Message(ApexPages.Severity.ERROR,resp.RespuestaManifiesto.Error);
            ApexPages.addMessage(msg);  
            }
            
            if(resp.RespuestaGuias!=null){
                system.debug('resp.RespuestaGuias'+resp.RespuestaGuias);
                for(integer i=0;i<resp.RespuestaGuias.size();i++){
                     msg=new ApexPages.Message(ApexPages.Severity.ERROR,'guia '+resp.RespuestaGuias.get(i).Guia+' error '+resp.RespuestaGuias.get(i).Error);
                    ApexPages.addMessage(msg);  
                }
            }
            
        }

    }*/
 public  String remove1(String texto) {
     String[] original = ('À,Á,Â,Ã,Ä,Å,Æ,Ç,È,É,Ê,Ë,Ì,Í,Î,Ï,Ð,Ñ,Ò,Ó,Ô,Õ,Ö,Ø,Ù,Ú,Û,Ü,Ý,ß,à,á,â,ã,ä,å,æ,ç,è,é,ê,ë,ì,í,î,ï,ð,ñ,ò,ó,ô,õ,ö,ø,ù,ú,û,ü,ý,ÿ').split(',');
    
    
    String[] ascii =     ('A,A,A,A,A,A,A,C,E,E,E,E,I,I,I,I,D,N,O,O,O,O,O,O,U,U,U,U,Y,B,a,a,a,a,a,a,a,c,e,e,e,e,i,i,i,i,o,n,o,o,o,o,o,o,u,u,u,u,y,y').split(',');
    String output = texto;
   /* for (integer i=0; i<original.size(); i++) {
         output = output.replace(original[i], ascii[i]);

    }*/
     //system.debug('output='+output);
     return output;
}
}