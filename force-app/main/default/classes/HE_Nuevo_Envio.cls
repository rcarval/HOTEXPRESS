public class HE_Nuevo_Envio {
    public Account acc {get;set;}
    public Contact cont {get;set;}
    public string idp {get;set;}
    public string idc {get;set;}
    public string resultJSON {get;set;}
    public string resultJSONOrigen {get;set;}
    public string lcontactosJSON {get;set;}
    public string localAddressesJSON {get;set;}
    
    public List<Pais__c> listpais{get;set;}
    public List<String> contentTypes{get;set;}
    public list<Contact> listacontactos{get;set;}
    public list<direciones> direcionesOrigen{get;set;}
    public list<direciones> direcionesDestino{get;set;}   
    public list<direciones> localAddresses { get; set;} 
    
    public PageReference datos(){
        idp=ApexPages.currentPage().getParameters().get('idp');
        idc=ApexPages.currentPage().getParameters().get('idc');
        system.debug('idp'+idp);
        system.debug('idc'+idc); 
        acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingAddress, ShippingAddress, 
             Phone, OwnerId, RUT__c, Haber__c, Debe__c, Saldo__c, Condici_n_Courier_Exportaci_n__c, Condicion_Comercial_Global__c
             FROM Account WHERE Id =:idc];
        if(acc.BillingStreet!=null){
            acc.BillingStreet=acc.BillingStreet.replace('\r\n',' ').replace('\n',' ').replace('\r',' ').replace('\r\n',' ').replace('\n\r',' ');
        }
        system.debug('acc.BillingStreet'+acc.BillingStreet);
        cont=[SELECT Id, Email,AccountId, MailingStreet ,MobilePhone,Name FROM Contact WHERE id=:idp ]; 
        system.debug('carga contactos'); 
        listdir(); 
        system.debug('carga lista 1'); 
        system.debug('carga lista 2'); 
        listacontactos=listCon();
        lcontactosJSON=JSON.serialize(listacontactos);
        system.debug('serializa json');
        
        listpais=[SELECT Id, Name,  Cod_Pais__c FROM Pais__c order by Name];
        contentTypes = GetContentTypes();
        system.debug('lista paises');
                
        localAddresses = GetLocalAddress();
        system.debug('lista direcciones locales:' + localAddresses);
        
        localAddressesJSON = JSON.serialize(localAddresses);
        system.debug('serializa direcciones: ' + localAddressesJSON);
        return null;  
    }
    
    //Obtiene direcciones nacionales 
    public List<direciones> GetLocalAddress(){
        Direcciones__c firstAddress = new Direcciones__c();
        List<direciones> addresses = new List<direciones>();        
         
        for(Direcciones__c address : [SELECT
                      Id,Name, Direccion__c
                      FROM Direcciones__c 
                      WHERE Pais__r.Cod_Pais__c =: 'CL'
                      AND Cuenta__c=:idc order by Name LIMIT 1000])
         {
             HE_Nuevo_Envio.direciones newAddress = new HE_Nuevo_Envio.direciones();
             newAddress.id = address.Id;
             newAddress.nombre = address.Name;
             newAddress.Direccion = address.Direccion__c;
             addresses.add(newAddress);
         }  
        
       return  addresses;
    }
    
    public pagereference listdir(){
        list<Direcciones__c> dir=[SELECT Id, Name, Cuenta__c, Direccion__c, Ciudad__c,Pais__r.name, Estado_Provincia__c, Codigo_Postal__c, Tipo__c, Cod_Pais__c, Nombre_Zona__c,
                                  contacto__c,email__c,telefono__c, Tax_ID__c
                                  FROM Direcciones__c where Cuenta__c=:idc and Cod_Pais__c != '' order by Name ];
        
        list<HE_Nuevo_Envio.direciones> direcionesOrigen=new list<HE_Nuevo_Envio.direciones>();
        list<HE_Nuevo_Envio.direciones> direcionesDestino=new list<HE_Nuevo_Envio.direciones>();
        
        /*HE_Nuevo_Envio.direciones di=new HE_Nuevo_Envio.direciones();
        di.id='0';
        di.nombre='Seleccione Dirección';
        direcionesOrigen.add(di);
        direcionesDestino.add(di);*/
        
        for(integer i=0;i<dir.size();i++){
            
            HE_Nuevo_Envio.direciones d=new HE_Nuevo_Envio.direciones();
            d.id=dir.get(i).Id;
            d.nombre=dir.get(i).Name;
            d.Direccion=dir.get(i).Direccion__c==null?'':dir.get(i).Direccion__c;
            d.Ciudad=dir.get(i).Ciudad__c==null?'':dir.get(i).Ciudad__c;
            d.Estado_Provincia=dir.get(i).Estado_Provincia__c==null?'':dir.get(i).Estado_Provincia__c;
            d.codigo_Postal=dir.get(i).Codigo_Postal__c==null?'':dir.get(i).Codigo_Postal__c;
            d.Pais=dir.get(i).Pais__c==null?'':dir.get(i).Pais__r.name;
            
            d.contacto=dir.get(i).contacto__c==null?'':dir.get(i).contacto__c;
            d.email=dir.get(i).email__c==null?'':dir.get(i).email__c;
            d.telefono=dir.get(i).telefono__c==null?'':dir.get(i).telefono__c;
            d.TaxID = dir.get(i).Tax_ID__c == null ? '':dir.get(i).Tax_ID__c;

            direcionesDestino.add(d);
            /*if(dir.get(i).Tipo__c=='Retiro'){
                direcionesOrigen.add(d);   
            }else if(dir.get(i).Tipo__c=='Destinatario'){
                direcionesDestino.add(d); 
            }*/
            
            
        }
        resultJSON = JSON.serialize(direcionesDestino);
        resultJSONOrigen = JSON.serialize(direcionesOrigen);
        return null;
    }
    
    public List<Contact> listCon(){
        list<Contact> listcont=[SELECT Id, Email,AccountId ,Name,MobilePhone, FirstName, LastName, MailingStreet FROM Contact WHERE AccountId=:idc AND Contacto_Inactivo__c = false order by Name  ];
        return listcont;
    }
    
    public void guardadirecion(){ 
        String datos = ApexPages.currentPage().getParameters().get('datos');
        System.debug('datos: '+datos);
        direciones respuesta = (direciones) System.JSON.deserialize(datos, direciones.class);
        system.debug('respuesta'+respuesta);
        try{
            
            for(Direcciones__c dire : [SELECT Id FROM Direcciones__c 
                  WHERE Name =: respuesta.nombre 
                  	and Direccion__c =: respuesta.Direccion
                    and Cuenta__c=:idc])
            {
                resultJSON = '{"success":false, "msg":"Ya existe registro con mismo nombre y dirección"}'; 
                return;
            }  
            
            Direcciones__c  dir =  new Direcciones__c();
            dir.Name=respuesta.nombre;
            dir.Cuenta__c=respuesta.id;
            dir.Direccion__c=respuesta.Direccion;
            dir.Ciudad__c=respuesta.Ciudad;
            dir.Estado_Provincia__c=respuesta.Estado_Provincia;
            dir.Codigo_Postal__c=respuesta.codigo_Postal;
            dir.Pais__c=respuesta.Pais;
            dir.Tipo__c='Destinatario';
            dir.OwnerId=respuesta.OwnerId;
            dir.contacto__c=respuesta.contacto;
            dir.email__c =respuesta.email;
            dir.telefono__c=respuesta.telefono;
            dir.Tax_ID__c = respuesta.TaxID;
            insert dir;
            
            resultJSON='{"success":true,"msg":"Direccion agregada correctamente", "iddirecion":"'+dir.id+'" }';   
        }catch(Exception e){
            
            resultJSON='{"success":false, "msg":"'+e+'"}'; 
        }
        
    }
    
    public void guardadrcontacto(){ 
        String datos = ApexPages.currentPage().getParameters().get('datos');
        System.debug('datos: '+datos);
        contacto respuesta = (contacto) System.JSON.deserialize(datos, contacto.class);
        system.debug('respuesta'+respuesta);
        try{

            for(Contact contact : [SELECT Id FROM Contact 
                  WHERE AccountId =: respuesta.Idcuenta 
                  	and FirstName =: respuesta.Nombre 
                  	and LastName =: respuesta.Apellidos])
            {
                resultJSON = '{"success":false, "msg":"Ya existe contacto con el mismo nombre y apellido"}'; 
                return;
            }           
            
            Contact cn = new Contact();
            cn.Email = respuesta.Correo;
            cn.AccountId = respuesta.Idcuenta;
            cn.Tipo_Cargo__c = respuesta.Tipo_Cargo;
            cn.LastName = respuesta.Apellidos;
            cn.FirstName = respuesta.Nombre;
            cn.MobilePhone = respuesta.Telefono;
            cn.MailingStreet = respuesta.Direccion;
            cn.MailingState = respuesta.Comuna;
            cn.MailingCity = respuesta.Ciudad;
            cn.MailingCountry = respuesta.Pais;            
            insert cn;
            resultJSON = '{"success":true, "idcontacto":"'+cn.id+'", "msg": "Contacto ingresado correctamente"  }';               
        }catch(Exception e){
            
            resultJSON='{"success":false, "msg":"'+e+'"}'; 
        }
        
    }
    
    public void guardaGuia(){ 
        String datos = ApexPages.currentPage().getParameters().get('datos');
        System.debug('datos: '+datos);
        guardadoJSON respuesta = (guardadoJSON) System.JSON.deserialize(datos, guardadoJSON.class);
        system.debug('respuesta'+respuesta);
        list<Direcciones__c> dir=[SELECT Id, Name, Cuenta__c, Direccion__c, Ciudad__c,Pais__r.name, Estado_Provincia__c, Codigo_Postal__c, Tipo__c, Cod_Pais__c, Nombre_Zona__c,
                                  contacto__c,email__c,telefono__c, Tax_ID__c
                                  FROM Direcciones__c where id =:respuesta.iddireccion order by Name ];
        
        
        Guias_de_Exportacion__c ge=new Guias_de_Exportacion__c();
        
        ge.Contacto__c=respuesta.idcontacto;
        ge.Peso_Referencial__c=respuesta.peso!=''?decimal.valueOf(respuesta.peso.replace(',','.')):0;
        ge.Embalaje_HOT__c=respuesta.Embalaje; 
        ge.Telefono_Destinatario__c=respuesta.telefono;
        ge.Correo_Electronico__c=respuesta.email;
        ge.Largo__c=respuesta.largo!=''?decimal.valueOf(respuesta.largo.replace(',','.')):0;
        ge.Ancho__c=respuesta.ancho!=''?decimal.valueOf(respuesta.ancho.replace(',','.')):0;
        ge.Alto__c=respuesta.alto!=''?decimal.valueOf(respuesta.alto.replace(',','.')):0; 
        ge.Unidad_de_Medida__c = 'Kilogramos';
        //ge.Divisa__c='USD - U.S. Dollar';
        ge.Proposito_del_Envio__c = respuesta.Proposito_envio;
        ge.Breve_Descripcion__c = respuesta.breve_descripcion;
        ge.Tipo_Contenido__c=respuesta.tipo_contenido;
        ge.Paquetes__c = respuesta.N_paquete != '0' ? decimal.valueOf(respuesta.N_paquete) : null;         
        ge.Direccion_Destinatario__c=respuesta.iddireccion;
        ge.Contacto_Destinatario__c=respuesta.contacto;
        ge.ID_Remitente__c=respuesta.remitente;
        ge.Centro_de_Costo__c=respuesta.cent_cost;
		//ge.FrxTaxID__c = respuesta.TaxID;                
        ge.RecordTypeId = Schema.SObjectType.Guias_de_Exportacion__c.getRecordTypeInfosByName().get('Guía Agente').getRecordTypeId();
        if(respuesta.DDP=='SI'){
            ge.DDP__c=true; 
        }else{
            ge.DDP__c=false; 
        }
        if(respuesta.seguro=='SI'){
            ge.Seguro__c=true; 
        }else{
            ge.Seguro__c=false; 
        }
        
        if(respuesta.iddir_retiro!='0'){
            ge.Otro_Remitente__c=respuesta.iddir_retiro;
        }
        ge.OwnerId=respuesta.OwnerId;
        ge.Guia_Portal__c=true;
        insert ge;
        if(dir.size()>0){
            if(dir[0].contacto__c==null || dir[0].email__c==null || dir[0].telefono__c==null ){
                dir[0].contacto__c=respuesta.contacto; 
                dir[0].email__c=respuesta.email;
                dir[0].telefono__c=respuesta.telefono;                
                update dir[0];
            }
            dir[0].Tax_ID__c = respuesta.TaxID;
            update dir[0];
        }
        
        for(integer i=0;i<respuesta.productos.size();i++){
            Contenido_Envio__c  con=new Contenido_Envio__c();
            con.Pickup__c=ge.id;
            con.Descripcion__c=respuesta.productos.get(i).Descripcion;
            if(respuesta.productos.get(i).pais_Fabricacion!=null && respuesta.productos.get(i).pais_Fabricacion!='' && respuesta.productos.get(i).pais_Fabricacion!='null'){
                con.Pais_fab__c=respuesta.productos.get(i).pais_Fabricacion;
                
            }
            con.Cantidad__c=decimal.valueOf(respuesta.productos.get(i).Cantidad.replace(',','.'));
            con.Unidad_de_Medida__c=respuesta.productos.get(i).Unidad_Medida;
            con.Valor_Unitario__c=integer.valueOf(respuesta.productos.get(i).Valor_Unitario.replace('.',''));
            insert con; 
        }
        system.debug('respuesta.attachmentBody=='+respuesta.attachmentBody);
        system.debug('respuesta.attachmentName=='+respuesta.attachmentName);
        if(respuesta.attachmentBody!='' && respuesta.attachmentBody!=null && respuesta.attachmentName!='' && respuesta.attachmentName!=null ){
            Blob b = EncodingUtil.base64Decode(respuesta.attachmentBody);
            Attachment att=new Attachment();
            att.Body=b;
            att.Name=respuesta.attachmentName;
            att.ParentId=ge.id;
            
            insert att;      
        }  
        resultJSON='{"success":true, "idguia":"'+ge.id+'", "idp":"'+respuesta.idp+'" }';
        system.debug('resultJSON='+resultJSON);
    }
    
    public List<String> GetContentTypes(){
        List<String> ContentTypes = new List<String> ();
        Schema.DescribeFieldResult fieldResult = Guias_de_Exportacion__c.Tipo_Contenido__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for (Schema.PicklistEntry f : ple) {
            ContentTypes.add(f.getValue());            
        }
        return ContentTypes;
    }
    
    public class guardadoJSON {
        public String remitente { get; set; }
        public String OwnerId { get; set; }
        public String idp { get; set; }
        public String idcontacto { get; set; }
        public String iddireccion { get; set; }
        public String Nombre { get; set; }
        public String direccion { get; set; }
        public String ciudad { get; set; }
        public String Estado_Provincia { get; set; }
        public String codigo_Postal { get; set; }
        public String Pais { get; set; }
        public String contacto { get; set; } 
        public String email { get; set; } 
        public String telefono { get; set; } 
        public String alto { get; set; } 
        public String ancho { get; set; } 
        public String largo { get; set; } 
        public String peso { get; set; } 
        public String shipper { get; set; } 
        public String DDP { get; set; } 
        public String seguro { get; set; } 
        public String cent_cost { get; set; } 
        public String Embalaje { get; set; } 
        public String N_paquete { get; set; } 
        public String tipo_contenido { get; set; } 
        public String Proposito_envio { get; set; }  
        public String attachmentName { get; set; } 
        public String attachmentBody { get; set; } 
        public String iddir_retiro { get; set; } 
        public listproduc[] productos { get; set; } 
        public string breve_descripcion { get; set; } 
        public string TaxID{get;set;}
        
    }
    public class listproduc {
        public String id { get; set; }
        public String code { get; set; }
        public String Descripcion { get; set; }
        public String pais_Fabricacion { get; set; }
        public String Cantidad { get; set; } 
        public String Unidad_Medida { get; set; } 
        public String Valor_Unitario { get; set; } 
        
    }
    
    public class direciones{ 
        public string id{get;set;}
        public string nombre{get;set;}
        public string Direccion{get;set;}
        public string Ciudad{get;set;}
        public string Estado_Provincia{get;set;}
        public string codigo_Postal{get;set;}
        public string Pais{get;set;}
        public string OwnerId{get;set;}
        public string Telefono{get;set;}
        public string Email{get;set;}
        public string contacto{get;set;}
        public string Name{get;set;}
        public string TaxID{get;set;}
    }
    public class contacto{ 
        public string Idcuenta{get;set;}
        public string Nombre{get;set;}
        public string Apellidos{get;set;}
        public string Correo{get;set;}
        public string Telefono{get;set;}
        public string Tipo_Cargo{get;set;}
        public string Direccion{get;set;}
        public string Comuna{get;set;}
        public string Ciudad{get;set;}
        public string Pais{get;set;}
    }
}