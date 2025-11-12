public class HE_visualizar_etiqueta {
   public  String  base64{get;set;} 
   public  String  base64parte2{get;set;} 
   public  String  facturabase64{get;set;} 
   public  respuestaJSON respuesta{get;set;} 
     
  /*  public  HE_visualizar_etiqueta(){
        
    }*/
     public  HE_visualizar_etiqueta(ApexPages.StandardController  Controller) {
           // base64=ApexPages.currentPage().getParameters().get('base64');
              String datos = ApexPages.currentPage().getParameters().get('base64');
           system.debug('datos'+datos);
            respuesta = (respuestaJSON) System.JSON.deserialize(datos, respuestaJSON.class);
         for(integer i=0;i<respuesta.base.size();i++){
             respuesta.base.get(i).base64=respuesta.base.get(i).base64blob.tostring();
         }
         system.debug('respuesta'+respuesta);
     }
     public PageReference ver_pdf(){
         base64=ApexPages.currentPage().getParameters().get('base64');
        
         base64=respuesta.base.get(0).base64blob.tostring();
    //      base64parte2=respuesta.base.get(1).base64blob.tostring();
         //base64=base64.replace(' ', '+');
         facturabase64=ApexPages.currentPage().getParameters().get('factura');
          facturabase64=respuesta.facturabase64;
         if(facturabase64 !=null){
            facturabase64=facturabase64.replace(' ', '+'); 
         }
         
         system.debug('base64'+base64);
         system.debug('base64'+base64.length());
         return null;
     }
    
     public class respuestaJSON {
        public string idtraking{get;set;}
        public list<base64JSON> base{get;set;}
        public string facturabase64{get;set;}
    }  
     public class base64JSON {
        public blob base64blob{get;set;}
        public blob facturabase64{get;set;}
        public string base64{get;set;}
        public integer num{get;set;}
        
    }  
}