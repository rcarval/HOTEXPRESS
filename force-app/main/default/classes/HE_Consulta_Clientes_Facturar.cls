public class HE_Consulta_Clientes_Facturar {
    public   list<Account> Acc{get;set;}
    public   list<Contact> con{get;set;}
    public   string rut{get;set;}
    public   string resultJSON{get;set;}
    
    
    public HE_Consulta_Clientes_Facturar(){
        
    }
    public PageReference Obtenerclientes(){
        
        
        list<Guias_de_Exportacion__c> ge= [SELECT ID_Remitente__c
                                           FROM Guias_de_Exportacion__c 
                                           where Total_Costos_sin_Facturar__c > 0];
        list<string>  listidacc=new list<string>();
        list<string>  listidcont=new list<string>();
        id d;
        for(Guias_de_Exportacion__c g:ge){
            if(d!=g.ID_Remitente__c){
                listidacc.add(g.ID_Remitente__c);
                d=g.ID_Remitente__c;
            }
        }
        ge= [SELECT Contacto__c
             FROM Guias_de_Exportacion__c 
             where Total_Costos_sin_Facturar__c > 0];
        for(Guias_de_Exportacion__c g:ge){
            if(d!=g.Contacto__c){
                listidcont.add(g.Contacto__c);
                d=g.Contacto__c;
            }
        }  
        
        
        Acc=[select  id, name from Account  where id in: listidacc order by name];
        Con=[SELECT Id,  Name FROM Contact where  id in: listidcont order by name];
        system.debug('Acc'+Acc);
        return null;    
    }
    
    
    
    public string consultar_rut(){
        String datos = ApexPages.currentPage().getParameters().get('tipo');
        String rut = ApexPages.currentPage().getParameters().get('rut');
        system.debug('rut'+rut);
        
        
        system.debug('datos'+datos);
        list<Guias_de_Exportacion__c> ge;
        if(datos!=''){
            ge= [SELECT Contacto__c,Contacto__r.name,pais__c,Zona_HOT__c
                 FROM Guias_de_Exportacion__c 
                 where Total_Costos_sin_Facturar__c > 0 and ID_Remitente__c=:datos order by Contacto__c];
            
        }else{
            ge= [SELECT Contacto__c,Contacto__r.name,pais__c,Zona_HOT__c 
                 FROM Guias_de_Exportacion__c 
                 where Total_Costos_sin_Facturar__c > 0 and ID_Remitente__r.RUT__c=:rut order by Contacto__c];
            
        }
        list <contacto> conlist=new list <contacto>();
        id idcom;
        for(Guias_de_Exportacion__c  g:ge){
            if(idcom!=g.Contacto__c){
                contacto con=new contacto();
                con.id=g.Contacto__c;
                con.nombre=g.Contacto__r.name; 
                conlist.add(con);
                idcom=g.Contacto__c;
            }
        }
        
        list <pais> paislist=new list <pais>();
        string paiscom;
        for(Guias_de_Exportacion__c  g:ge){
            if(paiscom!=g.pais__c){
                pais ps=new pais();
                ps.pais=g.pais__c;
                ps.zona=g.Zona_HOT__c;
                paislist.add(ps);
                paiscom=g.pais__c;
            }
        }
        respuesta res=new respuesta();
        res.contacto=conlist;
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