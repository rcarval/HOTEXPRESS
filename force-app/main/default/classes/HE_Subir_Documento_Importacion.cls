public class HE_Subir_Documento_Importacion {
  public static String idmaster{get; set;}
    public blob archivo{get; set;}
    public integer largo{get; set;}
     public static String NumeroDoc{get; set;}
    
    public Attachment objCaseAtt {get; set;}
      public static list<listado> lista{get; set;}
 
    public HE_Subir_Documento_Importacion(ApexPages.StandardController controller) {
        idmaster=controller.getId();
    }
    
      @RemoteAction
    public static String   estado(String sinId, string attachmentBody, String attachmentName, String attachmentId,string xmls){
         system.debug('sinId'+sinId);
        
        system.debug('attachmentBody'+attachmentBody);
        system.debug('attachmentName'+attachmentName);
          Blob b = EncodingUtil.base64Decode(attachmentBody);


      System.debug('xmls'+xmls);
          DOM.Document doc = new DOM.Document();
            
                        doc.load(xmls);    
                        DOM.XMLNode root = doc.getRootElement();
        lista=new list<listado>();
          parseXML(root);
       list<Detalles_Guias_Importacion__c>   detmast= [SELECT Id, Name, Master_Importacion__c, Estado_Aduana__c,Estado_Guia__c FROM Detalles_Guias_Importacion__c where Master_Importacion__c =:sinId];
          system.debug('tamaño '+lista.size());
         system.debug('lista'+lista);
        system.debug('detmast'+detmast);
        integer contador=0;
        for(integer i=0;i < detmast.size();i++){
        for(integer j=0;j < lista.size();j++){
            if(detmast.get(i).Name == lista.get(j).NumDoc){
               detmast.get(i).Estado_Aduana__c=lista.get(j).MotivoSelec;
                if(lista.get(j).MotivoSelec=='D-DECLARACION'){
                    detmast.get(i).Estado_Guia__c='Documental';
                }
                contador++;
            }
        }    
        }
        system.debug('se actualizaron  '+contador+'registros');
        update detmast;
        
        
        
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Adjunte algún archivo');
            ApexPages.addMessage(myMsg);
            
    
        
        return 'Archibo cargado correctamente'; 
    }
    

    
    public PageReference  volver(){
        PageReference pageRef = new PageReference('/'+idmaster);
        return pageRef;
    }
    public static void parseXML(DOM.XMLNode node) {
        
      
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
         
            if(node.getName()=='NumeroDoc' ){
                NumeroDoc = node.getText().trim();
               guardar(NumeroDoc,null);
            }
            if(node.getName()=='MotivoSeleccion' ){
               string MotivoSeleccion = node.getText().trim();
              guardar(NumeroDoc,MotivoSeleccion);
            }
            for (Dom.XMLNode child: node.getChildElements()) {
                
                    parseXML(child);
                
                
            }
        }
    }

    
       public  class listado {
        public  String NumDoc {get;set;}
        public  String MotivoSelec{get;set;}
       
        
    }    
     public static String guardar(string NumDoc,string MotivoSelec ) {
           //  system.debug('lista.get(r).fecha');
        if(lista.size()>0){
            integer contador=0;
            for(integer r=0;r<lista.size();r++){
                // system.debug('lista.get(r).fecha'+lista.get(r).fecha);
                if(lista.get(r).NumDoc==NumDoc && lista.get(r).MotivoSelec==null){
                    lista.get(r).MotivoSelec=MotivoSelec;
                    contador++;
                    
                }
            }
            if(contador==0){
                listado  l=new listado();
                l.NumDoc=NumDoc;
                l.MotivoSelec=MotivoSelec;
                lista.add(l);   
            }
            
        }else{
            listado  l=new listado();
            l.NumDoc=NumDoc;
            l.MotivoSelec=MotivoSelec;
         
            lista.add(l);  
        }
       
        return null;
    }
}