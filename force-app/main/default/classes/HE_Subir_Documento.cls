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
        try {
            system.debug('sinId'+sinId);
            
            system.debug('attachmentBody'+attachmentBody);
            system.debug('attachmentName'+attachmentName);
            
            // Validar que el archivo no esté vacío
            if(String.isBlank(xmls)) {
                return 'Error: El archivo está vacío. Por favor seleccione un archivo válido.';
            }
            
            Blob b = EncodingUtil.base64Decode(attachmentBody);

            HE_Subir_Documento.listado items=new HE_Subir_Documento.listado();
            
            DOM.Document doc = new DOM.Document();
            
            // Intentar cargar el XML
            doc.load(xmls);    
            DOM.XMLNode root = doc.getRootElement();
            
            // Validar que el nodo raíz sea 'Rows'
            if(root == null || root.getName() != 'Rows') {
                return 'Error: El archivo no tiene la estructura XML esperada. Debe contener un elemento raíz <Rows>.';
            }
            
            lista=new list<listado>();
            listall=new list<string>();
            listad=new list<string>();
            listao=new list<string>();
            listaotros=new list<listado>();
            
            // Procesar cada fila del XML
            for ( Dom.XMLNode tc : root.getChildElements() ) {  
                items=new HE_Subir_Documento.listado();
                
                // Extraer NumeroDoc
                Dom.XMLNode numeroDocNode = tc.getChildElement('NumeroDoc', null);
                if(numeroDocNode != null) {
                    items.NumDoc = numeroDocNode.getText().trim();
                }
                
                // Extraer MotivoSeleccion manejando el <div> interno
                Dom.XMLNode motivoNode = tc.getChildElement('MotivoSeleccion', null);
                if(motivoNode != null) {
                    String motivoText = extractTextFromNode(motivoNode);
                    items.MotivoSelec = motivoText.trim();
                }
                
                // Solo agregar si tiene datos válidos
                if(String.isNotBlank(items.NumDoc) && String.isNotBlank(items.MotivoSelec)) {
                    lista.add(items);
                }
            }  
            
            // Validar que se hayan encontrado registros
            if(lista.isEmpty()) {
                return 'Error: No se encontraron registros válidos en el archivo. Verifique que el archivo contenga elementos <Row> con <NumeroDoc> y <MotivoSeleccion>.';
            }
            
            list<Detalles_Master__c>   detmast= new  list<Detalles_Master__c>();
            system.debug('tamaño '+lista.size());
            system.debug('lista'+lista);
            system.debug('detmast'+detmast);
            integer contador=0;
            
            // Clasificar los registros por tipo de motivo
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
            
            // Consultar los detalles del Master
            list<Detalles_Master__c>   detmastD= [SELECT Id, Name, Master__c, Estado_Aduana__c, Estado_Guia__c FROM Detalles_Master__c where Master__c =:sinId and Name in:listad];
            list<Detalles_Master__c>   detmastLL= [SELECT Id, Name, Master__c, Estado_Aduana__c, Estado_Guia__c FROM Detalles_Master__c where Master__c =:sinId and Name in:listall];
            list<Detalles_Master__c>   detmastO= [SELECT Id, Name, Master__c, Estado_Aduana__c, Estado_Guia__c FROM Detalles_Master__c where Master__c =:sinId and Name in:listao];

            // Actualizar registros con estado D-DECLARACION
            if(detmastD.size()>0){
                for(Detalles_Master__c det: detmastD){
                    det.Estado_Aduana__c='D-DECLARACION';
                    det.Estado_Guia__c='Documental';
                    detmast.add(det);
                    contador++;
                }
            }
            
            // Actualizar registros con estado LIBRE-LIBRE
            if(detmastLL.size()>0){
                for(Detalles_Master__c det: detmastLL){
                    det.Estado_Aduana__c='LIBRE-LIBRE';  
                    detmast.add(det);
                    contador++;
                }
            }
            
            // Actualizar registros con otros estados
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
            
            // Actualizar los registros en la base de datos
            if(contador>0){
                update detmast;
            } else {
                return 'Advertencia: No se encontraron registros coincidentes para actualizar. Verifique que los números de documento existan en el Master.';
            }
            
            return 'Archivo cargado correctamente. Se actualizaron '+contador+' registro(s).'; 
            
        } catch(System.XMLException xmlEx) {
            system.debug('Error XML: ' + xmlEx.getMessage());
            return 'Error al procesar el archivo XML: ' + xmlEx.getMessage() + '. Verifique que el archivo tenga formato XML válido con codificación ISO-8859-1.';
        } catch(DmlException dmlEx) {
            system.debug('Error DML: ' + dmlEx.getMessage());
            return 'Error al actualizar los registros: ' + dmlEx.getMessage();
        } catch(Exception ex) {
            system.debug('Error general: ' + ex.getMessage());
            system.debug('Stack trace: ' + ex.getStackTraceString());
            return 'Error inesperado al procesar el archivo: ' + ex.getMessage() + '. Por favor contacte al administrador.';
        }
    }
    

    
    public PageReference  volver(){
        PageReference pageRef = new PageReference('/'+idmaster);
        return pageRef;
    }
    
    private static String extractTextFromNode(Dom.XMLNode node) {
        String result = '';
        
        // Si el nodo tiene hijos, buscar recursivamente
        if(node.getChildElements() != null && node.getChildElements().size() > 0) {
            for(Dom.XMLNode child : node.getChildElements()) {
                result += extractTextFromNode(child);
            }
        } else {
            // Si no tiene hijos, obtener el texto directo
            result = node.getText();
        }
        
        return result != null ? result : '';
    }
       
       public  class listado {
        public  String NumDoc {get;set;}
        public  String MotivoSelec{get;set;}
       
        
    }    
   
}