public class HE_consulta_estado {
    public list<tempuriOrg.Estruct_Envio> listado_estado{get;set;}
    public HE_consulta_estado(ApexPages.StandardController controller){
        
    }
    public PageReference consulta() {
        String ido = ApexPages.currentPage().getParameters().get('id');
        tempuriOrg    ter=new  tempuriOrg();
        tempuriOrg.ConsultaEnvioResponse_element   rest = new tempuriOrg.ConsultaEnvioResponse_element();
        tempuriOrg.EnvioReq   emp =  new tempuriOrg.EnvioReq();
        tempuriOrg.EnvioRes  resp  =  new tempuriOrg.EnvioRes();
        EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='tempuriOrg' limit 1 ];
        Detalles_Master__c detord = [SELECT Nombre_Receptor__c, Fecha_de_Entrega__c, Rut_Consignatario__c, Estado_Correo__c,Shipment_Code__c , Id, Name FROM Detalles_Master__c where  id=:ido];
         //emp.Codigo='999023520749';
         emp.CodigoCliente='532878';
         emp.Usuario='PRUEBATRAZABILIDAD';
        emp.Password='P2RTRAZ19'; 
         emp.Codigo=detord.Shipment_Code__c==null?detord.Name:detord.Shipment_Code__c;//'999023520749';
         //emp.CodigoCliente=ep.Codigo_Cliente__c;
        // emp.Usuario=ep.usuario__c;
       //  emp.Password=ep.contrase_a__c; 
        system.debug('emp'+emp);
        tempuriOrg.WSConsultaEnvioSoap temWS =  new tempuriOrg.WSConsultaEnvioSoap();
        
        if(!test.isRunningTest()){
            resp=temWS.ConsultaEnvio(emp);
        }else{
            
            tempuriOrg.Estruct_Historial eh=new tempuriOrg.Estruct_Historial();
            
            eh.HisFecha='22/03/2017 17:00';
            eh.HisEstadoDes='stg';
            eh.HisOficinaOrigenDes='stg';
            list<tempuriOrg.Estruct_Historial> dd=new list<tempuriOrg.Estruct_Historial>();
            dd.add(eh);
            tempuriOrg.ArrayOfEstruct_Historial His=new  tempuriOrg.ArrayOfEstruct_Historial();
            His.Estruct_Historial=dd;
            tempuriOrg.Estruct_Envio  ee=new tempuriOrg.Estruct_Envio();
            ee.Envio='1';
            ee.FechaEntrega='22/03/2017';
            ee.NombreEntrega='1';
            ee.RutEntrega='2';
            ee.Estado='3';
            ee.Referencia='4';
            ee.HistorialLen=0;
            ee.Historial=His;
            
            list<tempuriOrg.Estruct_Envio>  ff=new list<tempuriOrg.Estruct_Envio>();
            ff.add(ee);
            tempuriOrg.ArrayOfEstruct_Envio En=new     tempuriOrg.ArrayOfEstruct_Envio();
            en.Estruct_Envio=ff;
            
            
            tempuriOrg.EnvioRes er=new tempuriOrg.EnvioRes();
            er.Envio=en;
            er.Largo=1;
            er.Indice=1;
            er.TipoError='sdff';
            resp=er;
        }
        
        list<Historial_de_Tracking__c> histrack= [SELECT Id, Fecha__c, Estado_Tracking__c, Oficina_de_Origen__c, Name,Detalles_Master__c  FROM Historial_de_Tracking__c where Detalles_Master__c =:detord.id];
        if(histrack.size()>0){
            // delete histrack;
            if(resp.Envio.Estruct_Envio[0].Historial!=null ){
                if(resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial!=null ){
                   
                    for(integer i=0;i<resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial.size();i++){
                        integer contador=0;
                          Historial_de_Tracking__c  ht=new Historial_de_Tracking__c();
                       for(Historial_de_Tracking__c  htc:histrack){      
                        datetime fecha=datetime.parse(resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha);
                        system.debug('fecha'+fecha);
                        if(fecha!=htc.Fecha__c){
                          
                            ht.Estado_Tracking__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisEstadoDes;
                            system.debug('resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha'+resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha); 
                            ht.Fecha__c=fecha;
                            ht.Oficina_de_Origen__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisOficinaOrigenDes;
                            ht.Detalles_Master__c=detord.id;
                            ht.Name=detord.Name;
                          
                        }else{
                            contador++;
                        }
                         }
                        if(contador==0){
                              insert ht;
                        }
                    
                    }
                }
                }
            
        }else{
            system.debug('resp.Envio.Estruct_Envio[0].Historial'+resp.Envio.Estruct_Envio[0].Historial);
            if(resp.Envio.Estruct_Envio[0].Historial!=null){
                 if(resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial!=null){
                for(integer i=0;i<resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial.size();i++){
                    Historial_de_Tracking__c  ht=new Historial_de_Tracking__c();
                    ht.Estado_Tracking__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisEstadoDes;
                    system.debug('resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha'+resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha);
                    datetime fecha=datetime.parse(resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha);
                    system.debug('fecha'+fecha);
                    ht.Fecha__c=fecha;
                    ht.Oficina_de_Origen__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisOficinaOrigenDes;
                    ht.Detalles_Master__c=detord.id;
                    ht.Name=detord.Name;
                    insert ht;
                }
                 }
            }
        }
        detord.Nombre_Receptor__c=resp.Envio.Estruct_Envio[0].NombreEntrega;
        
        system.debug('resp.Envio.Estruct_Envio[0].FechaEntrega'+resp.Envio.Estruct_Envio[0].FechaEntrega);        
        //datetime fecha_entrega=date.parse();
        detord.Fecha_de_Entrega__c=resp.Envio.Estruct_Envio[0].FechaEntrega==''?null:date.parse(resp.Envio.Estruct_Envio[0].FechaEntrega);
        detord.Rut_Consignatario__c=resp.Envio.Estruct_Envio[0].RutEntrega;
        detord.Estado_Correo__c=resp.Envio.Estruct_Envio[0].Estado;
        detord.Shipment_Code__c=resp.Envio.Estruct_Envio[0].Envio;
        update detord;
        
        system.debug('resp'+resp); 
        system.debug('resp.Envio'+resp.Envio);
        system.debug('resp'+resp.Envio.Estruct_Envio);
        system.debug('resp'+resp.Envio.Estruct_Envio.size());
        system.debug('resp'+resp.Envio.Estruct_Envio[0].Historial);
        system.debug('resp'+resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial);
        //  listado_estado=resp.Envio.Estruct_Envio;
        pageReference p = new PageReference('/'+detord.id);
        
        
        return p;
    } 
    
    /* public static resServicio parseResponse(HttpResponse res){
resServicio r = new resServicio();
dom.Document resDoc = res.getBodyDocument();
dom.XmlNode envelope = resDoc.getRootElement();*/
    /*System.debug(envelope);
dom.XmlNode envB = envelope.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
dom.XmlNode bRes = envB.getChildElement('rechazoPropuestaResponse', 'http://ws.centralizadorinspecciones.integracion.cns.cl/');
dom.XmlNode ret = bRes.getChildElement('return', null);*/
    /*  r.mensajeRespuesta = envelope.getChildElement('mensajeRespuesta', null).getText();
r.numRespuesta = envelope.getChildElement('numRespuesta', null).getText();
System.debug('Mensaje respuesta: '+r.mensajeRespuesta);
System.debug('Numero respuesta: '+r.numRespuesta);
return r;
}*/
}