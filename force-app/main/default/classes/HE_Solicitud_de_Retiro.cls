public class HE_Solicitud_de_Retiro {
   
    public Account acc {get;set;}
    public string idp {get;set;}
    public string idc {get;set;}
    public List<Pais__c> listpais{get;set;}
    public list<Contact> listacontactos{get;set;}
    public list<direciones> direciones{get;set;}
    public String resultJSON { get; set; }
    public String resultJSONGuia { get; set; }
    
     public PageReference datos(){
       idp=ApexPages.currentPage().getParameters().get('idp');
       idc=ApexPages.currentPage().getParameters().get('idc');
     //   idc='0015A000026wpWE';
      //   idp='0030v00000O1yzPAAR';
         acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode, BillingCountry, BillingAddress, ShippingAddress, 
             Phone, OwnerId, RUT__c, Haber__c, Debe__c, Saldo__c, Condici_n_Courier_Exportaci_n__c, Condicion_Comercial_Global__c 
             FROM Account WHERE Id =:idc];   
         
      listdir();
      listguia();
    //    direciones=listdir();  
        listpais=[SELECT Id, Name,  Cod_Pais__c FROM Pais__c order by Name];
       return null; 
    }
    
    
    
 public pagereference listdir(){
          list<Direcciones__c> dir=[SELECT Id, Name, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c, Codigo_Postal__c, Tipo__c,Pais__r.name, Cod_Pais__c, Nombre_Zona__c
                                    FROM Direcciones__c 
                                    where Cuenta__c=:idc order by Name];
                                    //And Tipo__c=:'Retiro'];
         
         
        list<HE_Solicitud_de_Retiro.direciones> direciones=new list<HE_Solicitud_de_Retiro.direciones>();
          HE_Solicitud_de_Retiro.direciones di=new HE_Solicitud_de_Retiro.direciones();
                di.id='0';
                di.nombre='seleccione direccion';
                direciones.add(di);
        for(integer i=0;i<dir.size();i++){
            
                 HE_Solicitud_de_Retiro.direciones d=new HE_Solicitud_de_Retiro.direciones();
                d.id=dir.get(i).Id;
                d.nombre=dir.get(i).Name;
                d.Direccion=dir.get(i).Direccion__c==null?'':dir.get(i).Direccion__c;
                d.Ciudad=dir.get(i).Ciudad__c==null?'':dir.get(i).Ciudad__c;
                d.Estado_Provincia=dir.get(i).Estado_Provincia__c==null?'':dir.get(i).Estado_Provincia__c;
                d.codigo_Postal=dir.get(i).Codigo_Postal__c==null?'':dir.get(i).Codigo_Postal__c;
                d.Pais=dir.get(i).Pais__r.name==null?'':dir.get(i).Pais__r.name;
                direciones.add(d);
           
            }
      resultJSON = JSON.serialize(direciones);
         return null;
        }
    
    public pagereference listguia(){
          list<Guias_de_Exportacion__c> guiexp=[SELECT Id, Name,N_de_Guia__c,ID_Remitente__r.name,Direccion_Destinatario__r.name,Pais__c  
                                                FROM Guias_de_Exportacion__c 
                                                where ID_Remitente__c=:idc
                                               AND Estado__c=:'Ingresado'];
         
        list<HE_Solicitud_de_Retiro.guiaexp> listnguia=new list<HE_Solicitud_de_Retiro.guiaexp>();
         for(integer i=0;i<guiexp.size();i++){
            
                 HE_Solicitud_de_Retiro.guiaexp g=new HE_Solicitud_de_Retiro.guiaexp();
                 g.id=guiexp.get(i).Id;
                 g.nombre=guiexp.get(i).Name;
                 g.nguia=guiexp.get(i).N_de_Guia__c==null?'':guiexp.get(i).N_de_Guia__c;
                 g.Remitente=guiexp.get(i).ID_Remitente__r.name;
                 g.destinatario=guiexp.get(i).Direccion_Destinatario__r.name;
                 g.pais=guiexp.get(i).Pais__c;
                
                listnguia.add(g);
           
            }
      resultJSONGuia = JSON.serialize(listnguia);
         return null;
        }
    
     public string direct(){
         system.debug('ooo sy');
         return null;
     }
    
           public void guardadirecion(){ 
          String datos = ApexPages.currentPage().getParameters().get('datos');
        System.debug('datos: '+datos);
        direciones respuesta = (direciones) System.JSON.deserialize(datos, direciones.class);
        system.debug('respuesta'+respuesta);
           try{
               Direcciones__c  dir=new Direcciones__c();
               dir.Name=respuesta.nombre;
               dir.Cuenta__c=respuesta.id;
               dir.Direccion__c=respuesta.Direccion;
               dir.Ciudad__c=respuesta.Ciudad;
               dir.Tipo__c='Retiro';
               dir.Estado_Provincia__c=respuesta.Estado_Provincia;
               dir.Codigo_Postal__c=respuesta.codigo_Postal;
               dir.Pais__c=respuesta.Pais;
               dir.OwnerId=respuesta.OwnerId;
            insert dir;
               
              resultJSON='{"success":true, "iddirecion":"'+dir.id+'"  }';   
           }catch(Exception e){
               
                resultJSON='{"success":false, "msg":"'+e+'"}'; 
           }
       
       }
    
    
       public void guardaPedido(){
        try{
            String datos = ApexPages.currentPage().getParameters().get('datos');
            System.debug('datos: '+datos);
            guardadoJSON respuesta = (guardadoJSON) System.JSON.deserialize(datos, guardadoJSON.class);
            if(respuesta.dirid!=null){
            Direcciones__c dr=new Direcciones__c();
            dr.Name=respuesta.nombre;
            dr.Direccion__c=respuesta.direccion;
            dr.Ciudad__c=respuesta.ciudad;
            dr.Codigo_Postal__c=respuesta.codigo_Postal;
           //dr.Pais__c=respuesta.Pais;
            dr.Estado_Provincia__c=respuesta.Estado_Provincia;
            //insert dr;
            }
            
            Solicitud_de_Retiro__c    p=new Solicitud_de_Retiro__c();
            p.Cuenta__c=respuesta.idc;
            p.Contacto_para_Retiro__c=respuesta.idp;
            p.Direcciones__c=respuesta.dirid;
            p.Indicaciones_Especiales__c=respuesta.Inret;
            p.Fecha_de_Retiro__c=date.valueOf(respuesta.fecha);
            p.Rango_Horario__c=respuesta.h_retiro;
            p.OwnerId=respuesta.OwnerId;
            p.Otro_Contacto_para_Retiro__c=respuesta.Ncontret;
            p.Cantidad_Paquetes__c=respuesta.can_paquetes!=''?decimal.valueOf(respuesta.can_paquetes):0;
            p.Peso_Aproximado__c=respuesta.peso_aprox!=''?decimal.valueOf(respuesta.peso_aprox):0;
            p.Pickup_Portal__c=true;
            insert p;
           
            if(respuesta.prods.size()>0){
                
                list<string> listidge=new list<string>();
                
                for(integer i=0;i<respuesta.prods.size();i++ ) {
                    listidge.add(respuesta.prods.get(i).id);
                }
                
                list<Guias_de_Exportacion_Retiro__c> listGER=new  list<Guias_de_Exportacion_Retiro__c>();
             list<Guias_de_Exportacion__c>    gex=[SELECT Id, Name FROM Guias_de_Exportacion__c where id in:listidge];
                 for(integer j=0;j<gex.size();j++ ) {
                //    gex.get(j).Solicitud_de_Retiro__c=p.id;
                     Guias_de_Exportacion_Retiro__c  ger=new Guias_de_Exportacion_Retiro__c();
                     ger.Guias_de_Exportacion__c=gex.get(j).id;
                     ger.Solicitud_de_Retiro__c=p.id;
                         listGER.add(ger);
                }
                
            //    update gex;
                insert listGER;
                
            }
            resultJSON = '{"success":true,"msg":"ok","idpik":"'+p.id+'"}';
            System.debug('respuesta='+respuesta);
         }catch(Exception ex){
            System.debug('Tipo de excepción: ' + ex.getTypeName());
            System.debug('Mensaje: ' + ex.getMessage());
            System.debug('Causa: ' + ex.getCause());
            System.debug('Línea: ' + ex.getLineNumber());
            System.debug('Traza: ' + ex.getStackTraceString());
            resultJSON = '{"error":true,"msg":"'+ex.getMessage()+'"}';
        }
    }      
    public class guardadoJSON {
        public String dirid { get; set; }
        public String nombre { get; set; }
        public String direccion { get; set; }
        public String ciudad { get; set; }
        public String Estado_Provincia { get; set; }
        public String codigo_Postal { get; set; }
        public String Pais { get; set; }
        public String fecha { get; set; }
        public String idc { get; set; }
        public String idp { get; set; }
        public String h_retiro { get; set; }
        public String Ncontret { get; set; }
        public String Inret { get; set; }
                public String peso_aprox { get; set; }
        public String can_paquetes { get; set; }
                public String OwnerId { get; set; }
        public List<guiaexp> prods { get; set; }
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
          public string tipo{get;set;}
          
      }
       public class guiaexp{ 
          public string id{get;set;}
          public string nombre{get;set;}
          public string nguia{get;set;}
          public string Remitente{get;set;}
          public string destinatario{get;set;}
          public string pais{get;set;}
       }
}