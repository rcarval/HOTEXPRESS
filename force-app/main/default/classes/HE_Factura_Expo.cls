public class HE_Factura_Expo {
    
    
    public list<Contenido_Envio__c> contenv {get;set;}
    public list<datos> listcontenv {get;set;}
    public string  Name_or   {get;set;}
    public string  TaxID_or  {get;set;}
    public string  ContactName_or   {get;set;}
    public string  Telephone_or  {get;set;}
    public string  E_Mail_or   {get;set;}
    public string  Company_or   {get;set;}
    public string  Country_or   {get;set;}
    public string  Proposito   {get;set;}
    public string  Fecha_Envio   {get;set;}
    public string Breve_Descripcion   {get;set;}
    public string Documento   {get;set;}
    
    public string  Name_des   {get;set;}
    public string  TaxID_des  {get;set;}
    public string  ContactName_des   {get;set;}
    public string  Telephone_des  {get;set;}
    public string  E_Mail_des   {get;set;}
    public string  Company_des   {get;set;}
    public string  Country_des   {get;set;}
    
    
    public decimal  total_packages  {get;set;}
    public decimal  total_unidades   {get;set;}
    public decimal  peso_total  {get;set;}
    public decimal  subtotal   {get;set;}
    public decimal  invoice_total   {get;set;}
    public string  tipo_moneda   {get;set;}
    public string  instruccion_especial   {get;set;}
    
    public string  idp   {get;set;}
    
    
    
    public HE_Factura_Expo(ApexPages.StandardController controller){
        // idp=ApexPages.currentPage().getParameters().get('id');
        idp=controller.getId();
    }
    
    public PageReference  cargar(){
        //  idp='a090v0000043gK4AAI';
        Guias_de_Exportacion__c  gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                      Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,
                                      Peso_Agente__c,Contacto__r.name,Contacto__r.email,Telefono__c,Calle__c,Ciudad__c,Pais__c,DDP__c,Otro_Remitente__c,
                                      Shipper_Original__c,ID_Remitente__r.BillingStreet,ID_Remitente__r.BillingCity,ID_Remitente__r.name,ID_Remitente__r.BillingCountry,
                                      Direccion_Destinatario__r.Name ,Proposito_del_Envio__c, Envio_Particular_a_Particular__c, Breve_Descripcion__c, Breve_Descripcion_2__c, Breve_Descripcion_3__c, Breve_Descripcion_4__c,FrxTaxID__c
                                      from Guias_de_Exportacion__c where id=:idp];
        
        Contacto_HotExpress__mdt contacto_hotexpress = [SELECT Name__c, Email__c, Phone__c FROM Contacto_HotExpress__mdt WHERE MasterLabel =: 'ContactoPrincipal' LIMIT 1];
        
        contenv=[SELECT Id, Pickup__c, Descripcion__c, Pais_fab__c,Pais_fab__r.name, Cantidad__c, Unidad_de_Medida__c, Valor_Unitario__c, Condicion_de_Venta__c, Comentarios__c,Codigo_Arancelario__c
                 FROM Contenido_Envio__c WHERE Pickup__c =: gde.id];
        Direcciones__c dir_org;
        if(gde.Otro_Remitente__c!=null){
            dir_org=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                     LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                     Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Otro_Remitente__c];
        } 
        
        Direcciones__c dir=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Destinatario__c];
        Account acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
                     OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c 
                     FROM Account 
                     WHERE Nombre_Fantasia__c =: 'Hot Express'];
        list<Contact> cont=[SELECT Id, AccountId, Name, MailingAddress, Email,Phone, MobilePhone, OwnerId, Tipo_Cargo__c, Aprobador_Final__c 
                            FROM Contact where AccountId=:acc.id];
        
        if(gde.Shipper_Original__c==true){
            system.debug('1');
            Name_or=gde.ID_Remitente__r.Name;
            TaxID_or =' '+gde.ID_Remitente__c;
            ContactName_or =' '+gde.Contacto__r.name;
            Telephone_or  =' '+gde.Telefono__c;
            E_Mail_or  =' '+gde.Contacto__r.email;
            Company_or   =' '+gde.ID_Remitente__r.BillingStreet;
            Country_or  =' '+gde.ID_Remitente__r.BillingCountry; //acc.BillingCountry; //gde.ID_Remitente__r.BillingCity;
            if(gde.Otro_Remitente__c!=null){
                system.debug('2');
                Name_or=gde.ID_Remitente__r.Name;
                TaxID_or =' '+dir_org.id;
                ContactName_or =' '+gde.Contacto__r.name;
                Telephone_or  =' '+gde.Telefono__c;
                E_Mail_or  =' '+gde.Contacto__r.email;
                Company_or   =' '+dir_org.Direccion__c+', '+dir_org.Ciudad__c+',  '+dir_org.Estado_Provincia__c+' '+dir_org.Codigo_Postal__c ;
                Country_or  =' '+dir_org.Pais__r.name;
                
            }
            else{
                Name_or = (gde.Envio_Particular_a_Particular__c == true ? gde.Contacto__r.name : gde.ID_Remitente__r.Name);
            }
        }else{
            
            system.debug('3');
            Name_or = (gde.Envio_Particular_a_Particular__c == true ? contacto_hotexpress.Name__c : acc.Name);
            TaxID_or ='';
            ContactName_or =' ' + contacto_hotexpress.Name__c;
            Telephone_or  =' ' + contacto_hotexpress.Phone__c;
            E_Mail_or  =' ' + contacto_hotexpress.Email__c;
            Company_or   =' ' + acc.BillingStreet+', '+acc.BillingCity;
            Country_or  =' ' + acc.BillingCountry;
            
            
            
        }
        
        if(gde.Proposito_del_Envio__c=='Muestra sin valor Comercial'){
            Proposito=' Samples without commercial value, not for resale value only for customs purposes';
        }else if(gde.Proposito_del_Envio__c=='Regalo'){
            Proposito=' Unsolicited Gift';
        }else if(gde.Proposito_del_Envio__c=='Regalo a China'){
            Proposito=' Personal Gift';
        }else {
            Proposito=gde.Proposito_del_Envio__c;
        }
        Name_des= (gde.Envio_Particular_a_Particular__c == true ? gde.Contacto_Destinatario__c : gde.Direccion_Destinatario__r.Name);
        TaxID_des = gde.FrxTaxID__c;
        ContactName_des  = gde.Contacto_Destinatario__c;
        Telephone_des =gde.Telefono_Destinatario__c;
        E_Mail_des   =gde.Correo_Electronico__c ;
        Company_des  =dir.Direccion__c+', '+dir.Ciudad__c+', '+dir.Estado_Provincia__c+' '+dir.Codigo_Postal__c ;
        Company_des=Company_des.replace('null', ' ');
        Country_des   =dir.Pais__r.name;
        Fecha_Envio = string.valueOf(gde.Fecha_de_Envio__c);
        Breve_Descripcion = 
                  (gde.Breve_Descripcion__c != null ? gde.Breve_Descripcion__c : '') + ' ' 
                + (gde.Breve_Descripcion_2__c != null ? gde.Breve_Descripcion_2__c + ' ' : '') 
                + (gde.Breve_Descripcion_3__c != null ? gde.Breve_Descripcion_3__c + ' ' : '')
                + (gde.Breve_Descripcion_4__c != null ? gde.Breve_Descripcion_4__c + ' ' : '');
        listcontenv=new list<datos>();
        total_unidades=0;
        subtotal=0;
        for(Contenido_Envio__c ct :contenv){
            datos d=new datos(); 
            d.Packages=1 ;
            d.cantidad=ct.Cantidad__c;
            d.medida='KG';
            d.un_medida=ct.Unidad_de_Medida__c;
            d.descripcion=ct.Descripcion__c;
            d.tarifa = 0;
            d.cod_arancelario = ct.Codigo_Arancelario__c;
            d.pais=ct.Pais_fab__r.name;
            d.valor_unidad=ct.Valor_Unitario__c;
            d.total=ct.Cantidad__c * ct.Valor_Unitario__c;   
            listcontenv.add(d); 
            total_unidades=total_unidades+ct.Cantidad__c;
            subtotal=subtotal+d.total;
        }
        total_packages=gde.Paquetes__c;
        
        peso_total =gde.Peso_Agente__c; 
        
        invoice_total=subtotal;
        tipo_moneda =gde.Divisa__c;         
        
        instruccion_especial = gde.DDP__c ? 'INCOTERM DDP' : '';
        Documento = gde.Name;
        
        return null;
    }
    
    public class datos{
        public integer  Packages  {get;set;}
        public decimal  cantidad   {get;set;}
        public string  medida  {get;set;}
        public string  un_medida   {get;set;}
        public string  descripcion   {get;set;}
        public decimal  tarifa   {get;set;}
        public string  cod_arancelario   {get;set;}
        public string  pais  {get;set;}
        public decimal  valor_unidad    {get;set;}
        public decimal  total  {get;set;} 
    }
}