public class HE_enviar_paquetes_Impor {
  public string idGI{get;set;}
    public string zpl2{get;set;}
    public string ZPL2Imagen{get;set;}
    public boolean mostrar{get;set;}
    public Solicitud_de_Pickup__c  gde{get;set;}
    public HE_enviar_paquetes_Impor(ApexPages.StandardController controller){
        idGI=ApexPages.currentPage().getParameters().get('id');
        system.debug('idGI'+idGI);
         gde=[SELECT Id, Name, Cuenta__c, Valor_Cliente__c, ID_de_Destinatario__c, Fecha_de_Envio__c, Unidad_de_Medida__c,N_de_Guia__c,
                                     Divisa__c, Agente__c, Estado_Pickup__c, Valor_Combustible__c, Total_Costos_Facturados__c,Ancho_cm__c,Etapa__c,Fecha_Estado__c,
                                     Alto_cm__c,Largo_cm__c,Total_Costos_sin_Facturar__c, Valor_Agente__c,Direccion_Destinatario__c,Cuenta__r.BillingStreet,
                                     Correo_Electronico_Destinatario__c,Direccion_Remitente__c,Cantidad_de_Paquetes__c,Contacto_Remitente__c,Cuenta__r.name,Peso_Agente__c,
                                     Cuenta__r.BillingCity,Cuenta__r.BillingState,Cuenta__r.BillingPostalCode,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                     Zona_HOT__c,Peso_Cliente__c,Zona_Fedex__c,Embalaje_HOT__c,Zona_DHL__c ,Cuenta__r.Tarifa_Importacion__c  
                                     FROM  Solicitud_de_Pickup__c where id=:idGI];
        
        
    }
    public PageReference  validar_ruta(){
        
         if(gde.Peso_Agente__c ==null   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar peso agente');
            ApexPages.addMessage(msg);
            
         }else{
        
        if(gde.Peso_Agente__c  > 68   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'peso agente maximo 68 kg');
            ApexPages.addMessage(msg);
            
        }
         }
        if(gde.Alto_cm__c==null  || gde.Largo_cm__c==null || gde.Ancho_cm__c==null){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar largo, ancho y alto ');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Agente__c==null  || gde.Agente__c==''){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar agente');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Zona_HOT__c==null  || gde.Zona_HOT__c==''){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar zona hot');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Peso_Agente__c==null  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar peso agente');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Peso_Cliente__c==null  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar peso cliente');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Agente__c==null  || gde.Agente__c==''){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar Agente');
            ApexPages.addMessage(msg);
            
        }
        
        if(gde.Direccion_Remitente__c==null  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar Remitente');
            ApexPages.addMessage(msg);
            
        }
      /*  if(gde.Direccion_Destinatario__c==null   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar Destinatario');
            ApexPages.addMessage(msg);
            
        }*/
        if(ApexPages.hasMessages()){
            return null;
        }
        string zona='';
        if(gde.Agente__c=='DHL'){
            zona= gde.Zona_DHL__c;
        }else if(gde.Agente__c=='Fedex'){
            zona= gde.Zona_Fedex__c;
        }else{
            
  }
        
         system.debug('zona='+zona);
         system.debug('gde.Embalaje_HOT__c='+gde.Embalaje_HOT__c);
         system.debug('gde.Peso_Agente__c='+gde.Peso_Agente__c); 
        list<Tarifa_Agente__c> tf=[SELECT Tipo_Tarifa__c, Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate
                             , LastModifiedById, SystemModstamp,
                             LastActivityDate, LastViewedDate, LastReferencedDate, Agente__c FROM Tarifa_Agente__c
                             where Agente__c=:gde.Agente__c 
                             and Tipo_Tarifa__c='Importación' ];
        system.debug('tf'+tf);
         list<Detalle_Tarifa_Agente__c> dettage=new list<Detalle_Tarifa_Agente__c>();
         if(tf.size()>0){
           
        
        dettage=[ SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,
                                                LastActivityDate, Tarifa_Agente__c, Valor__c, Kilos__c, Zona__c, Embalaje__c 
                                                FROM Detalle_Tarifa_Agente__c 
                                                where Tarifa_Agente__c=:tf[0].id
                                                and Zona__c=:zona 
                                                and Embalaje__c=:gde.Embalaje_HOT__c
                                                and Kilos__c>=:gde.Peso_Agente__c
                                                order by Kilos__c ];
        system.debug('dettage'+dettage);
             }
        list<Tarifa__c> tarifa=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                             LastViewedDate, LastReferencedDate, Vigencia_Desde__c, Vigencia_Hasta__c, Tipo_Tarifa__c 
                             FROM Tarifa__c
                             where Tipo_Tarifa__c='Importación'
                             and id=:gde.Cuenta__r.Tarifa_Importacion__c ];
        system.debug('tarifa'+tarifa);
         list<Detalle_Tarifa__c> dettar=new list<Detalle_Tarifa__c>();
        if(tarifa.size()>0){
             
          
        
         dettar=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,
                                        LastActivityDate, Tarifa__c,Zona__c, Embalaje__c, Kilos__c, Valor__c 
                                        FROM Detalle_Tarifa__c
                                        where Tarifa__c=: tarifa[0].id
                                        and Zona__c=:gde.Zona_HOT__c 
                                        and Embalaje__c=:gde.Embalaje_HOT__c
                                        and Kilos__c>=:gde.Peso_Cliente__c 
                                        order by Kilos__c ];
        
        system.debug('dettar'+dettar);
            }
        Porcentaje_Combustible__c pc=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                         LastViewedDate, LastReferencedDate, Porcentaje_Mensual__c, Fecha_Inicial__c, Mes__c, Ano__c, Periodo__c 
                                         FROM Porcentaje_Combustible__c];
        system.debug('pc'+pc);
        
        
        if(dettar.size()<=0   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'no se ha encontrado ninguna tarifa cliente para para la zona el peso y el agente ingresado');
            ApexPages.addMessage(msg);
            
        }
        if(dettage.size()<=0   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'no se ha encontrado ninguna tarifa agente para para la zona el peso y el agente ingresado');
            ApexPages.addMessage(msg);
            
        }
        
        
        
        
        
        
        
        if( gde.Direccion_Remitente__c!=null){
            
            HE_Consulta_Servicio_DHL_Impor.respuesta res=new HE_Consulta_Servicio_DHL_Impor.respuesta();
            HE_Consulta_Servicio_Fedex_Impor.respuesta resfed=new HE_Consulta_Servicio_Fedex_Impor.respuesta();
            system.debug('wqw');
            if(gde.Agente__c=='DHL'){
                HE_Consulta_Servicio_DHL_Impor  csd=new HE_Consulta_Servicio_DHL_Impor();
                if(!test.isRunningTest()){
                    res= csd.Shipment_Validation(idGI);
                }else{
                    HE_Consulta_Servicio_DHL_Impor.respuesta res_ejemplo=new HE_Consulta_Servicio_DHL_Impor.respuesta();
                    res_ejemplo.idtraking='12312';
                    list<HE_Consulta_Servicio_DHL_Impor.base> lb=new  list<HE_Consulta_Servicio_DHL_Impor.base>();
                    HE_Consulta_Servicio_DHL_Impor.base b=new  HE_Consulta_Servicio_DHL_Impor.base();
                    
                    string zpl2='^XA'+'%20'+
                        
                        '^FX Top section with company logo, name and address.'+'%20'+
                        '^CF0,60'+'%20'+
                        '^FO50,50^GB100,100,100^FS'+'%20'+
                        '^FO75,75^FR^GB100,100,100^FS'+'%20'+
                        '^FO88,88^GB50,50,50^FS'+'%20'+
                        '^FO220,50^FDInternational Shipping, Inc.^FS'+'%20'+
                        '^CF0,40'+'%20'+
                        '^FO220,100^FD1000 Shipping Lane^FS'+'%20'+
                        '^FO220,135^FDShelbyville TN 38102^FS'+'%20'+
                        '^FO220,170^FDUnited States (USA)^FS'+'%20'+
                        '^FO50,250^GB700,1,3^FS'+'%20';
                    
                    string base65enco=EncodingUtil.base64Encode(blob.valueOf(zpl2));   
                    b.base64blob=blob.valueOf(base65enco);
                    lb.add(b); 
                    res_ejemplo.base=lb;
                    list<HE_Consulta_Servicio_DHL_Impor.mensaje> m=new  list<HE_Consulta_Servicio_DHL_Impor.mensaje>();
                    
                    res_ejemplo.mensaje=m;
                    res_ejemplo.facturabase64='';  
                    res=res_ejemplo;
                }
                
                
                
                
                system.debug('res=='+res);
            }else if(gde.Agente__c=='Fedex'){
                HE_Consulta_Servicio_Fedex_Impor csf=new HE_Consulta_Servicio_Fedex_Impor();
                 if(!test.isRunningTest()){
                resfed=csf.Shipment_Validation(idGI);
                 }else{
                    HE_Consulta_Servicio_Fedex_Impor.respuesta res_ejemplo=new HE_Consulta_Servicio_Fedex_Impor.respuesta();
                    res_ejemplo.idtraking='12312';
                    list<HE_Consulta_Servicio_Fedex_Impor.base> lb=new  list<HE_Consulta_Servicio_Fedex_Impor.base>();
                    HE_Consulta_Servicio_Fedex_Impor.base b=new  HE_Consulta_Servicio_Fedex_Impor.base();
                    
                    string zpl2='^XA ';
                    
                    string base65enco=EncodingUtil.base64Encode(blob.valueOf(zpl2));   
                    b.base64blob=blob.valueOf(base65enco);
                    lb.add(b); 
                    res_ejemplo.base=lb;
                    list<HE_Consulta_Servicio_Fedex_Impor.mensaje> lm=new  list<HE_Consulta_Servicio_Fedex_Impor.mensaje>();
                     HE_Consulta_Servicio_Fedex_Impor.mensaje m=new  HE_Consulta_Servicio_Fedex_Impor.mensaje();
                     m.Severity='WARNING';
                     m.Message='1234124';
                     lm.add(m);
                    res_ejemplo.mensaje=lm;
                    res_ejemplo.facturabase64='';  
                    resfed=res_ejemplo;
                }
                system.debug('resfed=='+resfed);
            }else{
                
            }
            
            
            
            
            string url='/apex/HE_visualizar_etiqueta?base64=';
            mostrar=true;
            if(gde.Agente__c=='DHL'){
                if(res.mensaje.size()>0){
                    if(res.mensaje.get(0).Severity!=null && res.mensaje.get(0).Severity!=''){
                        ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,res.mensaje.get(0).Message);
                        ApexPages.addMessage(msg);
                    }
                    if(ApexPages.hasMessages()){
                        mostrar=false;
                        return null;  
                    }
                }
                gde.Fecha_de_Envio__c=system.today();
                gde.N_de_Guia__c=res.idtraking;
                gde.Etapa__c='Despachado';
                // url=url+res.base;
                string d=json.serialize(res);
                url=url+d;
                system.debug('res.base.get(0).base64='+res.base.get(0).base64blob.tostring());
                blob zplblob2=EncodingUtil.base64Decode(res.base.get(0).base64blob.tostring());
                system.debug('zplblob2'+zplblob2);
                zpl2=zplblob2.tostring();
                // zpl2=EncodingUtil.base64Decode(res.base.get(0).base64blob.tostring());
                //zpl2=EncodingUtil.base64Encode(res.base.get(0).base64blob);
                system.debug('zpl2'+zpl2);
                consultarZPL();
                //  return null;
            }else if(gde.Agente__c=='Fedex'){
                mostrar=false;
                if(resfed.mensaje.size()>0){
                    for(HE_Consulta_Servicio_Fedex_Impor.mensaje  d:resfed.mensaje){
                        system.debug('d='+d);
                        if(d.Severity!='WARNING' && d.Severity!='SUCCESS' && d.Severity!='NOTE'){
                            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,d.Message);
                            ApexPages.addMessage(msg);
                        }
                    }
                    if(ApexPages.hasMessages()){
                        return null;  
                    }
                    
                }
                gde.Fecha_de_Envio__c= system.today();
                gde.N_de_Guia__c=resfed.idtraking;
                gde.Etapa__c='Despachado';
                string d=json.serialize(resfed);
                url=url+d;
                url=url+'&&factura='+resfed.facturabase64;
            }
            if(dettar.size()>0){
               gde.Tarifa_Cliente__c=dettar.get(0).id; 
            }
            
            gde.Combustible__c=pc.Porcentaje_Mensual__c;
             if(dettage.size()>0){
              gde.Tarifa_Agente__c=dettage.get(0).id;
             }
            if(!test.isRunningTest()){
            update  gde;
            }
            list<Costo__c> cos = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Combustible'];
            if(cos.size()>0){
            Costo_Solicitud_Pickup__c cosimp=new Costo_Solicitud_Pickup__c();
            cosimp.Solicitud_de_Pickup__c=gde.id;
            // cosexp.name='combustible';
            cosimp.Costo__c=cos.get(0).id;
            cosimp.Valor__c=(99*pc.Porcentaje_Mensual__c)/100;
            insert cosimp;
            }
            list<Costo__c> cos1 = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Tarifa Cliente'];
            if(cos1.size()>0){
            Costo_Solicitud_Pickup__c cosimp1=new Costo_Solicitud_Pickup__c();
            cosimp1.Solicitud_de_Pickup__c=gde.id;
            //  cosexp1.name='Tarifa Cliente';
            cosimp1.Costo__c=cos1.get(0).id;
            cosimp1.Valor__c=dettar.get(0).Valor__c;
            insert cosimp1;
            }
            
            if(gde.Agente__c=='Fedex'){
                system.debug('url='+url);
                pageReference p = new PageReference(url); 
                return p;
            }else if(gde.Agente__c=='DHL'){
                return null;   
            }else{
                return null;
            }
        }
        else{
            system.debug('deve ingresar  destinatario y remitente ');
            return null;
        }
    }
    
    public PageReference  consultarZPL(){
        HE_Servicios  h=new HE_Servicios();
        string str=h.callOutconsultaZPL(zpl2);
        ZPL2Imagen=str;
        system.debug('str'+str);
        
        return null;
        /*
zpl2='^XA'+'%20'+

'^FX Top section with company logo, name and address.'+'%20'+
'^CF0,60'+'%20'+
'^FO50,50^GB100,100,100^FS'+'%20'+
'^FO75,75^FR^GB100,100,100^FS'+'%20'+
'^FO88,88^GB50,50,50^FS'+'%20'+
'^FO220,50^FDInternational Shipping, Inc.^FS'+'%20'+
'^CF0,40'+'%20'+
'^FO220,100^FD1000 Shipping Lane^FS'+'%20'+
'^FO220,135^FDShelbyville TN 38102^FS'+'%20'+
'^FO220,170^FDUnited States (USA)^FS'+'%20'+
'^FO50,250^GB700,1,3^FS'+'%20'+

'^FX Second section with recipient address and permit information.'+'%20'+
'^CFA,30'+'%20'+
'^FO50,300^FDJohn Doe^FS'+'%20'+
'^FO50,340^FD100 Main Street^FS'+'%20'+
'^FO50,380^FDSpringfield TN 39021^FS'+'%20'+
'^FO50,420^FDUnited States (USA)^FS'+'%20'+
'^CFA,15'+'%20'+
'^FO600,300^GB150,150,3^FS'+'%20'+
'^FO638,340^FDPermit^FS'+'%20'+
'^FO638,390^FD123456^FS'+'%20'+
'^FO50,500^GB700,1,3^FS'+'%20'+

'^FX Third section with barcode.'+'%20'+
'^BY5,2,270'+'%20'+
'^FO175,550^BC^FD1234567890^FS'+'%20'+

'^FX Fourth section (the two boxes on the bottom).'+'%20'+
'^FO50,900^GB700,250,3^FS'+'%20'+
'^FO400,900^GB1,250,3^FS'+'%20'+
'^CF0,40'+'%20'+
'^FO100,960^FDShipping Ctr. X34B-1^FS'+'%20'+
'^FO100,1010^FDREF1 F00B47^FS'+'%20'+
'^FO100,1060^FDREF2 BL4H8^FS'+'%20'+
'^CF0,190'+'%20'+
'^FO485,965^FDCA^FS'+'%20'+

'^XZ';
zpl2=zpl2.replace('^','%5E') ;
zpl2=zpl2.replace(' ','%20') ;
zpl2=zpl2.replace('\\n','%20') ;
system.debug('http://api.labelary.com/v1/printers/8dpmm/labels/4x6/0/'+zpl2);*/
    }
}