public class HE_Guia_Hot_EX {
    
    public string idexp{get;set;}
    public string idp{get;set;}
    public string idc{get;set;}
    public string numguia{get;set;} 
    public string numguiacompleto{get;set;} 
    public Guias_de_Exportacion__c  gde{get;set;}
    public Direcciones__c  dir{get;set;}
    public list<Contenido_Envio__c> conenv{get;set;}
    
    public Account  acc{get;set;}
    public string ddp{get;set;}
    public string seguro{get;set;}
    public string sender{get;set;}
    public string dir_origen{get;set;}
    public string ciu_origen{get;set;}
    public string pais_origen {get;set;}
    public string contacto_origen{get;set;}
    public string telefono_origen{get;set;}
    public string fecha{get;set;}
    public string reseptor{get;set;}
    public string dir_destino{get;set;}
    public string ciu_destino{get;set;}
    public string pais_destino {get;set;}
    public string contacto_destino{get;set;}
    public string telefono_destino{get;set;}
    public string postal_destino{get;set;}
    public string otro_Remitente {get;set;}
    public string OtraDireccion {get;set;}
    public string alto{get;set;}
    public string largo{get;set;}
    public string ancho{get;set;}
    public decimal cantidad_total{get;set;}
    public decimal monto_total{get;set;}
    
    
    
    public HE_Guia_Hot_EX(ApexPages.StandardController controller){
        idexp=ApexPages.currentPage().getParameters().get('id');
        idp=ApexPages.currentPage().getParameters().get('idp');
        system.debug('idexp'+idexp); 
        gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
             Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,
             Peso_Agente__c,Contacto__r.name,Contacto__r.email,Telefono__c,Calle__c,Ciudad__c,Pais__c,Tipo_Contenido__c,
             Shipper_Original__c,ID_Remitente__r.BillingStreet,ID_Remitente__r.BillingCity,ID_Remitente__r.name,
             ID_Remitente__r.BillingCountry,Cod_Postal__c,ID_Remitente__c,Direccion_Destinatario__r.name,CreatedDate,
             Contacto__r.MailingStreet,Contacto__r.MailingCity,Contacto__r.MailingCountry,ddp__c,Centro_de_Costo__c,
             Proposito_del_Envio__c,Seguro__c, Breve_Descripcion__c, Breve_Descripcion_2__c, Breve_Descripcion_3__c, Breve_Descripcion_4__c, Direccion_Contacto__c, Otro_Remitente__c,Otra_Direcci_n__c
             from Guias_de_Exportacion__c where id=:idexp];
        
        idc=gde.ID_Remitente__c;
        conenv= [select id,Cantidad__c,Condicion_de_Venta__c,Descripcion__c,Comentarios__c, Pais_fab__r.Cod_Pais__c,
                 Unidad_de_Medida__c,Valor_Unitario__c
                 from Contenido_Envio__c where Pickup__c=:gde.id];
        
        
        dir=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
             LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
             Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Destinatario__c];
        
        acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
             OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c 
             FROM Account 
             WHERE Nombre_Fantasia__c =: 'Hot Express'];
        numguiacompleto=gde.name;
        numguia=(gde.name).replace('GE-','');
        otro_Remitente = gde.Otro_Remitente__c;
        
         if(gde.Otro_Remitente__c!=null){
             OtraDireccion = gde.Otra_Direcci_n__c;
         }
        else
        {
        	OtraDireccion = gde.Direccion_Contacto__c;
        }
    }
    
    public PageReference consultar(){
        system.debug('gde'+gde);
        system.debug('conenv'+conenv);
        if(gde.ddp__c==true){
            ddp='SI';   
        }else{
            ddp='NO';     
        }
        if(gde.Seguro__c==true){
            seguro='SI';   
        }else{
            seguro='NO';     
        }
        
        sender=gde.ID_Remitente__r.name;
        //  dir_origen=gde.ID_Remitente__r.BillingStreet;
        // ciu_origen=gde.ID_Remitente__r.BillingCity;
        // pais_origen=gde.ID_Remitente__r.BillingCountry;
        
        //dir_origen=gde.Contacto__r.MailingStreet;
        dir_origen=gde.Direccion_Contacto__c;
        ciu_origen=gde.Contacto__r.MailingCity;
        pais_origen=gde.ID_Remitente__r.BillingCountry;
        contacto_origen=gde.Contacto__r.name;
        telefono_origen=gde.Telefono__c;
        
        reseptor=gde.Direccion_Destinatario__r.name;
        dir_destino=gde.Calle__c;
        ciu_destino=gde.Ciudad__c;
        pais_destino=gde.Pais__c;
        postal_destino=gde.Cod_Postal__c;
        contacto_destino=gde.Contacto_Destinatario__c;
        telefono_destino=gde.Telefono_Destinatario__c;
        fecha=gde.CreatedDate.day()+'/'+gde.CreatedDate.month()+'/'+gde.CreatedDate.year();
        ancho =string.valueOf(gde.Ancho__c);
        alto=string.valueOf(gde.Alto__c);
        largo =string.valueOf(gde.Largo__c);
        
        cantidad_total=0;
        monto_total=0;
        if(conenv!=null){
            for(Contenido_Envio__c ce: conenv){
                cantidad_total=cantidad_total+ce.Cantidad__c;
                monto_total=monto_total+(ce.Cantidad__c*ce.Valor_Unitario__c);
            }
        }
        
        
        return null;
        
    }
    
    
    
}