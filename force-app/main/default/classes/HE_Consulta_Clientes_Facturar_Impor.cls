public class HE_Consulta_Clientes_Facturar_Impor {
 public   list<Account> Acc{get;set;}
    public   list<Contact> con{get;set;}
    public   string rut{get;set;}
    public   string resultJSON{get;set;}
    
    
    public HE_Consulta_Clientes_Facturar_Impor(){
        
    }
    public PageReference Obtenerclientes(){
        
        
        list<Solicitud_de_Pickup__c> ge= [SELECT Cuenta__c,Total_Costos_sin_Facturar__c
                                           FROM Solicitud_de_Pickup__c 
                                           where Total_Costos_sin_Facturar__c > 0];
        system.debug('ge='+ge);
        list<string>  listidacc=new list<string>();
        list<string>  listidcont=new list<string>();
        id d;
        for(Solicitud_de_Pickup__c g:ge){
            if(d!=g.Cuenta__c){
                listidacc.add(g.Cuenta__c);
                d=g.Cuenta__c;
            }
        }
      /*  ge= [SELECT Contacto_Remitente__c
             FROM Solicitud_de_Pickup__c 
             where Total_Costos_sin_Facturar__c > 0];
        for(Solicitud_de_Pickup__c g:ge){
            if(d!=g.Contacto_Remitente__c){
                listidcont.add(g.Contacto_Remitente__c);
                d=g.Contacto_Remitente__c;
            }
        }  */
        
        
        Acc=[select  id, name from Account  where id in: listidacc order by name];
        //Con=[SELECT Id,  Name FROM Contact where  id in: listidcont order by name];
        system.debug('Acc'+Acc);
        return null;    
    }
    
    
    
    public string consultar_rut(){
        String datos = ApexPages.currentPage().getParameters().get('tipo');
        String rut = ApexPages.currentPage().getParameters().get('rut');
        system.debug('rut'+rut);
        
        
        system.debug('datos'+datos);
        list<Solicitud_de_Pickup__c> ge;
        if(datos!=''){
            ge= [SELECT Contacto_Remitente__c,pais__c,Zona_HOT__c
                 FROM Solicitud_de_Pickup__c 
                 where Total_Costos_sin_Facturar__c > 0 and Cuenta__c=:datos order by Contacto_Remitente__c];
            
        }else{
            ge= [SELECT Contacto_Remitente__c,pais__c,Zona_HOT__c 
                 FROM Solicitud_de_Pickup__c 
                 where Total_Costos_sin_Facturar__c > 0 and Cuenta__r.RUT__c=:rut order by Contacto_Remitente__c];
            
        }
        system.debug('ge='+ge);
     /*   list <contacto> conlist=new list <contacto>();
        id idcom;
        for(Guias_de_Exportacion__c  g:ge){
            if(idcom!=g.Contacto__c){
                contacto con=new contacto();
                con.id=g.Contacto__c;
                con.nombre=g.Contacto__r.name; 
                conlist.add(con);
                idcom=g.Contacto__c;
            }
        }*/
        
        list <pais> paislist=new list <pais>();
        string paiscom;
        for(Solicitud_de_Pickup__c  g:ge){
            if(paiscom!=g.pais__c){
                pais ps=new pais();
                ps.pais=g.pais__c;
                ps.zona=g.Zona_HOT__c;
                paislist.add(ps);
                paiscom=g.pais__c;
            }
        }
        respuesta res=new respuesta();
       // res.contacto=conlist;
        res.pais=paislist;
        
        resultJSON=json.serialize(res);
        
        
        return null;
    }
    
    public class respuesta{
        public   list<contacto> contacto{get;set;}
        public   list<pais> pais{get;set;}
        
    }
    
    public class contacto{
        public string id{get;set;} 
        public string nombre{get;set;} 
    }
    
    public class pais{
        public string pais{get;set;} 
        public string zona{get;set;} 
        
    }
    
}