public class HE_Mis_Documentos {
    public string idp {get;set;}
    public string idc {get;set;}
    public string resultJSON {get;set;} 
    public string resultJSON2 {get;set;} 
    public list<Guias_de_Exportacion__c> guiexp {get;set;}
    public list<Solicitud_de_Retiro__c> solret {get;set;}
    Map<string, Attachment> attachments {get;set;}
    
    public PageReference datos(){
        system.debug('datos');
        system.debug('idp '+ ApexPages.currentPage().getParameters().get('idp'));
        system.debug('idc '+ ApexPages.currentPage().getParameters().get('idc'));
        idp=ApexPages.currentPage().getParameters().get('idp');
        idc=ApexPages.currentPage().getParameters().get('idc');
        
        
        listguia();
        
        return null; 
    }
    
    public pagereference listguia(){
        guiexp=[SELECT Id, Name,N_de_Guia__c,ID_Remitente__r.name,Direccion_Destinatario__r.name,Pais__c,calle__c,CreatedDate,
                Estado_Guia__c,Agente__c,Compania_Destinatario__c,Proposito_del_Envio__c
                FROM Guias_de_Exportacion__c  where ID_Remitente__c=:idp order by Name DESC ];

        //RCG: Se agrega filtro para traer Solicitud_de_Retiro__c de hasta 2 años atrás - 23/05/2025 Ticket Seidor N°00023071
        Date haceDosAnios = Date.today().addYears(-2);
        
        solret=[SELECT Id, Name, Direcciones__c, Cuenta__c, Hora_Desde__c, Hora_Hasta__c, Fecha_de_Retiro__c, Contacto_para_Retiro__c,
                Indicaciones_Especiales__c, Etapa__c, Estado_Solicitud__c, Rango_Horario__c, Cantidad_Paquetes__c, Peso_Aproximado__c,
                Tipo_de_Paquete__c,Direcciones__r.name
                FROM Solicitud_de_Retiro__c where Cuenta__c=:idc AND CreatedDate >=: haceDosAnios];
        
        system.debug('solret'+solret);
        return null;
    }
    
    
    public void consultarguias(){
        //usuario del site y metadata
        User user = [select id from user where name = 'cliente Usuario invitado al sitio Web' limit 1];
        Endpoint__mdt endpoint = [select url__c from EndPoint__mdt where label = 'Url descarga archivos' limit 1];
        
        String nguia = ApexPages.currentPage().getParameters().get('guia');
        String fecha_inicio = ApexPages.currentPage().getParameters().get('fi');
        String fecha_fin = ApexPages.currentPage().getParameters().get('fn');
        String idc = ApexPages.currentPage().getParameters().get('idc');
        
        string fi;
        string fn;
        
        
        if(fecha_inicio!='' && fecha_inicio!=null){
            fi = fecha_inicio+'T00:00:00.000+0000';
        }
        if(fecha_fin!='' && fecha_fin!=null){
            fn =fecha_fin+'T23:59:59.000+0000';
        }
        string consulta='';
        if((nguia!='' && nguia!=null) || 
           (fecha_fin!='' && fecha_fin!=null && fecha_fin!='' && fecha_fin!=null )){
               if((nguia!='' && nguia!=null)){
                   consulta+=' AND Name=\''+nguia+'\'';
               }
               if((fecha_fin!='' && fecha_fin!=null && fecha_fin!='' && fecha_fin!=null )){
                   consulta+=' AND (CreatedDate>='+fi+' AND CreatedDate<='+fn+' )';    
               }
           }
        
        system.debug('guia'+nguia);
        system.debug('fecha_inicio'+fecha_inicio);
        system.debug('fecha_fin'+fecha_fin);
        system.debug('idp'+idp);
        system.debug('idc'+idc);
        system.debug('consulta'+consulta);

        string  query='SELECT Id, Name,N_de_Guia__c,CreatedDate,Agente__c,ID_Remitente__r.name,ID_Remitente__r.ShippingAddress,'+
            ' Direccion_Destinatario__r.name,Pais__c,Proposito_del_Envio__c,ID_Remitente__c,'+
            ' Estado__c,Estado_Guia__c,Fecha_Ultimo_Estado__c,Fecha_de_Envio__c,Calle__c, ID_Remitente__r.ShippingStreet,'+
            ' ID_Remitente__r.ShippingCity, ID_Remitente__r.ShippingState, ID_Remitente__r.ShippingCountry, Centro_de_Costo__c '+
            ' FROM Guias_de_Exportacion__c '+
            ' where ID_Remitente__c=\''+idc+'\' '+consulta+
            ' order by CreatedDate DESC';
        
        system.debug('query='+query);
        List<Guias_de_Exportacion__c> guiexp = Database.query(query);                
        
        //-----carga lista de guias
        Set<Guias_de_Exportacion__c> guideList = new Set<Guias_de_Exportacion__c>(guiexp);														
        /*for (Guias_de_Exportacion__c  guide : guiexp) {
            guideList.add(guide.Id);             
        }*/
        //listado de adjuntos de lista de guias segun id
        attachments = new Map<string, Attachment>([SELECT parentId FROM Attachment WHERE parentId IN : guideList AND createdbyId =: user.Id]);
        
        system.debug('guideList size='+guideList.size());
        system.debug('attachments size='+attachments.size());
        system.debug('guiexp='+guiexp.size());
        //-----carga lista de guias
        
        Attachment attachment;
        string det_guiexp='[';
        for(integer i=0;i<guiexp.size();i++){
                        
            if(i!=0){
                det_guiexp+=','; 
            } 
            string dir;
            if(guiexp[i].Direccion_Destinatario__r.name!=null){
                
                dir=guiexp[i].Direccion_Destinatario__r.name.replace('"','').replace('	','');
                system.debug('dir');
            }                  
            
            //leer adjuntos y comparar la guia, si coincice
            for (String attachmentId : attachments.keySet()){
                attachment = attachments.get(attachmentId);
                if(attachment.ParentId == guiexp[i].id){
                    break;
                }
                attachment = null;
            }
                        
            system.debug('attachment size='+attachment);
            system.debug('guiexp[i].id='+guiexp[i].id);
            
            det_guiexp+='{';            
            det_guiexp+='"Estado_Guia__c":"'+guiexp[i].Estado_Guia__c+'",';
            det_guiexp+='"Name":"'+guiexp[i].Name+'",';
            det_guiexp+='"N_de_Guia__c":"'+guiexp[i].N_de_Guia__c+'",';
            det_guiexp+='"Agente__c":"'+guiexp[i].Agente__c+'",';
            det_guiexp+='"CreatedDate":"'+guiexp[i].CreatedDate+'",'; 
            det_guiexp+='"Direccion_Destinatario__name":"'+dir+'",';
            det_guiexp+='"Pais__c":"'+guiexp[i].Pais__c+'",';            
            det_guiexp+='"Proposito_del_Envio__c":"'+guiexp[i].Proposito_del_Envio__c+'",';
            det_guiexp+='"Centro_de_Costo__c":"'+guiexp[i].Centro_de_Costo__c+'",';
            det_guiexp+='"id":"' + guiexp[i].id + '",';    
            if(attachment != null){
                det_guiexp+='"attachmentId":"'+ attachment.Id +'",';
                det_guiexp+='"attachmentUrl":"'+ endpoint.url__c.replace('{ID}', attachment.Id) +'"';
            }
            else{
                det_guiexp+='"attachmentId":"",';
                det_guiexp+='"attachmentUrl":""';
            }
            det_guiexp+='}';
        }
        det_guiexp+=']';
        det_guiexp=det_guiexp.replace('null', '');
        system.debug('det_guiexp='+det_guiexp);
        resultJSON='{"success":true, "guias":'+det_guiexp+'}';   
        resultJSON = resultJSON.replace('\r\n',' ').replace('\n',' ').replace('\r',' ').replace('\r\n',' ').replace('\n\r',' ').replace('\t',' ');
    }    
    
    /*public string getAttachment(string parentId, string userId){        
        List<Attachment> attachments = new List<Attachment>();
        attachments = [select id from Attachment where parentId =: parentId and createdbyId =: userId];
        if(attachments.size() > 0){
            return attachments[0].id;
        }
        else{
            return '';
        }
    }*/
}