global  class HE_actualiza_estado implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Integer recordsProcessed = 0;
    global Database.QueryLocator start(Database.BatchableContext bc) {
        string str='SELECT Nombre_Receptor__c, Fecha_de_Entrega__c, Rut_Consignatario__c, Estado_Correo__c, Id, Name,Shipment_Code__c FROM Detalles_Master__c where  Fecha_de_Entrega__c=null and Enviado_a_Correo__c=true';
        return Database.getQueryLocator(str);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Detalles_Master__c> dtmt){
        // process each batch of records
        tempuriOrg.EnvioReq   emp =  new tempuriOrg.EnvioReq();
        tempuriOrg.EnvioRes  resp  =  new tempuriOrg.EnvioRes();
        list<Historial_de_Tracking__c> hist=new list<Historial_de_Tracking__c>();
        EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='tempuriOrg' limit 1 ];
        list<Historial_de_Tracking__c> histrack= [SELECT Id, Fecha__c, Estado_Tracking__c, Oficina_de_Origen__c, Name,Detalles_Master__c  FROM Historial_de_Tracking__c where Detalles_Master__c in:dtmt order by  Detalles_Master__c];
        system.debug('histrack'+histrack);
        integer contador=0;
        system.debug('dtmt'+dtmt);
        
        for (integer j=0; j<dtmt.size(); j++) { 
            /*  emp.Codigo= '999023520749';
emp.CodigoCliente='532878';
emp.Usuario='PRUEBATRAZABILIDAD';
emp.Password='P2RTRAZ19';*/
            emp.Codigo=dtmt.get(j).Shipment_Code__c==null?dtmt.get(j).Name:dtmt.get(j).Shipment_Code__c; 
            emp.CodigoCliente=ep.Codigo_Cliente__c;
            emp.Usuario=ep.usuario__c;
            emp.Password=ep.contrase_a__c; 
            tempuriOrg.WSConsultaEnvioSoap temWS =  new tempuriOrg.WSConsultaEnvioSoap();
            contador++;
            system.debug('emp=='+emp);
            try{
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
                if(histrack.size()>0 ){
                    // delete histrack;
                    if(resp.Envio.Estruct_Envio[0].Historial!=null){
                      
                                for(integer i=0;i<resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial.size();i++){
                                    integer contadorh=0;
                                      Historial_de_Tracking__c  ht=new Historial_de_Tracking__c();
                            for(Historial_de_Tracking__c  htc:histrack){
                               if(htc.Detalles_Master__c==dtmt.get(j).id){
                                    datetime fecha=datetime.parse(resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha);
                                    system.debug('fecha'+fecha);
                                    if(fecha!=htc.Fecha__c){
                                      
                                        ht.Estado_Tracking__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisEstadoDes;
                                        system.debug('resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha'+resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha); 
                                        ht.Fecha__c=fecha;
                                        ht.Oficina_de_Origen__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisOficinaOrigenDes;
                                        ht.Detalles_Master__c=dtmt.get(j).id;
                                        ht.name=dtmt.get(j).name;
                                       
                                    }else{
                                        contadorh++;
                                    }
                                }
                                
                            }
                                    if(contadorh==0){
                                       hist.add(ht);  
                                    }
                            
                        }
                    }
                }else{
                    if(resp.Envio.Estruct_Envio[0].Historial!=null){
                        for(integer i=0;i<resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial.size();i++){
                            Historial_de_Tracking__c  ht=new Historial_de_Tracking__c();
                            ht.Estado_Tracking__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisEstadoDes;
                            system.debug('resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha'+resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha);
                            datetime fecha=datetime.parse(resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisFecha);
                            system.debug('fecha'+fecha);
                            ht.Fecha__c=fecha;
                            ht.Oficina_de_Origen__c=resp.Envio.Estruct_Envio[0].Historial.Estruct_Historial[i].HisOficinaOrigenDes;
                            ht.Detalles_Master__c=dtmt.get(j).id;
                            ht.name=dtmt.get(j).name;
                            hist.add(ht);
                        }
                    }
                }    
                dtmt.get(j).Nombre_Receptor__c=resp.Envio.Estruct_Envio[0].NombreEntrega;
                dtmt.get(j).Fecha_de_Entrega__c=resp.Envio.Estruct_Envio[0].FechaEntrega==''?null:date.parse(resp.Envio.Estruct_Envio[0].FechaEntrega);
                dtmt.get(j).Rut_Consignatario__c=resp.Envio.Estruct_Envio[0].RutEntrega;
                dtmt.get(j).Estado_Correo__c=resp.Envio.Estruct_Envio[0].Estado;
                dtmt.get(j).Shipment_Code__c=resp.Envio.Estruct_Envio[0].Envio;
                
                
                
                system.debug('resp'+resp);
            }catch(Exception e){
                system.debug('e=='+e);
            }
            
        }
        
        insert hist;
        update dtmt; 
        system.debug('contador'+contador);
        //     update contacts;
    }    
    
    global void finish(Database.BatchableContext bc){
        System.debug(  'fin proceso...');
        
    }    
    
    
}