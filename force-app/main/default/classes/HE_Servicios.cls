public class HE_Servicios {
 public String callOutConvenioEmpresa(string estructura){
        String str;
        string XML=estructura;
     EndPoint_DHL__mdt  dhl=[SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName,
                             SiteID__c, Password__c, ShipperAccountNumber__c, tel_fono_contacto__c,
                             nombre_contacto__c, servicio__c, EndPoint__c 
                             FROM EndPoint_DHL__mdt 
                             where QualifiedApiName=:'servicio_dhl' and servicio__c=:'Shipment_Validation'  ];
       // string url='http://xmlpitest-ea.dhl.com/XMLShippingServlet';
     string url=dhl.EndPoint__c;
     try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            
             req.setHeader('content-type','application/xml');  
             req.setmethod('POST');
             req.setBody(XML);
            system.debug('req'+req);
            system.debug('XML'+XML);
            
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                str=res1.getbody();
                System.debug('str1='+res1.getBody());
                System.debug('str2='+res1.getStatusCode());
                System.debug('str3='+res1.getHeaderKeys());
            }
        }catch(Exception e){
            str='error entro al catch' +e;
        } 
        System.debug('str='+str);
        return str;
    }


 public String callOutconsultaZPL(string estructura){
        String str;
        string ZPL=estructura;
   
     string url='http://api.labelary.com/v1/printers/8dpmm/labels/4x8/';
     try{
            Http h =new Http();
            HttpRequest req= new HttpRequest();
            req.setTimeout(120000);
            req.setEndpoint(url);                    
            
           // req.setHeader('Accept','image/png');
             req.setHeader('Accept','application/pdf');
             req.setHeader('Content-Type','application/x-www-form-urlencoded');  
         req.setmethod('POST');
             req.setBody(ZPL);
            system.debug('req'+req);
          //  system.debug('ZPL'+ZPL);
            
            if(!test.isRunningTest()){
                HttpResponse res1;
                res1 = h.send(req);
                str=res1.getbody();
                System.debug('res1='+res1);
                blob    str2=res1.getBodyAsBlob();
                 
               str=EncodingUtil.base64Encode(str2);
                
            }
        }catch(Exception e){
            str='error entro al catch' +e;
        } 
        System.debug('str='+str);
        return str;
    }
    
}