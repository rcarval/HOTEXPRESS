public class HE_AdmicionCEP_envia_a_correos {
    public string idmaster {get;set;}
    public string inicio {get;set;}
    public string fin {get;set;}
    public string totalenvios {get;set;}
    public  HE_AdmicionCEP_envia_a_correos(ApexPages.StandardController  Controller) {
        idmaster=ApexPages.currentPage().getParameters().get('id');
        inicio=ApexPages.currentPage().getParameters().get('in');
        fin=ApexPages.currentPage().getParameters().get('fn'); 
       // idmaster='a040v000002SChh';
        system.debug('idmaster'+idmaster);
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
        if(inicio==null){
            system.debug('entro por aca');
            inicio='0';  
        }
        if(fin==null){
            system.debug('entro por aca 2');
            fin='50';        
        }
        system.debug('idmaster'+idmaster);
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
        
    }
    public PageReference enviar_a_correos(){
        integer contador =0;
        system.debug('entro a normalizacion');
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
        EndPoint__mdt ep=[SELECT Id, usuario__c, contrase_a__c, Codigo_Cliente__c, Label FROM EndPoint__mdt where Label='normalizacion' limit 1 ];
        
        Master__c   mt=[select Id, Name, Fecha_Recepcion__c, Estado__c, N_Manifiesto_Aduana__c, Cuenta__c, Total_Valor__c, Total_Peso__c, Total_Piezas__c,
                        Aeropuerto_Origen__c, Aeropuerto_Destino__c, N_Vuelo__c, Total_Cajas__c, Master_AirwayBill__c, Fecha_Vuelo__c
                        from Master__c  where id=:idmaster];
        
        list<Detalles_Master__c> detmast=[select Id, Name, Master__c, Order_Number__c, Type_of_Mail__c, Vendedor__c, Shipper_Address__c, Shipper_Town__c, Consignatario__c, 
                                          Direccion_Consignatario__c, Comuna__c, Postal_Code__c, Consignee_Phone__c, Pieces__c, Peso__c, Valor__c, Puerto_de_Destino__c,Rut_Consignatario__c,
                                          Destination_Generic_Postal_Code__c, Client_Code__c, HD_PUDO__c, Undelivered_Parcels__c, Postal_Services__c, Descripcion__c,Direccion_Normalizada__c,
                                          Nombre_Cod_Arancelario__c, Estado_Guia__c, Cod_Arancelario__c, Factor_Peso__c, Factor_Pieces__c, Tarifa_Guia__c, Bag_Code__c ,Consignee_Email__c
                                          FROM Detalles_Master__c WHERE Master__c=:idmaster and Direccion_Normalizada__c=true order  by id];
        string  usuario =ep.usuario__c;
        string contrasena =ep.contrase_a__c;
        // string contrasena ='b9d591ae8ef9d36bb7d4';
        string id='1';
        
        system.debug('detmast'+detmast.size());  
        
        for(integer i=integer.valueOf(inicio);i<integer.valueOf(fin);i++){
            if(detmast.get(i).Direccion_Normalizada__c==true){
                admicionCEP.AdmisionTO admisionTo =new admicionCEP.AdmisionTO();
                
                admisionTo.CodigoAdmision=detmast.get(i).name;
                admisionTo.ClienteRemitente=ep.Codigo_Cliente__c;
                admisionTo.CentroRemitente='';
                admisionTo.NombreRemitente=detmast.get(i).Vendedor__c;
                admisionTo.DireccionRemitente=detmast.get(i).Shipper_Address__c;
                admisionTo.PaisRemitente='056';
                admisionTo.CodigoPostalRemitente='';
                admisionTo.ComunaRemitente=detmast.get(i).Shipper_Town__c;
                admisionTo.RutRemitente='';
                admisionTo.PersonaContactoRemitente=detmast.get(i).Vendedor__c;
                admisionTo.TelefonoContactoRemitente='0';
                admisionTo.ClienteDestinatario='';
                admisionTo.CentroDestinatario='';
                admisionTo.NombreDestinatario=detmast.get(i).Consignatario__c;
                admisionTo.DireccionDestinatario=detmast.get(i).Direccion_Consignatario__c;
                admisionTo.PaisDestinatario='056';
                admisionTo.CodigoPostalDestinatario=detmast.get(i).Postal_Code__c;
                admisionTo.ComunaDestinatario=detmast.get(i).Comuna__c;
                admisionTo.RutDestinatario=detmast.get(i).Rut_Consignatario__c;
                admisionTo.PersonaContactoDestinatario=detmast.get(i).Consignatario__c;
                admisionTo.TelefonoContactoDestinatario=detmast.get(i).Consignee_Phone__c;
                admisionTo.CodigoServicio='24';
                admisionTo.NumeroTotalPiezas=integer.valueOf(detmast.get(i).Pieces__c);
                admisionTo.Kilos=detmast.get(i).Peso__c;
                admisionTo.Volumen=0;
                admisionTo.NumeroReferencia=detmast.get(i).name;
                admisionTo.ImporteReembolso=0;
                admisionTo.ImporteValorDeclarado=0;
                admisionTo.TipoPortes='p';
                admisionTo.Observaciones='';
                admisionTo.Observaciones2='';
                admisionTo.EmailDestino=detmast.get(i).Consignee_Email__c;
                admisionTo.TipoMercancia=detmast.get(i).Descripcion__c;
                admisionTo.DevolucionConforme='N';
                admisionTo.NumeroDocumentos=0;
                admisionTo.PagoSeguro='N';
                admicionCEP.ServicioExternoAdmisionCEPSoap   lisadm =new   admicionCEP.ServicioExternoAdmisionCEPSoap();
                admicionCEP.RespuestaAdmisionTO   lisresp =new   admicionCEP.RespuestaAdmisionTO();
                
                try{
                    system.debug('admisionTo=='+admisionTo);
                    if(!test.isRunningTest()){
                         lisresp=lisadm.admitirEnvio( usuario, contrasena, admisionTo);
                    }else{
                        lisresp.NumeroEnvio=detmast.get(i).name;
                    }
                    
                    system.debug('CodigoSucursal=='+lisresp.CodigoSucursal);
                    system.debug('NombreSucursal=='+lisresp.NombreSucursal);
                    system.debug('Cuartel=='+lisresp.Cuartel);
                    system.debug('Sector=='+lisresp.Sector);
                    system.debug('SDP=='+lisresp.SDP);
                    system.debug('Movil=='+lisresp.Movil);
                    system.debug('AbreviaturaCentro=='+lisresp.AbreviaturaCentro);
                    system.debug('CodigoDelegacionDestino=='+lisresp.CodigoDelegacionDestino);
                    system.debug('NombreDelegacionDestino=='+lisresp.NombreDelegacionDestino);
                    system.debug('DireccionDestino=='+lisresp.DireccionDestino);
                    system.debug('CodigoEncaminamiento=='+lisresp.CodigoEncaminamiento);
                    system.debug('GrabarEnvio=='+lisresp.GrabarEnvio);
                    system.debug('NumeroEnvio=='+lisresp.NumeroEnvio);
                    system.debug('ComunaDestino=='+lisresp.ComunaDestino);
                    system.debug('AbreviaturaServicio=='+lisresp.AbreviaturaServicio);
                    system.debug('IdTransaccional=='+lisresp.IdTransaccional);
                    system.debug('CodigoAdmision=='+lisresp.CodigoAdmision);
                    detmast.get(i).Shipment_Code__c=lisresp.NumeroEnvio;
                    detmast.get(i).Enviado_a_Correo__c=true;
                    contador++;
                }catch(Exception e){
                    system.debug('e'+e);
                }
                system.debug('contador'+contador);
            }
        }
        if(contador>0){
            update detmast;
        }
        
        if(integer.valueOf(fin)<detmast.size()){
            integer total=detmast.size();
            integer i=integer.valueOf(fin)+1;
            integer f=integer.valueOf(fin)+50;
            system.debug('total'+total);
            system.debug('i'+i);
            system.debug('f'+f);
            if(f>total){
                f=f-(f-total);
            }
            string url='/apex/HE_AdmicionCEP_envia_a_correos?id='+idmaster+'&&in='+i+'&&fn='+f;
            system.debug('url'+url);
            inicio=string.valueOf(i);
            fin=string.valueOf(f);
            pageReference p = new PageReference(url);
            p.setRedirect(true);
            return  p;
        }else{
            
            detmast=[select Id, Name, Master__c, Order_Number__c, Type_of_Mail__c, Vendedor__c, Shipper_Address__c, Shipper_Town__c, Consignatario__c, 
                     Direccion_Consignatario__c, Comuna__c, Postal_Code__c, Consignee_Phone__c, Pieces__c, Peso__c, Valor__c, Puerto_de_Destino__c,
                     Destination_Generic_Postal_Code__c, Client_Code__c, HD_PUDO__c, Undelivered_Parcels__c, Postal_Services__c, Descripcion__c,Direccion_Normalizada__c,
                     Nombre_Cod_Arancelario__c, Estado_Guia__c, Cod_Arancelario__c, Factor_Peso__c, Factor_Pieces__c, Tarifa_Guia__c, Bag_Code__c 
                     FROM Detalles_Master__c WHERE id='a050v000002dS9O'/*Master__c=:idmaster*/and Enviado_a_Correo__c=false order by id];  
            
            for(integer j=0;j<detmast.size();j++){ 
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ' guias no normalizada '+ detmast.get(j).Name + 'direccion incorrecta'+ detmast.get(j).Direccion_Consignatario__c );
                ApexPages.addMessage(msg);
                
                
            }
            if(detmast.size()==0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Todas guias han sido cargadas. ' );
                ApexPages.addMessage(msg);
            }
        }
        
        return null;
    }
    
    
    
    public PageReference genera_CSV_Correos(){
        
        system.debug('entro a normalizacion');
        system.debug('inicio'+inicio);
        system.debug('fin'+fin);
          system.debug('idmaster'+idmaster);
        
        
        Master__c   mt=[select Id, Name, Fecha_Recepcion__c, Estado__c, N_Manifiesto_Aduana__c, Cuenta__c, Total_Valor__c, Total_Peso__c, Total_Piezas__c,
                        Aeropuerto_Origen__c, Aeropuerto_Destino__c, N_Vuelo__c, Total_Cajas__c, Master_AirwayBill__c, Fecha_Vuelo__c
                        from Master__c  where id=:idmaster];
        system.debug('mt'+mt);
        list<Detalles_Master__c> detmast=[select Id, Name, Master__c, Order_Number__c, Type_of_Mail__c, Vendedor__c, Shipper_Address__c, Shipper_Town__c, Consignatario__c, 
                                          Direccion_Consignatario__c, Comuna__c, Postal_Code__c, Consignee_Phone__c, Pieces__c, Peso__c, Valor__c, Puerto_de_Destino__c,Rut_Consignatario__c,
                                          Destination_Generic_Postal_Code__c, Client_Code__c, HD_PUDO__c, Undelivered_Parcels__c, Postal_Services__c, Descripcion__c,Direccion_Normalizada__c,
                                          Nombre_Cod_Arancelario__c, Estado_Guia__c, Cod_Arancelario__c, Factor_Peso__c, Factor_Pieces__c, Tarifa_Guia__c, Bag_Code__c ,Consignee_Email__c,Master__r.Name
                                          FROM Detalles_Master__c WHERE  Master__c=:idmaster and Direccion_Normalizada__c=true order  by id];
        system.debug('detmast'+detmast);
        string header= 'Referencia;Nombre;Dirección;ComunaDestinataTTTio;Pais;Producto;Porte;Bultos;Contenido;Valor;Peso;Volumen;Direccion Remitente;ComunaTTTemitente;ObseTTTvaciones;FactuTTTa;Telefono;Mail'+'\n';
        string finalstr =header;
        for(Detalles_Master__c dt: detmast){    
            
            string Referencia=dt.name;
            string Nombre=dt.Consignatario__c;
            string Direccion=dt.Direccion_Consignatario__c;
            string ComunaDestinataTTTio=dt.Comuna__c;
            string Pais='56';
            string Producto='24';
            string Porte='p';
            string Bultos='1';//string.valueOf(dt.Pieces__c);
            string Contenido=dt.Descripcion__c;
            string Valor=string.valueOf(dt.Valor__c);
            string Peso=string.valueOf(dt.Peso__c);
            string Volumen='1'; 
            string Direccion_Remitente=dt.Shipper_Address__c;
            string ComunaTTTemitente=dt.Shipper_Town__c;
            string ObseTTTvaciones='0';
            string FactuTTTa='0';
            string Telefono=dt.Consignee_Phone__c;
            string Mail=dt.Consignee_Email__c;
            
            
            string recordString = Referencia+';'+Nombre+';'+Direccion+';'+ComunaDestinataTTTio+';'+Pais+';'+Producto+';'+Porte+';'+Bultos+';'+Contenido+';'+Valor+';'+Peso+';'+Volumen+';'+Direccion_Remitente+';'+ComunaTTTemitente+';'+ObseTTTvaciones+';'+FactuTTTa+';'+Telefono+';'+Mail+'\n';  
            finalstr = finalstr +recordString;
        }   
        blob csvBlob = Blob.valueOf(finalstr);
        Attachment csv=new Attachment();
        csv.Body=csvBlob;
        csv.ParentId=mt.id;
        csv.Name='correos_de_chile.csv';
        insert csv;
        
        
        pageReference p = new PageReference('/'+mt.id);
        return p; 
        
        
    }
    public PageReference redirecion(){
        list<Detalles_Master__c> detmast=[select Id  FROM Detalles_Master__c WHERE  Master__c=:idmaster and Direccion_Normalizada__c=true order by id];
        totalenvios=string.valueOf(detmast.size());
        if(detmast.size()<integer.valueOf(fin)){
            fin=string.valueOf(detmast.size());
        }
        return null;
    }
    
    
    
}