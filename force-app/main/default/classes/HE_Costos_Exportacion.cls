public class HE_Costos_Exportacion {
    public string idGE{get;set;}  
    public Guias_de_Exportacion__c  gde{get;set;}
    public HE_Costos_Exportacion(ApexPages.StandardController controller){
        idGE=controller.getId();
        system.debug('idGE'+idGE);
        gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
             Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,Agente__c,ID_de_Destinatario__c,
             ID_Remitente__c,Zona_HOT__c,Embalaje_HOT__c, Tarifa_Cliente__c,Combustible__c,Tarifa_Agente__c,Peso_Agente__c,Peso_Cliente__c,
             Zona_Fedex__c,Zona_DHL__c,Estado__c,ID_Remitente__r.Tarifa_Exportacion__c,Valor_Combustible__c,Valor_Cliente__c
             from Guias_de_Exportacion__c where id=:idGE];     
    }
    
    public PageReference costos_ex(){
        
        
        list<Tarifa__c> tarifa=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                   LastViewedDate, LastReferencedDate, Vigencia_Desde__c, Vigencia_Hasta__c, Tipo_Tarifa__c 
                                   FROM Tarifa__c
                                   where Tipo_Tarifa__c='Exportación'
                                   and id=:gde.ID_Remitente__r.Tarifa_Exportacion__c];
        system.debug('tarifa'+tarifa);
        list<Detalle_Tarifa__c> DT=new  list<Detalle_Tarifa__c>();
        if(tarifa.size()>0){
            DT=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate,
                LastReferencedDate, Tarifa__c, Zona__c,Embalaje__c, Kilos__c, Valor__c
                FROM Detalle_Tarifa__c
                where Tarifa__c=:tarifa[0].id
                and Zona__c=:gde.Zona_HOT__c 
                and Embalaje__c=:gde.Embalaje_HOT__c
                and Kilos__c>=:gde.Peso_Cliente__c 
                order by Kilos__c];
            system.debug('tarifa[0].id'+tarifa[0].id); 
            system.debug('gde.Zona_HOT__c'+gde.Zona_HOT__c); 
            system.debug('gde.Embalaje_HOT__c'+gde.Embalaje_HOT__c); 
            system.debug('gde.Peso_Cliente__c'+gde.Peso_Cliente__c); 
            system.debug('DT'+DT); 
        }
        
        list<Tarifa_Agente__c> tf=[SELECT Tipo_Tarifa__c, Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate
                                   , LastModifiedById, SystemModstamp,
                                   LastActivityDate, LastViewedDate, LastReferencedDate, Agente__c 
                                   FROM Tarifa_Agente__c
                                   where Agente__c=:gde.Agente__c 
                                   and Tipo_Tarifa__c='Exportación' ];
        
        system.debug('tf'+tf);
        list<Detalle_Tarifa_Agente__c> dettage=new list<Detalle_Tarifa_Agente__c>();
        string zona='';
        if(gde.Agente__c=='DHL'){
            zona= gde.Zona_DHL__c;
        }else if(gde.Agente__c=='Fedex'){
            zona= gde.Zona_Fedex__c;
        }else{
            
        }
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
        
            
        
        list<Cobros_Alta_Demanda__mdt> CAD=[SELECT Id, DeveloperName, Label, Kilos__c, Valor__c, Cobros_Dolares__c 
                                            FROM Cobros_Alta_Demanda__mdt WHERE Kilos__c>=:gde.Peso_Cliente__c  order by Kilos__c limit 1];
        system.debug('CAD'+CAD); 
        integer mes_costo=0;
        integer aho_costo=0;
        if(gde.Fecha_de_Envio__c!=null ){
            mes_costo=(gde.Fecha_de_Envio__c).month();
            aho_costo=(gde.Fecha_de_Envio__c).year();
        }else{
            mes_costo=(system.today()).month();
            aho_costo=(system.today()).year();
        }
        list<Porcentaje_Combustible__c> pc=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                               LastViewedDate, LastReferencedDate, Porcentaje_Mensual__c, Fecha_Inicial__c, Mes__c, Ano__c, Periodo__c 
                                               FROM Porcentaje_Combustible__c where Mes__c=:mes_costo and Ano__c=:aho_costo ];
        
        system.debug('pc'+pc); 
        if(pc.size()>0){
            gde.Combustible__c=pc[0].Porcentaje_Mensual__c;
            system.debug('pc[0].Porcentaje_Mensual__c'+pc[0].Porcentaje_Mensual__c); 
        }
        
        if(dettage.size()>0 ){
            if(gde.Tarifa_Agente__c!=dettage[0].id){
                gde.Tarifa_Agente__c=tf.size()>0?dettage[0].id:null; 
                system.debug('gde.Tarifa_Agente__c'+gde.Tarifa_Agente__c); 
                system.debug('dettage[0].'+dettage[0].name); 
            }
        }
        if(DT.size()>0 ){
            if( gde.Tarifa_Cliente__c!=DT[0].id){
                gde.Tarifa_Cliente__c= tarifa.size()>0?DT[0].id:null; 
                system.debug('gde.Tarifa_Cliente__c'+gde.Tarifa_Cliente__c); 
                system.debug('DT[0].'+DT[0].name); 
            }
        }
        system.debug('gde'+gde); 
        update gde;
        system.debug('gde'+gde);
        gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
             Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,Agente__c,ID_de_Destinatario__c,
             ID_Remitente__c,Zona_HOT__c,Embalaje_HOT__c, Tarifa_Cliente__c,Combustible__c,Tarifa_Agente__c,Peso_Agente__c,Peso_Cliente__c,
             Zona_Fedex__c,Zona_DHL__c,Estado__c,ID_Remitente__r.Tarifa_Exportacion__c,Valor_Combustible__c,Valor_Cliente__c
             from Guias_de_Exportacion__c where id=:gde.id]; 
        system.debug('gde'+gde); 
        list<Costo_de_Exportacion__c> cos_ex;
        
        
        list<Costo__c> cos = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Combustible'];
        if(cos.size()>0){
            cos_ex = [SELECT Id, Guias_de_Exportacion__c,Costo__c,Valor__c,Estado__c FROM Costo_de_Exportacion__c  where Costo__c=:cos.get(0).id AND Guias_de_Exportacion__c=:idGE];
            if(cos_ex.size()>0){
                if(cos_ex[0].Estado__c!='Facturado'){
                    cos_ex[0].Valor__c=gde.Valor_Combustible__c;
                    update cos_ex;
                    system.debug('cos_ex'+cos_ex[0].id);
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Combustible actualizado valor: '+gde.Valor_Combustible__c);
                    ApexPages.addMessage(msg);
                }else{
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Combustible se encuentra  facturado no se puede cambiar el valor');
                    ApexPages.addMessage(msg);
                    
                }
                
            }else{
                Costo_de_Exportacion__c cosexp=new Costo_de_Exportacion__c();
                cosexp.Guias_de_Exportacion__c=idGE;
                // cosexp.name='combustible';
                cosexp.Costo__c=cos.get(0).id;
                cosexp.Valor__c=gde.Valor_Combustible__c;
                insert cosexp;
                // system.debug('cos_ex'+cosexp[0].id);
                ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Combustible creado valor: '+gde.Valor_Combustible__c);
                ApexPages.addMessage(msg);
                
            }
        }          
        list<Costo__c> cos1 = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Tarifa Cliente'];
        if(cos1.size()>0){
            cos_ex = [SELECT Id, Guias_de_Exportacion__c,Costo__c,Valor__c,Estado__c FROM Costo_de_Exportacion__c  where Costo__c=:cos1.get(0).id AND Guias_de_Exportacion__c=:idGE];
            if(cos_ex.size()>0){
                if(cos_ex[0].Estado__c!='Facturado'){
                    cos_ex[0].Valor__c=gde.Valor_Cliente__c;
                    update cos_ex;
                    system.debug('cos_ex'+ cos_ex[0].id);
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Tarifa Cliente actualizado valor: '+gde.Valor_Cliente__c);
                    ApexPages.addMessage(msg);
                }else{
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Tarifa Cliente se encuentra  facturado no se puede cambiar el valor ');
                    ApexPages.addMessage(msg);
                    
                }
            }else{
                Costo_de_Exportacion__c cosexp1=new Costo_de_Exportacion__c();
                cosexp1.Guias_de_Exportacion__c=idGE; 
                cosexp1.Costo__c=cos1.get(0).id;
                cosexp1.Valor__c=gde.Valor_Cliente__c;
                insert cosexp1;
                
                ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Tarifa Cliente creado valor: '+gde.Valor_Cliente__c);
                ApexPages.addMessage(msg);
            }
        }
        list<Costo__c> COSCAD = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Costo Alta Demanda'];
        if(COSCAD.size()>0){
            cos_ex = [SELECT Id, Guias_de_Exportacion__c,Costo__c,Valor__c,Estado__c FROM Costo_de_Exportacion__c  where Costo__c=:COSCAD.get(0).id AND Guias_de_Exportacion__c=:idGE];
            if(cos_ex.size()>0){
                if(cos_ex[0].Estado__c!='Facturado'){
                    cos_ex[0].Valor__c=CAD[0].Cobros_Dolares__c;
                    update cos_ex;
                    
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Alta Demanda actualizado valor: '+CAD[0].Cobros_Dolares__c);
                    ApexPages.addMessage(msg);
                }else{
                    ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Alta Demanda se encuentra  facturado no se puede cambiar el valor ');
                    ApexPages.addMessage(msg);
                    
                }
            }else{
                Costo_de_Exportacion__c cosexp1=new Costo_de_Exportacion__c();
                cosexp1.Guias_de_Exportacion__c=idGE; 
                cosexp1.Costo__c=COSCAD.get(0).id;
                cosexp1.Valor__c=CAD[0].Cobros_Dolares__c;
                insert cosexp1;
                
                ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.info,' Costo Alta Demanda creado valor: '+CAD[0].Cobros_Dolares__c);
                ApexPages.addMessage(msg);
            }    
        }
        
        return null;
        
    }
    
    
    public PageReference volver(){
        
        pageReference p = new PageReference('/'+idGE);
        return p; 
    }
    @InvocableMethod
    public static void Actualizar_costos(List<string> IdGuia) {
        System.debug('IdGuia='+IdGuia);
        try{
            Guias_de_Exportacion__c   gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                           Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,Agente__c,ID_de_Destinatario__c,
                                           ID_Remitente__c,Zona_HOT__c,Embalaje_HOT__c, Tarifa_Cliente__c,Combustible__c,Tarifa_Agente__c,Peso_Agente__c,Peso_Cliente__c,
                                           Zona_Fedex__c,Zona_DHL__c,Estado__c,ID_Remitente__r.Tarifa_Exportacion__c,Valor_Combustible__c,Valor_Cliente__c
                                           from Guias_de_Exportacion__c where id=:IdGuia];
            
            system.debug('gde'+gde); 
            
            list<Tarifa__c> tarifa=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                       LastViewedDate, LastReferencedDate, Vigencia_Desde__c, Vigencia_Hasta__c, Tipo_Tarifa__c 
                                       FROM Tarifa__c
                                       where Tipo_Tarifa__c='Exportación'
                                       and id=:gde.ID_Remitente__r.Tarifa_Exportacion__c];
            system.debug('tarifa'+tarifa); 
            list<Detalle_Tarifa__c> DT=new  list<Detalle_Tarifa__c>();
            if(tarifa.size()>0){
                DT=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate, LastViewedDate,
                    LastReferencedDate, Tarifa__c, Zona__c,Embalaje__c, Kilos__c, Valor__c
                    FROM Detalle_Tarifa__c
                    where Tarifa__c=:tarifa[0].id
                    and Zona__c=:gde.Zona_HOT__c 
                    and Embalaje__c=:gde.Embalaje_HOT__c
                    and Kilos__c>=:gde.Peso_Cliente__c 
                    order by Kilos__c];
                
                system.debug('tarifa[0].id'+tarifa[0].id); 
                system.debug('gde.Zona_HOT__c'+gde.Zona_HOT__c); 
                system.debug('gde.Embalaje_HOT__c'+gde.Embalaje_HOT__c); 
                system.debug('gde.Peso_Cliente__c'+gde.Peso_Cliente__c); 
                system.debug('DT'+DT); 
            }
            
            list<Tarifa_Agente__c> tf=[SELECT Tipo_Tarifa__c, Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate
                                       , LastModifiedById, SystemModstamp,
                                       LastActivityDate, LastViewedDate, LastReferencedDate, Agente__c 
                                       FROM Tarifa_Agente__c
                                       where Agente__c=:gde.Agente__c 
                                       and Tipo_Tarifa__c='Exportación' ];
            
            system.debug('tf'+tf);
            list<Detalle_Tarifa_Agente__c> dettage=new list<Detalle_Tarifa_Agente__c>();
            string zona='';
            if(gde.Agente__c=='DHL'){
                zona= gde.Zona_DHL__c;
            }else if(gde.Agente__c=='Fedex'){
                zona= gde.Zona_Fedex__c;
            }else{
                
            }
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
             
             
            list<Cobros_Alta_Demanda__mdt> CAD=[SELECT Id, DeveloperName, Label, Kilos__c, Valor__c, Cobros_Dolares__c 
                                                FROM Cobros_Alta_Demanda__mdt WHERE Kilos__c>=:gde.Peso_Cliente__c  order by Kilos__c limit 1];
            system.debug('CAD'+CAD); 
            integer mes_costo=0;
            integer aho_costo=0;
            if(gde.Fecha_de_Envio__c!=null ){
                mes_costo=(gde.Fecha_de_Envio__c).month();
                aho_costo=(gde.Fecha_de_Envio__c).year();
            }else{
                mes_costo=(system.today()).month();
                aho_costo=(system.today()).year();
            }
            list<Porcentaje_Combustible__c> pc=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                                   LastViewedDate, LastReferencedDate, Porcentaje_Mensual__c, Fecha_Inicial__c, Mes__c, Ano__c, Periodo__c 
                                                   FROM Porcentaje_Combustible__c where Mes__c=:mes_costo and Ano__c=:aho_costo ];
            system.debug('pc'+pc); 
            if(pc.size()>0){
                gde.Combustible__c=pc[0].Porcentaje_Mensual__c;
                system.debug('pc[0].Porcentaje_Mensual__c'+pc[0].Porcentaje_Mensual__c); 
            }
            
            if(dettage.size()>0 ){
                if(gde.Tarifa_Agente__c!=dettage[0].id){
                    gde.Tarifa_Agente__c=tf.size()>0?dettage[0].id:null; 
                    system.debug('gde.Tarifa_Agente__c'+gde.Tarifa_Agente__c); 
                    system.debug('dettage[0].'+dettage[0].name); 
                }
            }
            if(DT.size()>0 ){
                if( gde.Tarifa_Cliente__c!=DT[0].id){
                    gde.Tarifa_Cliente__c= tarifa.size()>0?DT[0].id:null; 
                    system.debug('gde.Tarifa_Cliente__c'+gde.Tarifa_Cliente__c); 
                    system.debug('DT[0].'+DT[0].name); 
                }
            }
            system.debug('gde'+gde); 
            update gde;
            system.debug('gde'+gde);
            
            gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
                 Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,Agente__c,ID_de_Destinatario__c,
                 ID_Remitente__c,Zona_HOT__c,Embalaje_HOT__c, Tarifa_Cliente__c,Combustible__c,Tarifa_Agente__c,Peso_Agente__c,Peso_Cliente__c,
                 Zona_Fedex__c,Zona_DHL__c,Estado__c,ID_Remitente__r.Tarifa_Exportacion__c,Valor_Combustible__c,Valor_Cliente__c
                 from Guias_de_Exportacion__c where id=:gde.id]; 
            system.debug('gde'+gde); 
            list<Costo_de_Exportacion__c> cos_ex;
            
            
            list<Costo__c> cos = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Combustible'];
            if(cos.size()>0){
                cos_ex = [SELECT Id, Guias_de_Exportacion__c,Costo__c,Valor__c,Estado__c FROM Costo_de_Exportacion__c  where Costo__c=:cos.get(0).id AND Guias_de_Exportacion__c=:IdGuia];
                if(cos_ex.size()>0){
                    if(cos_ex[0].Estado__c!='Facturado'){
                        cos_ex[0].Valor__c=gde.Valor_Combustible__c;
                        update cos_ex;
                        system.debug(' Costo Combustible actualizado valor: '+gde.Valor_Combustible__c); 
                    }else{
                        system.debug(' Costo Combustible se encuentra  facturado no se puede cambiar el valor ' );   
                    }
                }else{
                    Costo_de_Exportacion__c cosexp=new Costo_de_Exportacion__c();
                    cosexp.Guias_de_Exportacion__c=IdGuia[0]; 
                    cosexp.Costo__c=cos.get(0).id;
                    cosexp.Valor__c=gde.Valor_Combustible__c;
                    insert cosexp; 
                    system.debug(' Costo Combustible creado valor: '+gde.Valor_Combustible__c); 
                    
                }
            }          
            list<Costo__c> cos1 = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Tarifa Cliente'];
            if(cos1.size()>0){
                cos_ex = [SELECT Id, Guias_de_Exportacion__c,Costo__c,Valor__c,Estado__c FROM Costo_de_Exportacion__c  where Costo__c=:cos1.get(0).id AND Guias_de_Exportacion__c=:IdGuia];
                if(cos_ex.size()>0){
                    if(cos_ex[0].Estado__c!='Facturado'){
                        cos_ex[0].Valor__c=gde.Valor_Cliente__c;
                        update cos_ex;
                        system.debug(' Costo Tarifa Cliente actualizado valor: '+gde.Valor_Cliente__c);
                    }else{
                        system.debug(' Costo Tarifa Cliente se encuentra  facturado no se puede cambiar el valor ' );   
                    }
                }else{
                    Costo_de_Exportacion__c cosexp1=new Costo_de_Exportacion__c();
                    cosexp1.Guias_de_Exportacion__c=IdGuia[0]; 
                    cosexp1.Costo__c=cos1.get(0).id;
                    cosexp1.Valor__c=gde.Valor_Cliente__c;
                    insert cosexp1; 
                    system.debug(' Costo Tarifa Cliente creado valor: '+gde.Valor_Cliente__c);
                    
                }
            }
            list<Costo__c> COSCAD = [SELECT Id, OwnerId, IsDeleted, Name FROM Costo__c where name=:'Costo Alta Demanda'];
            if(COSCAD.size()>0){
                cos_ex = [SELECT Id, Guias_de_Exportacion__c,Costo__c,Valor__c,Estado__c FROM Costo_de_Exportacion__c  where Costo__c=:COSCAD.get(0).id AND Guias_de_Exportacion__c=:IdGuia];
                if(cos_ex.size()>0){
                    if(cos_ex[0].Estado__c!='Facturado'){
                        cos_ex[0].Valor__c=CAD[0].Cobros_Dolares__c;
                        update cos_ex;
                        system.debug(' Costo Alta Demanda actualizado valor: '+CAD[0].Cobros_Dolares__c);
                    }else{
                        system.debug(' Costo Alta Demanda se encuentra  facturado no se puede cambiar el valor ' );   
                    }
                }else{
                    Costo_de_Exportacion__c cosexp1=new Costo_de_Exportacion__c();
                    cosexp1.Guias_de_Exportacion__c=IdGuia[0]; 
                    cosexp1.Costo__c=COSCAD.get(0).id;
                    cosexp1.Valor__c=CAD[0].Cobros_Dolares__c;
                    insert cosexp1;
                    system.debug(' Costo Alta Demanda creado valor: '+CAD[0].Cobros_Dolares__c);
                    
                }    
            }
        }catch(Exception e){
            system.debug('error '+e);
        }
        
    }
    
    
    
}