public class HE_PreFactura_Impor {
  public list<Costo_Solicitud_Pickup__c> list_costos{get;set;}
     public Account acc{get;set;}
     list<datosguia> resp {get;set;}
    public list<datosprefactura> prefac {get;set;}
    public decimal totalCLP{get;set;}
     public decimal totalUSD{get;set;}
     
    public string cargar(){
         String id = ApexPages.currentPage().getParameters().get('id');
         String datos = ApexPages.currentPage().getParameters().get('data');
         decimal vd = decimal.valueOf(ApexPages.currentPage().getParameters().get('VD')); 
         system.debug('id'+id);
        system.debug('datos'+datos);
        resp = (list<datosguia>) System.JSON.deserialize(datos, list<datosguia>.class);
        list<string> consulktar_idguias=new list<string>();
        for(datosguia dat:resp){
          consulktar_idguias.add(dat.idguiaconsulta);
        }
        
          system.debug('resp'+resp);
        acc=[select id,name,rut__c,Condicion_Comercial_Global__c,Phone,Billingstreet from Account where id=:id];//'0015A000026wpaN'
        list_costos=[SELECT Id, Name, Valor__c, Solicitud_de_Pickup__c,Solicitud_de_Pickup__r.name, Estado__c, Factura__c FROM Costo_Solicitud_Pickup__c where Solicitud_de_Pickup__c in: consulktar_idguias and Estado__c='Pendiente de Facturar' ];
         totalCLP=0;
         totalUSD=0;
         prefac=new list<datosprefactura>();
        for(Costo_Solicitud_Pickup__c ce:list_costos){
        datosprefactura  df=new  datosprefactura();   
        df.Ngactura=ce.Solicitud_de_Pickup__r.name;
        df.descripcion=ce.name;
        df.montoUSD=ce.Valor__c;
        totalUSD=(totalUSD+df.montoUSD).setScale(0);
        df.montoCLP=(ce.Valor__c * vd).setScale(0);
        totalCLP=(totalCLP+df.montoCLP).setScale(0);
        df.Valordolar=string.valueOf(vd);
       prefac.add(df);

        }
      return null;
    }
    
      public class datosguia{
        public string idguiaconsulta{get;set;}
      }
     public class datosprefactura{
        public string Ngactura{get;set;}
        public string descripcion{get;set;}
        public decimal montoUSD{get;set;}
        public decimal montoCLP{get;set;}
        public string Valordolar{get;set;}
      }
}