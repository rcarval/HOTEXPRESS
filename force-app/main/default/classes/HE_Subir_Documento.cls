public class HE_Subir_Documento {
    public static String idmaster{get; set;}
    public blob archivo{get; set;}
    public integer largo{get; set;}
     public static String NumeroDoc{get; set;}
    
    public Attachment objCaseAtt {get; set;}
      public static list<listado> lista{get; set;}
    public static list<string> listall{get; set;}
    public static list<string> listad{get; set;}
    public static list<string> listao{get; set;}
     public static list<listado> listaotros{get; set;}
 
    public HE_Subir_Documento(ApexPages.StandardController controller) {
        idmaster=controller.getId();
    }
    
      @RemoteAction
    public static String   estado(String sinId, string attachmentBody, String attachmentName, String attachmentId,string xmls){
         system.debug('sinId'+sinId);
        
        system.debug('attachmentBody'+attachmentBody);
        system.debug('attachmentName'+attachmentName);
          Blob b = EncodingUtil.base64Decode(attachmentBody);

 HE_Subir_Documento.listado items=new HE_Subir_Documento.listado();
      
          DOM.Document doc = new DOM.Document();
            
                        doc.load(xmls);    
                        DOM.XMLNode root = doc.getRootElement();
         lista=new list<listado>();
        listall=new list<string>();
        listad=new list<string>();
        listao=new list<string>();
        listaotros=new list<listado>();
         for ( Dom.XMLNode tc : root.getChildElements() ) {  
            items=new HE_Subir_Documento.listado();
            items.NumDoc=tc.getChildElement('NumeroDoc', null).getText();
            items.MotivoSelec=tc.getChildElement('MotivoSeleccion', null).getText();
             lista.add(items); 
              
        }  
       
       //  parseXML(root);
       list<Detalles_Master__c>   detmast= new  list<Detalles_Master__c>();
          system.debug('tamaño '+lista.size());
         system.debug('lista'+lista);
        system.debug('detmast'+detmast);
        integer contador=0;
        for(listado lo: lista){
            if(lo.MotivoSelec=='D-DECLARACION'){
             listad.add(lo.NumDoc);   
            }else if(lo.MotivoSelec=='LIBRE-LIBRE'){
              listall.add(lo.NumDoc);  
            }
            else{
                listao.add(lo.NumDoc);
                listaotros.add(lo);
            }
                
            }
             list<Detalles_Master__c>   detmastD= [SELECT Id, Name, Master__c, Estado_Aduana__c, Estado_Guia__c FROM Detalles_Master__c where Master__c =:sinId and Name in:listad];
             list<Detalles_Master__c>   detmastLL= [SELECT Id, Name, Master__c, Estado_Aduana__c, Estado_Guia__c FROM Detalles_Master__c where Master__c =:sinId and Name in:listall];
             list<Detalles_Master__c>   detmastO= [SELECT Id, Name, Master__c, Estado_Aduana__c, Estado_Guia__c FROM Detalles_Master__c where Master__c =:sinId and Name in:listao];

        
        if(detmastD.size()>0){
            for(Detalles_Master__c det: detmastD){
                det.Estado_Aduana__c='D-DECLARACION';
                det.Estado_Guia__c='Documental';
                detmast.add(det);
                contador++;
            }
        }
        if(detmastLL.size()>0){
            for(Detalles_Master__c det: detmastLL){
               det.Estado_Aduana__c='LIBRE-LIBRE';  
                 detmast.add(det);
                contador++;
        }
        }
        if(detmastO.size()>0){
            for(Detalles_Master__c det: detmastO){
                for(listado lo: listaotros){
                    if(det.Name == lo.NumDoc){
               det.Estado_Aduana__c=lo.MotivoSelec; 
                 detmast.add(det);
                        contador++;
                    }
                }
            }
        }      
          
        system.debug('se actualizaron  '+contador+'registros');
        if(contador>0){
        update detmast;
             }
        
        
        
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Adjunte algún archivo');
            ApexPages.addMessage(myMsg);
            
    
         
        return 'Archibo cargado correctamente se actualizaron  '+contador+' registros'; 
    }
    

    
    public PageReference  volver(){
        PageReference pageRef = new PageReference('/'+idmaster);
        return pageRef;
    }
       
       public  class listado {
        public  String NumDoc {get;set;}
        public  String MotivoSelec{get;set;}
       
        
    }    
   
}