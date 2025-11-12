public class HE_enviar_paquetes2 {
    public string idGE{get;set;}
    public string zpl2{get;set;}
    public string ZPL2Imagen{get;set;}
    public List<String> urls {get;set;}
    public boolean mostrar{get;set;}
    public List<String> pdfsBase64 { get; set; }
    public Guias_de_Exportacion__c  gde{get;set;}
    
    public HE_enviar_paquetes2(ApexPages.StandardController controller){
        idGE=ApexPages.currentPage().getParameters().get('id');
        //idGE = 'a090v000004jXtfAAE';
        system.debug('idGE'+idGE);
        if (idGE == NULL) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'El ID de la guía no fue proporcionado.');
            ApexPages.addMessage(msg);
            return;
        }
        //idGE = 'a090v000004jXtfAAE';
        system.debug('idGE'+idGE);
        List<Guias_de_Exportacion__c> guias = [SELECT id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
        Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,Agente__c,ID_de_Destinatario__c,
        ID_Remitente__c,Zona_HOT__c,Embalaje_HOT__c, Tarifa_Cliente__c,Combustible__c,Tarifa_Agente__c,Peso_Agente__c,Peso_Cliente__c,
        Zona_Fedex__c,Zona_DHL__c,Estado__c,ID_Remitente__r.Tarifa_Exportacion__c,Valor_Combustible__c
        FROM Guias_de_Exportacion__c 
        WHERE id=:idGE];
        System.debug('Debug guias consulta line::17' + guias);
        if (guias.isEmpty()) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'No se encontró la guía de exportación con el ID proporcionado.');
            ApexPages.addMessage(msg);
            return;
        }
        gde = guias[0];
        System.debug('gde: ' + gde);
    }
    public PageReference  validar_ruta(){
        if (gde == null) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'No se encontró la guía de exportación.');
            ApexPages.addMessage(msg);
            return null;
        }
        
        gde.Peso_Agente__c = gde.Peso_Agente__c == null ? 0 : gde.Peso_Agente__c;
        if(gde.Peso_Agente__c == 0  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar peso agente');
            ApexPages.addMessage(msg);
        }
        
        if((gde.Peso_Agente__c / gde.Paquetes__c)  > 68  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'peso agente maximo 68 kg');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Ancho__c==null  || gde.Largo__c==null || gde.Alto__c==null){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar largo, ancho y alto ');
            ApexPages.addMessage(msg);
            
        }
           
        if(gde.Zona_HOT__c==null  || gde.Zona_HOT__c==''){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar zona hot');
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
        
        if(gde.ID_Remitente__c==null  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar Remitente');
            ApexPages.addMessage(msg);
            
        }
        if(gde.Direccion_Destinatario__c==null   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'falta ingresar Destinatario');
            ApexPages.addMessage(msg);
            
        }
        if(gde.N_de_Guia__c !=null && gde.N_de_Guia__c !=''  ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,'Esta guía de exportación ya fue procesada');
            ApexPages.addMessage(msg);
            
        }
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

    
        system.debug('Agente--------------------------------' + gde.Agente__c);
        list<Tarifa_Agente__c> tf=[SELECT Tipo_Tarifa__c, Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate
                             , LastModifiedById, SystemModstamp,
                             LastActivityDate, LastViewedDate, LastReferencedDate, Agente__c FROM Tarifa_Agente__c
                             where Agente__c=:gde.Agente__c 
                             and Tipo_Tarifa__c='Exportación' ];
        system.debug('aquiiiiii');
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
                                   where Tipo_Tarifa__c='Exportación'
                                   and id=:gde.ID_Remitente__r.Tarifa_Exportacion__c];
        system.debug('tarifa'+tarifa);
        list<Detalle_Tarifa__c> dettar=new list<Detalle_Tarifa__c>();
        if(tarifa.size()>0){
          dettar=[SELECT Id, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp,
                                        LastActivityDate, Tarifa__c,Zona__c, Embalaje__c, Kilos__c, Valor__c 
                                        FROM Detalle_Tarifa__c
                                        where Tarifa__c=:tarifa[0].id
                                        and Zona__c=:gde.Zona_HOT__c 
                                        and Embalaje__c=:gde.Embalaje_HOT__c
                                        and Kilos__c>=:gde.Peso_Cliente__c 
                                        order by Kilos__c ];
        
        system.debug('dettar'+dettar);
        }
        list<Porcentaje_Combustible__c> pc=   [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, LastActivityDate,
                                               LastViewedDate, LastReferencedDate, Porcentaje_Mensual__c, Fecha_Inicial__c, Mes__c, Ano__c, Periodo__c 
                                               FROM Porcentaje_Combustible__c where Mes__c=:(system.today()).month() and Ano__c=:(system.today()).year() ];
        system.debug('pc'+pc);
        
        
        /*if(dettar.size()<=0   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.WARNING,'no se ha encontrado ninguna tarifa cliente para para la zona el peso y el agente ingresado');
            ApexPages.addMessage(msg);
            
        }
        if(dettage.size()<=0   ){
            ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.WARNING,'no se ha encontrado ninguna tarifa agente para para la zona el peso y el agente ingresado');
            ApexPages.addMessage(msg);
            
        }
        if(ApexPages.hasMessages()){
        	return null;
        }
		*/
        
        if(gde.Direccion_Destinatario__c!=null  && gde.ID_Remitente__c!=null){
            
            HE_Consulta_Servicio_DHL.respuesta res=new HE_Consulta_Servicio_DHL.respuesta();
            HE_Fedex_Shipment_Validation_V28.respuesta resfed=new HE_Fedex_Shipment_Validation_V28.respuesta();
            SDR_Shipment_Response response = new SDR_Shipment_Response();
           
            if(gde.Agente__c=='DHL'){
                HE_Consulta_Servicio_DHL  csd=new HE_Consulta_Servicio_DHL();
                if(!test.isRunningTest()){
                    res= csd.Shipment_Validation(idGE);
                }else{
                    HE_Consulta_Servicio_DHL.respuesta res_ejemplo=new HE_Consulta_Servicio_DHL.respuesta();
                    res_ejemplo.idtraking='12312';
                    list<HE_Consulta_Servicio_DHL.base> lb=new  list<HE_Consulta_Servicio_DHL.base>();
                    HE_Consulta_Servicio_DHL.base b=new  HE_Consulta_Servicio_DHL.base();
                    
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
                    list<HE_Consulta_Servicio_DHL.mensaje> m=new  list<HE_Consulta_Servicio_DHL.mensaje>();
                    
                    res_ejemplo.mensaje=m;
                    res_ejemplo.facturabase64='';  
                    res=res_ejemplo;
                }
                
                
                
                
                system.debug('res=='+res);
            }
            else if(gde.Agente__c=='Fedex'){
                //HE_Fedex_Shipment_Validation_V28 csf=new HE_Fedex_Shipment_Validation_V28();
                SDR_ServicioFedexUtils servicio = new SDR_ServicioFedexUtils();    
                
                    if(!test.isRunningTest()){	
                        system.debug('adentro envio fedex');
                        //resfed = csf.HE_Fedex_Shipment_Validation_V28(idGE);
                        response = servicio.llamarServicioShipment('Shipment', SDR_Utils_JSON_Fedex.generarJSONShipment(idGE));
                }
                 else{
                     /*
                    HE_Fedex_Shipment_Validation_V28.respuesta res_ejemplo=new HE_Fedex_Shipment_Validation_V28.respuesta();
                    res_ejemplo.idtraking='12312';
                    list<HE_Fedex_Shipment_Validation_V28.base> lb=new  list<HE_Fedex_Shipment_Validation_V28.base>();
                    HE_Fedex_Shipment_Validation_V28.base b=new  HE_Fedex_Shipment_Validation_V28.base();
                    
                    string zpl2='^XA ';
                    
                    string base65enco=EncodingUtil.base64Encode(blob.valueOf(zpl2));   
                    b.base64blob=blob.valueOf(base65enco);
                    lb.add(b); 
                    res_ejemplo.base=lb;
                    list<HE_Fedex_Shipment_Validation_V28.mensaje> lm=new  list<HE_Fedex_Shipment_Validation_V28.mensaje>();
                     HE_Fedex_Shipment_Validation_V28.mensaje m=new  HE_Fedex_Shipment_Validation_V28.mensaje();
                     m.Severity='WARNING';
                     m.Message='1234124';
                     lm.add(m);
                    res_ejemplo.mensaje=lm;
                    res_ejemplo.facturabase64='';  
                    resfed=res_ejemplo;
					*/
                     HttpResponse test = new HttpResponse();                                 
                     test.setBody('{"transactionId":"006a2789-8c9c-42d8-beda-1950248eadc5","output":{"transactionShipments":[{"alerts":[{"code":"SHIPMENT.SHIPDATESTAMP.INVALID","message":"We are not able to retrieve the message for the warning or error.","alertType":"WARNING","parameterList":[]},{"code":"CUSTOMVALUE.GREATER.THAN.COMMODITYVALUE","message":"We are not able to retrieve the message for the warning or error.","alertType":"WARNING"}],"masterTrackingNumber":"794818789000","serviceType":"FEDEX_INTERNATIONAL_PRIORITY","shipDatestamp":"2025-02-13","serviceName":"FedEx International Priority®","pieceResponses":[{"masterTrackingNumber":"794818789000","trackingNumber":"794818789000","additionalChargesDiscount":0.0,"netRateAmount":1097.82,"netChargeAmount":0.0,"netDiscountAmount":0.0,"packageDocuments":[{"url":"https://wwwtest.fedex.com/document/v1/cache/retrieve/SH,0fa811441fd7686b794818789000_SHIPPING_Z?isLabel=true&autoPrint=false&retrievalMode=THERMAL","contentType":"LABEL","copiesToPrint":1,"docType":"PDF"}],"currency":"USD","customerReferences":[{"customerReferenceType":"CUSTOMER_REFERENCE","value":"REF_78855"},{"customerReferenceType":"DEPARTMENT_NUMBER","value":"DEPT_35587"},{"customerReferenceType":"INVOICE_NUMBER","value":"INV_778457_1"},{"customerReferenceType":"P_O_NUMBER","value":"PO_325144"}],"baseRateAmount":1039.61,"codcollectionAmount":0.0}],"shipmentAdvisoryDetails":{},"completedShipmentDetail":{"usDomestic":false,"carrierCode":"FDXE","masterTrackingId":{"trackingIdType":"FEDEX","formId":"0430","trackingNumber":"794818789000"},"serviceDescription":{"serviceId":"EP1000000300","serviceType":"FEDEX_INTERNATIONAL_PRIORITY","code":"2P","names":[{"type":"long","encoding":"utf-8","value":"FedEx International Priority®"},{"type":"long","encoding":"ascii","value":"FedEx International Priority"},{"type":"medium","encoding":"utf-8","value":"FedEx International Priority"},{"type":"medium","encoding":"ascii","value":"FedEx International Priority"},{"type":"short","encoding":"utf-8","value":"IPED"},{"type":"short","encoding":"ascii","value":"IPED"},{"type":"abbrv","encoding":"ascii","value":"OA"}],"operatingOrgCodes":["FXE"],"serviceCategory":"parcel","description":"International Priority EOD (IP EOD)","astraDescription":"IP EOD"},"packagingDescription":"Customer Packaging","operationalDetail":{"ursaPrefixCode":"3C","ursaSuffixCode":"JDMA ","originLocationId":"SCLA ","originLocationNumber":0,"originServiceArea":"PM","destinationLocationId":"JDMA ","destinationLocationNumber":0,"destinationServiceArea":"A1","destinationLocationStateOrProvinceCode":"FL","deliveryDate":"","deliveryDay":"","commitDate":"","commitDay":"","ineligibleForMoneyBackGuarantee":false,"astraPlannedServiceLevel":"5:00P","astraDescription":"IP EOD","postalCode":"33114","stateOrProvinceCode":"FL","countryCode":"US","airportId":"MIA","serviceCode":"2P","packagingCode":"01","publishedDeliveryTime":"","scac":""},"shipmentRating":{"actualRateType":"PAYOR_ACCOUNT_SHIPMENT","shipmentRateDetails":[{"rateType":"PAYOR_ACCOUNT_SHIPMENT","rateScale":"US001DFL_2P_YOUR_PACKAGING","rateZone":"L","pricingCode":"","ratedWeightMethod":"ACTUAL","currencyExchangeRate":{"fromCurrency":"USD","intoCurrency":"USD","rate":1.0},"dimDivisor":139,"fuelSurchargePercent":5.0,"totalBillingWeight":{"units":"KG","value":20.0},"totalBaseCharge":1039.61,"totalFreightDiscounts":0.0,"totalNetFreight":1039.61,"totalSurcharges":58.21,"totalNetFedExCharge":1097.82,"totalTaxes":0.0,"totalNetCharge":1097.82,"totalRebates":0.0,"totalDutiesAndTaxes":0.0,"totalAncillaryFeesAndTaxes":0.0,"totalDutiesTaxesAndFees":0.0,"totalNetChargeWithDutiesAndTaxes":1097.82,"surcharges":[{"surchargeType":"ANCILLARY_FEE","level":"SHIPMENT","description":"US Inbound Processing Fee","amount":1.5},{"surchargeType":"DEMAND","level":"SHIPMENT","description":"Demand Surcharge","amount":4.5},{"surchargeType":"FUEL","level":"SHIPMENT","description":"Fuel","amount":52.21}],"freightDiscounts":[],"taxes":[],"currency":"USD"}]},"completedPackageDetails":[{"sequenceNumber":1,"trackingIds":[{"trackingIdType":"FEDEX","formId":"0430","trackingNumber":"794818789000"}],"groupNumber":0,"signatureOption":"SERVICE_DEFAULT","operationalDetail":{"barcodes":{"binaryBarcodes":[{"type":"COMMON_2D","value":"Wyk+HjAxHTAyMzMxMTQdODQwHTJQHTc5NDgxODc4OTAwMDA0MzAdRkRFHTc0MDU2MTA3Mx0wNDQdHTEvMR0yMC4wMEtHHU4deHggeHggeHgdTWlhbWkdRkwdRW5yaXF1ZSBNb250YW5vHjA2HTEwWkVJSTA4HTEyWjEyMzQ1Njc4OTAdMTVaMTE0MDY0ODYwHTMxWjEyMjE1NzI4MTE5OTAwMDMzMTE0MDA3OTQ4MTg3ODkwMDAdMzJaMDIdMzlaU0NMQR1LUE9fMzI1MTQ0HTk5WkVJMDAwNhxDTBw1MBxVU0QcUHJvZHVjdG9zIGRlIHBhbmFkZXJhHDUwHDc0MDU2MTA3Mx0eMDkdRkRYHXodOB0yBh0OLwh/QB4E"}],"stringBarcodes":[{"type":"FEDEX_1D","value":"1221572811990003311400794818789000"}]},"astraHandlingText":"","operationalInstructions":[{"number":2,"content":"TRK#"},{"number":3,"content":"0430"},{"number":5,"content":"3C JDMA "},{"number":7,"content":"1221572811990003311400794818789000"},{"number":8,"content":"58CJ4/26DE/C6C4"},{"number":10,"content":"7948 1878 9000"},{"number":12,"content":"5:00P"},{"number":13,"content":"IP EOD"},{"number":15,"content":"33114"},{"number":16,"content":"FL-US"},{"number":17,"content":"MIA"}]}}],"documentRequirements":{"requiredDocuments":["AIR_WAYBILL","COMMERCIAL_OR_PRO_FORMA_INVOICE"],"generationDetails":[{"type":"PRO_FORMA_INVOICE","minimumCopiesRequired":3,"letterhead":"OPTIONAL","electronicSignature":"OPTIONAL"},{"type":"AIR_WAYBILL","minimumCopiesRequired":3},{"type":"COMMERCIAL_INVOICE","minimumCopiesRequired":3,"letterhead":"OPTIONAL","electronicSignature":"OPTIONAL"}],"prohibitedDocuments":["USMCA_COMMERCIAL_INVOICE_CERTIFICATION_OF_ORIGIN","USMCA_CERTIFICATION_OF_ORIGIN"]}},"serviceCategory":"EXPRESS"}]}}');
                     response = SDR_Shipment_Response.parse(test.getBody());   
            	}         
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
                    if(ApexPages.hasMessages(ApexPages.Severity.Error) ){
                        mostrar=false;
                        return null;  
                    }
                }
                gde.Fecha_de_Envio__c=system.today();
                gde.N_de_Guia__c=res.idtraking;
                gde.Estado__c='Despachado';
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
                
                system.debug('response: ' + response);

                // CODIGO NUEVO PARA VALIDAR QUE LOS DATOS NO VENGAN NULL O VACIOS
                if (response != NULL || response.output != null ||
                    response.output.transactionShipments != null || 
                    !response.output.transactionShipments.isEmpty() || 
                    response.output.transactionShipments[0].alerts != NULL )
                {
                    if (response.output != null)
                    {
                         if (response.output.transactionShipments != null)
                        {
                            if (response.output.transactionShipments[0].alerts != NULL)
                            {
                                system.debug('response.output.transactionShipments[0].alerts: '+response.output.transactionShipments[0].alerts);
                                if (response.output.transactionShipments[0].alerts.size() > 0) {
                                    for (SDR_Shipment_Response.cls_alerts d : response.output.transactionShipments[0].alerts) {
                                        system.debug('d: ' + d);
                                        if (d.alertType != 'WARNING' && d.alertType != 'SUCCESS') {
                                            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, d.Message);
                                            ApexPages.addMessage(msg);
                                        }
                                    }
                                    if (ApexPages.hasMessages(ApexPages.Severity.Error)) {
                                        system.debug('Tiene errores');
                                        return null;
                                    }
                                }
                            }    
                        }                          
                    }
                    else if (response.errors != null)
                    {
                        //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, response.errors[0].code + ' - ' response.errors[0].message);
                        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, response.errors[0].code + ' - ' + response.errors[0].message);
                        ApexPages.addMessage(msg);
                    }
                }
                // FIN BLOQUE DE CODIGO NUEVO


                // CODIGO COMENTADO POR S.A - 15:04
                // if(response.output.transactionShipments[0].alerts != null){
                //     system.debug('adentro if alerts != null');
                // }else{
                //     system.debug('adentro if alerts == null');
                // }
                // if(response.output.transactionShipments[0].alerts != null){                                    
                //     if(response.output.transactionShipments[0].alerts.size()>0){
                //         for(SDR_Shipment_Response.cls_alerts  d : response.output.transactionShipments[0].alerts){
                //             system.debug('d: '+d);
                //             if(d.alertType!='WARNING' && d.alertType!='SUCCESS'){
                //                 ApexPages.Message msg=new ApexPages.Message(ApexPages.Severity.Error,d.Message);
                //                 ApexPages.addMessage(msg);
                //             }
                //         }
                //         if(ApexPages.hasMessages(ApexPages.Severity.Error)){
                //             system.debug('Tiene errores');
                //             return null;  
                //         }
                        
                //     }
                // }
                // FIN CODIGO COMENTADO POR S.A - 15:04
                
                gde.Fecha_de_Envio__c= system.today();
                gde.Estado__c='Despachado';
                
                //string d=json.serialize(resfed);
                //url=url+d;
                //url=url+'&&factura='+resfed.facturabase64;                                                 
                urls = new List<String>();
                try
                {
                    gde.N_de_Guia__c = response.output.transactionShipments[0].masterTrackingNumber;
                    
                    String varUrl = '';
                    for(Integer cont = 0; cont <= response.output.transactionShipments[0].pieceResponses.size() - 1; cont ++)
                    {
                        varUrl = response.output.transactionShipments[0].pieceResponses[cont].packageDocuments[0].url;
                        urls.add(varUrl);
                    }
                    url = response.output.transactionShipments[0].pieceResponses[0].packageDocuments[0].url;
                    
                    // NUEVA FUNCIONALIDAD PARA OBTENER PDF Y GUARDARLO COMO ADJUNTO
                    if(!Test.isRunningTest()) {
                        // Descargar cada PDF individualmente
                        for (Integer cont = 0; cont < urls.size(); cont++) {
                            String urlArchivo = urls[cont];
                            String nombreArchivo = 'Etiqueta_FedEx_Paquete_' + (cont + 1) + '_' + gde.N_de_Guia__c + '.pdf';
                            
                            // Llamar al método @future para guardar el archivo como adjunto
                            HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarYAdjuntarArchivo(gde.Id, nombreArchivo, urlArchivo);
                        }
                        System.debug('Se han iniciado las descargas de PDFs para la guía: ' + gde.N_de_Guia__c);
                    }
                    
                    //url = response.output.transactionShipments[0].pieceResponses[0].packageDocuments[0].url;
                }
                catch(exception ex)
                {
                    system.debug('err ' + ex.getmessage());
                    url = '';
                }
                
            }
            if(dettar.size()>0){
             	gde.Tarifa_Cliente__c=dettar.get(0).id;   
            }
            
            if(pc.size()>0){
            	gde.Combustible__c=pc[0].Porcentaje_Mensual__c;
            }
            if(dettage.size()>0){
            	gde.Tarifa_Agente__c=dettage.get(0).id;
            }
            //Ya no valida tarifa 2-nov-2022
            //if(!test.isRunningTest() &&(dettage.size()>0 || dettar.size()>0)){
            if(!test.isRunningTest()){
            	update  gde;
            }
            else{
                system.debug('Valor. dettage' + dettage.size());
                system.debug('Valor. dettar' + dettar.size());
                system.debug('No se actualiza tracking. dettage');
            }
                       
            if(gde.Agente__c=='Fedex')
            {
                if (url != '')
                {
                    getUrlsJS();
                    
                    return null;
                    /*
                    system.debug('url='+url);
                	pageReference p = new PageReference(url); 
                	return p;
                    
                    PageReference p = new PageReference('/' + idGE);
					p.setRedirect(true);
                	return p;*/
                    
                }
                else
                {
                    return null;
                }
            }else if(gde.Agente__c=='DHL'){
                return null;   
            }else{
                return null;
            }
        }
        else{
            system.debug('debe ingresar  destinatario y remitente ');
            return null;
        }
    }
    public pagereference volverGuia()
    {
        return new PageReference('/' + idGE);
    }
    public string getUrlsJS()
    {
        system.debug('urls='+urls);
        return JSON.serialize(urls);
    }
    
    public PageReference  consultarZPL(){
        HE_Servicios  h=new HE_Servicios();
        string str=h.callOutconsultaZPL(zpl2);
        ZPL2Imagen=str;
        system.debug('PDF DHL'+str);
        
        if(Test.isRunningTest() == false)
        {
        	//Roberto Quiroz 27/07 crea adjunto relacionado a guia
        	HE_AttachmentGuides.saveAttachment(gde.id, str, 'Etiquetas - ' + gde.N_de_Guia__c + '.pdf');    
        }
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