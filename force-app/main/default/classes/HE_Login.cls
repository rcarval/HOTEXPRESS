public class HE_Login {
    public string Email                    {get;set;}
    public string Contrasena               {get;set;}
    public list<Contact> cont              {get;set;}
    public list<Account> listAcc           {get;set;}
    public list<Contact> cuentasdecont    {get;set;}
    public string idc                     {get;set;}
    public string idp                     {get;set;}
    public string resultMessage              {get;set;}
    public string JSONrespuentacuentas    {get;set;} 
    public string resultJSON   {get;set;}
    
    public HE_Login(){
        resultMessage = '';
    }
    public PageReference validar() {      
        
        if(Email == '' || Contrasena == ''){
            resultMessage = 'Ingrese Todos los Campos';
        }else{
            cont = [SELECT Id, Email, contrase_a__c, Contacto_Inactivo__c, AccountId FROM Contact where Email =: Email]; 
            
            if(cont.size() > 0){
                for (Contact cc:cont){
                    if(cc.Contacto_Inactivo__c == true){
                        resultMessage = 'Usuario inactivo'; 
                    }
                    else{
                        if(cc.contrase_a__c == Contrasena){
                            PageReference reference = new PageReference('/apex/HE_Inicio?idp='+cc.id+'&&idc='+cc.AccountId);
                            reference.setRedirect(true);
                            return reference;
                        }    
                        else{
                            resultMessage = 'Contraseña incorrecta';  
                        }
                    }                 
                }                
            }
            else{
                resultMessage = 'Usuario no registrado';                
            }           
        }    
        return null;  
    }
    
    public PageReference nuevo_envio(){
        
        capturaid();
        
        PageReference reference=new PageReference('/apex/HE_Nuevo_Envio?idp='+idp+'&&idc='+idc);
        reference.setRedirect(true);
        system.debug('pgref '+reference);
        return reference;
    }
    public PageReference  solicitud_retiro(){
        PageReference reference=new PageReference('/apex/HE_solicitud_de_Retiro?idp='+idp+'&&idc='+idc);
        reference.setRedirect(true);
        system.debug('pgref '+reference);
        return reference;  
    }
    public PageReference caja(){
        PageReference reference=new PageReference('/apex/HE_Mis_Documentos?idp='+idp+'&&idc='+idc);
        reference.setRedirect(true);
        system.debug('pgref '+reference);
        return reference;  
        
    }
    public PageReference consuta_estado(){
        PageReference reference=new PageReference('/apex/HE_guia_hot?');
        reference.setRedirect(true);
        system.debug('pgref '+reference);
        return reference;  
    }
    public void consultarguia(){
        String datos = ApexPages.currentPage().getParameters().get('datos');
        system.debug('datos'+datos);
        list<Guias_de_Exportacion__c> guiexp=[SELECT Id, Name,N_de_Guia__c,ID_Remitente__r.name,ID_Remitente__r.ShippingAddress,Direccion_Destinatario__r.name,Pais__c,
                                              Estado__c,Estado_Guia__c,Fecha_Ultimo_Estado__c,Fecha_de_Envio__c,Calle__c, ID_Remitente__r.ShippingStreet,
                                              ID_Remitente__r.ShippingCity, ID_Remitente__r.ShippingState, ID_Remitente__r.ShippingCountry
                                              FROM Guias_de_Exportacion__c 
                                              where Name=:datos];
        system.debug('guiexp='+guiexp);
        
        
        list<Tracking_G_Exportacion__c> hist_exp=new list<Tracking_G_Exportacion__c>();
        
        
        hist_exp=[SELECT Id, Guias_de_Exportacion__c, Detalle_Tracking__c, Ultimo_Estado__c, Codigo_Tracking__c, Fecha__c 
                  FROM Tracking_G_Exportacion__c 
                  where Guias_de_Exportacion__c=:guiexp[0].id 
                  order by Fecha__c];
        
        system.debug('hist_exp='+hist_exp);
        string det_hist='[';
        for(integer i=0;i<hist_exp.size();i++){
            if(i!=0){
                det_hist+=','; 
            }  
            det_hist+='{';
            det_hist+='"Codigo_Tracking":"'+hist_exp[i].Codigo_Tracking__c+'",';
            det_hist+='"Estado":"'+hist_exp[i].Ultimo_Estado__c+'",';
            det_hist+='"Fecha":"'+hist_exp[i].Fecha__c+'",';
            det_hist+='"Detalle":"'+hist_exp[i].Detalle_Tracking__c+'"'; 
            det_hist+='}';
        }
        det_hist+=']';
        det_hist=det_hist.replace('null', '');
        if(guiexp.size()>0){
            string fecha=guiexp.get(0).Fecha_Ultimo_Estado__c==null?'':string.valueOf(guiexp.get(0).Fecha_Ultimo_Estado__c);
            if(fecha==null ){
                fecha='';
            }
            string origen,PaisO;
            if(guiexp.get(0).ID_Remitente__r.ShippingStreet==null ){
                origen='';
            }
            if(guiexp.get(0).ID_Remitente__r.ShippingCountry==null ){
                PaisO='';
            }
            
            resultJSON='{"success":true,"Id_guia":"'+guiexp[0].Id+'", "Estado":"'+guiexp.get(0).Estado__c+'", "Fecha":"'+fecha+
                '","Origen":"'+origen+'","Destino":"'+guiexp.get(0).Calle__c+
                '","PaisO":"'+PaisO+'","PaisD":"'+guiexp.get(0).Pais__c+
                '","historial":'+det_hist+'}'; 
            
        }else{
            resultJSON='{"success":false, "msg":"guia no encontrada"}';   
        }
        
    }
    
    public PageReference capturaid(){
        string   host= ApexPages.currentPage().getHeaders().get('Host');
        string    referer=ApexPages.currentPage().getHeaders().get('Referer');
        string   useragent=ApexPages.currentPage().getHeaders().get('User-Agent');
        string   chipersuite=ApexPages.currentPage().getHeaders().get('Chipersuite');
        string   forward=ApexPages.currentPage().getHeaders().get('X-Salesforce-Forwarded-To');
        string   salesforceip= ApexPages.currentPage().getHeaders().get('X-Salesforce-SIP');
        
        idp=ApexPages.currentPage().getParameters().get('idp');
        idc=ApexPages.currentPage().getParameters().get('idc');
        cuentasdecont =new  list<Contact>();
        string email=[SELECT Id, Email,contrase_a__c,AccountId  FROM Contact where id=:idp].Email;
        cont=[SELECT Id, Email,contrase_a__c,AccountId,Account.name  FROM Contact where Email=:email order by AccountId ]; 
        if(cont.size()>0){
            JSONrespuentacuentas='[';
            string cuenta='';
            for(Contact c:cont){
                system.debug('cuenta'+cuenta);
                system.debug('c.AccountId'+c.AccountId);
                if(cuenta!=string.valueof(c.AccountId)){
                    if(JSONrespuentacuentas!='['){
                        JSONrespuentacuentas+=',';   
                    }
                    JSONrespuentacuentas+='{';
                    JSONrespuentacuentas+='"IDcontacto":"'+c.id+'",';
                    JSONrespuentacuentas+='"IDcuenta":"'+c.AccountId+'",';
                    JSONrespuentacuentas+='"Email":"'+c.Email+'",';
                    JSONrespuentacuentas+='"nombrecuenta":"'+c.Account.name+'"';
                    JSONrespuentacuentas+=' }'; 
                    cuentasdecont.add(c)  ;  
                }else{
                    system.debug(' se repite cuenta '+c.AccountId);   
                }
                cuenta=c.AccountId;
                
            }
            
            JSONrespuentacuentas+=']'; 
        }
        system.debug('host'+host);
        system.debug('referer'+referer);
        system.debug('useragent'+useragent);
        
        system.debug('chipersuite'+chipersuite);
        system.debug('forward'+forward);
        system.debug('salesforceip'+salesforceip);  
        system.debug('idp'+idp);
        system.debug('idc'+idc);
        return null;  
    }
}