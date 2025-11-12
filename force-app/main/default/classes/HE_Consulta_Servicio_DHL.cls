public class HE_Consulta_Servicio_DHL {
    public string dato1{get;set;}
    public string base64{get;set;}
    public string ActionStatus{get;set;}
    public string ConditionCode{get;set;}
    public string ConditionData{get;set;} 
    public string fecha_traking{get;set;}
    public string estado{get;set;} 
    public string costo{get;set;} 
    public string dutiable {get;set;} 
    Address address = new Address();
    
    public respuesta Shipment_Validation(string idexp){
        //idexp='a0J0v000002gw3HEAQ';
        Guias_de_Exportacion__c  gde=[select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                      Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,
                                      Peso_Agente__c,Contacto__r.name,Contacto__r.email,Telefono__c,Calle__c,Ciudad__c,Pais__c,DDP__c,Otro_Remitente__c,
                                      Shipper_Original__c,ID_Remitente__r.BillingStreet,ID_Remitente__r.BillingCity,ID_Remitente__r.name,ID_Remitente__r.BillingCountry,
                                      Tipo_Contenido__c,Valor_Total_del_Contenido__c, Breve_Descripcion__c, Envio_Particular_a_Particular__c, Direccion_Contacto__c,Seguro__c
                                      from Guias_de_Exportacion__c where id=:idexp];
        
        Direcciones__c dir_org;
        if(gde.Otro_Remitente__c!=null){
            dir_org=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                     LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                     Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Otro_Remitente__c];
        } 
        
        Direcciones__c dir=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Destinatario__c];
        Account acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
                     OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c 
                     FROM Account 
                     WHERE Nombre_Fantasia__c =: 'Hot Express'];
        list<Contact> cont=[SELECT Id, AccountId, Name, MailingAddress, Email,Phone, MobilePhone, OwnerId, Tipo_Cargo__c, Aprobador_Final__c 
                            FROM Contact where AccountId=:acc.id];
        
        Contacto_HotExpress__mdt contacto_hotexpress = [SELECT Name__c, Email__c, Phone__c FROM Contacto_HotExpress__mdt WHERE MasterLabel =: 'ContactoPrincipal' LIMIT 1];
        
        EndPoint_DHL__mdt  dhl=[SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName,
                                SiteID__c, Password__c, ShipperAccountNumber__c, ShipperAccountNumberDDP__c, tel_fono_contacto__c,
                                nombre_contacto__c, servicio__c, EndPoint__c 
                                FROM EndPoint_DHL__mdt 
                                where QualifiedApiName=:'servicio_dhl' and servicio__c=:'Shipment_Validation'  ];
        
        List<Contenido_Envio__c> shipmentContentList = [SELECT Id, Name, Descripcion__c, Total__c, Cantidad__c, Valor_Unitario__c, Unidad_de_Medida__c, Pais_fab__c
                                                        FROM Contenido_Envio__c WHERE Contenido_Envio__c.Pickup__c =: gde.Id];
        
        system.debug('dhl'+dhl);
        datetime fecha=system.now();
        string f1=fecha.format('yyyy-MM-dd');
        system.debug('fecha'+fecha);
        system.debug('f1'+f1);
        system.debug('Guias_de_Exportacion__c'+gde);
        system.debug('Direcciones__c'+dir);
        string tipo=''; 
        string tipoproducto='';
        dutiable = 'Y';
        if(gde.Tipo_Contenido__c=='Mercancías' || gde.Tipo_Contenido__c=='Mercancias' || gde.Tipo_Contenido__c == 'Muestra' || gde.Tipo_Contenido__c=='Otros'){
            tipo='PA'; 
            tipoproducto='P';
        }else if(gde.Tipo_Contenido__c=='Documentos'){
            tipo='DC';  
            tipoproducto='D';
            dutiable = 'N';
        }
        
        boolean d = true; 
        string xml ='<?xml version="1.0" encoding="UTF-8"?>'+
            '<req:ShipmentRequest xsi:schemaLocation="http://www.dhl.com ship-val-global-req.xsd" schemaVersion="10.0" xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">'+
            '<Request>'+
                '<ServiceHeader>'+
                    '<MessageTime>2020-01-07T11:30:04-00:00</MessageTime>'+
                    '<MessageReference>BookPickupGL_AP______________</MessageReference>'+
                    '<SiteID>'+dhl.SiteID__c+'</SiteID>'+
                    '<Password>'+dhl.Password__c+'</Password>'+
                '</ServiceHeader>'+        
                '<MetaData>' + 
                	'<SoftwareName>test</SoftwareName>' +
                	'<SoftwareVersion>10.0</SoftwareVersion>' +
                '</MetaData>'+
            '</Request>'+
            '<RegionCode>AM</RegionCode>'+
			'<LanguageCode>ES</LanguageCode>' +
			'<LatinResponseInd>Y</LatinResponseInd>'+
            '<Billing>';            
        
                    if(gde.DDP__c == true){
                        xml += '<ShipperAccountNumber>'+ dhl.ShipperAccountNumber__c+'</ShipperAccountNumber>';
                        xml += '<ShippingPaymentType>R</ShippingPaymentType>';
                        xml += '<BillingAccountNumber>' + dhl.ShipperAccountNumber__c + '</BillingAccountNumber>';
                        xml += '<DutyAccountNumber>' + dhl.ShipperAccountNumberDDP__c + '</DutyAccountNumber>';
                    }else{
                        xml += '<ShipperAccountNumber>'+ dhl.ShipperAccountNumber__c+'</ShipperAccountNumber>';                        
                        xml += '<ShippingPaymentType>S</ShippingPaymentType>'; 
                        xml += '<BillingAccountNumber>'+ dhl.ShipperAccountNumber__c+'</BillingAccountNumber>';
                    }
                 
        string ensurance = '<SpecialService>'+
                           		'<SpecialServiceType>II</SpecialServiceType>'+
                           		'<SpecialServiceDesc>Protection</SpecialServiceDesc>'+
                           		'<ChargeValue>' + gde.Valor_Total_del_Contenido__c  + '</ChargeValue>'+
                           		'<CurrencyCode>USD</CurrencyCode>' + 
            			   '</SpecialService>';
        string ddp = '<SpecialService>'+
                		'<SpecialServiceType>D</SpecialServiceType>'+
                   '</SpecialService>';
        
        address = GetPartitionAddress(gde.Calle__c);                
        xml += '</Billing> '+
            
            '<Consignee>'+         
            	'<CompanyName>' + (gde.Envio_Particular_a_Particular__c == true ? gde.Contacto_Destinatario__c : dir.Name) + '</CompanyName>'+  
                //'<CompanyName>'+ dir.Name +'</CompanyName>'+            
                (address.address1 != null ? address.address1 : '')+
                (address.address2 != null ? address.address2 : '') +
                (address.address3 != null ? address.address3 : '') +
                '<City>'+ gde.Ciudad__c +'</City>'+                        
                '<PostalCode>'+ dir.Codigo_Postal__c +'</PostalCode>'+
                '<CountryCode>'+ dir.Cod_Pais__c +'</CountryCode>'+
                '<CountryName>'+ gde.Pais__c +'</CountryName>'+
                '<Contact>'+
                    '<PersonName>'+ gde.Contacto_Destinatario__c +'</PersonName>'+
                    '<PhoneNumber>'+ gde.Telefono_Destinatario__c +'</PhoneNumber>'+
                    //'<Email>'+ gde.Correo_Electronico__c+ '</Email>'+
                    (gde.Correo_Electronico__c == null ? '' : '<Email>'+ gde.Correo_Electronico__c+ '</Email>') +
                    '<MobilePhoneNumber>'+ gde.Telefono_Destinatario__c +'</MobilePhoneNumber>'+
                '</Contact>'+
            '</Consignee>'+
            
            '<Dutiable>'+
                '<DeclaredValue>'+ gde.Valor_Total_del_Contenido__c+ '</DeclaredValue>' +
                '<DeclaredCurrency>USD</DeclaredCurrency>'+// campo divisa '+gde.Divisa__c+' 
            	'<ShipperEIN>ShipperEIN12021</ShipperEIN>' +
				'<TermsOfTrade>'+ (gde.DDP__c == true ? 'DDP' : 'DAP') +'</TermsOfTrade>' +
            '</Dutiable>'+   
            
            ExportDeclarationSection(shipmentContentList) +
            
            '<ShipmentDetails>'+                
                '<Pieces>';       
                    for(integer i=0; i < gde.Paquetes__c; i++){
                        decimal peso = (gde.Peso_Agente__c/gde.Paquetes__c).setScale(2);
                      xml += '<Piece>'+
                                '<PieceID>'+ (i+1) +'</PieceID>'+
                                '<PackageType>'+ tipo + '</PackageType>' +
                                '<Weight>'+ peso +'</Weight>'+//campo '+gde.Peso_Total__c+'                            
                                '<Width>'+ integer.valueOf(gde.Ancho__c) + '</Width>'+
                                '<Height>'+ integer.valueOf(gde.Alto__c) + '</Height>'+
                                '<Depth>'+ integer.valueOf(gde.Largo__c) + '</Depth>'+
                          	'</Piece>';
                    }
            xml += '</Pieces>'+
                '<WeightUnit>K</WeightUnit>'+
                '<GlobalProductCode>'+ tipoproducto +'</GlobalProductCode>' +
                '<LocalProductCode>'+ tipoproducto +'</LocalProductCode>' +
                '<Date>'+ system.now().format('yyyy-MM-dd') + '</Date>' +
                '<Contents>'+ gde.Breve_Descripcion__c + '</Contents>' +                
                '<DimensionUnit>C</DimensionUnit>' +               
                '<PackageType>' + tipo + '</PackageType>' +
                '<IsDutiable>' + dutiable +  '</IsDutiable>' +
                '<CurrencyCode>USD</CurrencyCode>' +
            '</ShipmentDetails>';
        
        if(gde.Shipper_Original__c == true){
            if(gde.Otro_Remitente__c == null){
                
                //Direccion del remitente
                address = GetPartitionAddress(gde.Direccion_Contacto__c);
                
                xml +='<Shipper>'+
                        '<ShipperID>' + gde.name + '</ShipperID>'+
                        '<CompanyName>' + (gde.Envio_Particular_a_Particular__c == true ? gde.Contacto__r.name : gde.ID_Remitente__r.name) + '</CompanyName>'+                        
                        '<RegisteredAccount></RegisteredAccount>'+
                        (address.address1 != null ? address.address1 : '')+
                        (address.address2 != null ? address.address2 : '') +
                        (address.address3 != null ? address.address3 : '') +
                        '<City>'+ gde.ID_Remitente__r.BillingCity +'</City>'+
                        '<Division></Division>'+
                        '<DivisionCode></DivisionCode>'+
                        
                        // '<PostalCode></PostalCode>'+
                        //FFC - Ticket 00019909
                        '<PostalCode>9020000</PostalCode>'+

                        '<CountryCode>CL</CountryCode>'+
                        '<CountryName>' + gde.ID_Remitente__r.BillingCountry + '</CountryName>'+
                        '<Contact>' +
                        '<PersonName>'+ gde.Contacto__r.name + '</PersonName>'+
                        '<PhoneNumber>'+ gde.Telefono__c +'</PhoneNumber>'+
                        //'<Email>'+ gde.Contacto__r.Email +'</Email>'+
                        (gde.Contacto__r.Email == null ? '' : '<Email>'+ gde.Contacto__r.Email +'</Email>') + 
                        '</Contact>'+
                    '</Shipper>';
            }else{
                address = GetPartitionAddress(dir_org.Direccion__c);
                
                xml = xml + '<Shipper>'+
                    '<ShipperID>'+ gde.name + '</ShipperID>'+
                    '<CompanyName>' + (gde.Envio_Particular_a_Particular__c == true ? gde.Contacto__r.name : gde.ID_Remitente__r.name) + '</CompanyName>'+
                    '<RegisteredAccount></RegisteredAccount>'+
                    (address.address1 != null ? address.address1 : '')+
                	(address.address2 != null ? address.address2 : '') +
                	(address.address3 != null ? address.address3 : '') +
                    '<City>' + dir_org.Ciudad__c + '</City>'+
                    '<Division></Division>'+
                    '<DivisionCode></DivisionCode>';

                    //FFC - Ticket 00019909
                    if (dir_org.Codigo_Postal__c != null)
                        xml = xml + '<PostalCode>' + dir_org.Codigo_Postal__c + '</PostalCode>';
                    else
                        xml = xml + '<PostalCode>9020000</PostalCode>';

                    xml = xml + 
                    '<CountryCode>CL</CountryCode>'+
                    '<CountryName>' + gde.ID_Remitente__r.BillingCountry + '</CountryName>'+
                    '<Contact>'+
                        '<PersonName>' + gde.Contacto__r.name + '</PersonName>'+
                        '<PhoneNumber>' + gde.Telefono__c + '</PhoneNumber>'+
                        (gde.Contacto__r.Email == null ? '' : '<Email>' + gde.Contacto__r.Email + '</Email>')+
                    '</Contact>'+
                    '</Shipper>';
            }
        }else{
            
            //Direccion de facturacion
            address = GetPartitionAddress(acc.BillingStreet);
            xml +='<Shipper>'+
                    '<ShipperID>'+ acc.name + '</ShipperID>'+
                    '<CompanyName>' + (gde.Envio_Particular_a_Particular__c == true ? contacto_hotexpress.Name__c : acc.name)  + '</CompanyName>'+
                    '<RegisteredAccount>' + dhl.ShipperAccountNumber__c + '</RegisteredAccount>' +
                    (address.address1 != null ? address.address1 : '')+
                	(address.address2 != null ? address.address2 : '') +
                	(address.address3 != null ? address.address3 : '') +
                    '<City>' + acc.BillingCity + '</City>'+
                    '<Division></Division>'+
                    '<DivisionCode></DivisionCode>'+

                    // '<PostalCode></PostalCode>'+
                    //FFC - Ticket 00019909
                    '<PostalCode>9020000</PostalCode>'+

                    '<CountryCode>CL</CountryCode>'+
                    '<CountryName>' + acc.BillingCountry + '</CountryName>'+
                    '<Contact>'+
                        '<PersonName>' + contacto_hotexpress.Name__c + '</PersonName>'+
                        '<PhoneNumber>' + contacto_hotexpress.Phone__c + '</PhoneNumber>'+
                        '<Email>' + contacto_hotexpress.Email__c + '</Email>'+                		
                    '</Contact>'+
                '</Shipper>';
        }
        
        if(gde.Seguro__c){
            xml += ensurance;
        }
        
        if(gde.DDP__c){
            xml += ddp;
        }
        
        xml +=  
            '<EProcShip>N</EProcShip>'+
            '<LabelImageFormat>ZPL2</LabelImageFormat> '+ 
        '</req:ShipmentRequest>';
       
        HE_Servicios  ser=new HE_Servicios();
        string  response = ser.callOutConvenioEmpresa(xml.replace('Ñ','N').replace('ñ','n').replace('&',''));
		system.debug('XML Request:'+xml);
        
        DOM.Document doc = new DOM.Document();
        if(test.isRunningTest()){
            response ='<?xml version="1.0" encoding="UTF-8"?><res:ErrorResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation= "http://www.dhl.com err-res.xsd">'+
                '    <Response>'+
                '        <ServiceHeader>'+
                '            <MessageTime>2020-06-19T20:50:13.474+02:00</MessageTime>'+
                '            <MessageReference>BookPickupGL_AP______________</MessageReference>'+
                '            <SiteID>v62_0pog1WibRN</SiteID>'+
                '            <Password>v62_0pog1WibRN</Password>'+
                '        </ServiceHeader>'+
                '        <Status>'+
                '            <ActionStatus>Error</ActionStatus>'+
                '            <Condition>'+
                '                <ConditionCode>ESB_GLS_GENERIC_ERR_001</ConditionCode>'+
                '                <ConditionData>ESB GLS exception while processing shipmet. Please contact help desk.</ConditionData>'+
                '            </Condition>'+
                '        </Status>'+
                '    </Response></res:ErrorResponse><!-- ServiceInvocationId:20200619205005_8979_d62d012a-ee55-484d-8a08-da0cc1dcf095 -->';
        }
        system.debug('response : ' + response);
        doc.load(response);    
        DOM.XMLNode root = doc.getRootElement();
        
        parseXML(root);    
        system.debug('base64'+base64);
        system.debug('dato1'+dato1);
        respuesta res=new respuesta();
        res.idtraking=dato1;
        list<mensaje>  mens=new list<mensaje>();
        mensaje m=new mensaje();
        m.Severity=ActionStatus;
        m.Source='';
        m.Code=ConditionCode;
        m.Message=ConditionData;
        mens.add(m);
        res.mensaje=mens;    
        list<base>  b64=new list<base>();
        base b=new base();
        if(ActionStatus!='Error'){
            b.base64blob=blob.valueOf(base64);
        }
        b.num=1;
        b64.add(b);
        res.base=b64;

        return res;        
    } 
    public respuesta_Tracking Tracking(string num){
        
        EndPoint_DHL__mdt  dhl=[SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName,
                                SiteID__c, Password__c, ShipperAccountNumber__c, servicio__c, EndPoint__c 
                                FROM EndPoint_DHL__mdt 
                                where QualifiedApiName=:'servicio_dhl' and servicio__c=:'Shipment_Validation'  ];
        
        datetime fecha=system.now();
        string f1=fecha.format('yyyy-MM-dd');
        system.debug('fecha'+fecha);
        system.debug('f1'+f1);
        string estructura='<?xml version="1.0" encoding="UTF-8"?>'+
            '<req:KnownTrackingRequest xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com TrackingRequestKnown.xsd">'+
            '<Request>'+
            '<ServiceHeader>'+
            '<MessageTime>'+f1+'T11:28:56-08:00</MessageTime>'+
            '<MessageReference>1234567890123456789012345678</MessageReference>'+
            '<SiteID>'+dhl.SiteID__c+'</SiteID>'+
            '<Password>'+dhl.Password__c+'</Password>'+
            '</ServiceHeader>'+
            '</Request>'+
            '<LanguageCode>en</LanguageCode>'+
            //'<AWBNumber>6723907643</AWBNumber>'+
            '<AWBNumber>'+num+'</AWBNumber>'+
            '<LevelOfDetails>LAST_CHECK_POINT_ONLY</LevelOfDetails>'+
            '<PiecesEnabled>S</PiecesEnabled> '+
            '</req:KnownTrackingRequest>';
        HE_Servicios  ser=new HE_Servicios();
        string  str=ser.callOutConvenioEmpresa(estructura);
        
        DOM.Document doc = new DOM.Document();
        if(test.isRunningTest()){
            str='<?xml version="1.0" encoding="UTF-8"?>'+
                '<req:TrackingResponse xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com TrackingResponse.xsd">'+
                '    <AWBInfo>'+
                '        <AWBNumber>1626685830</AWBNumber>'+
                '        <Status>'+
                '            <ActionStatus>success</ActionStatus>'+
                '        </Status>'+
                '        <ShipmentInfo>'+
                '           <ShipmentEvent>'+
                '                <Date>2021-04-05</Date>'+
                '                <Time>08:45:00</Time>'+
                '                <ServiceEvent>'+
                '                    <EventCode>OK</EventCode>'+
                '                    <Description>Delivered - Signed for by</Description>'+
                '                </ServiceEvent>'+
                '                <Signatory/>'+
                
                
                '            </ShipmentEvent>'+
                '        </ShipmentInfo>'+
                '    </AWBInfo>'+
                '    <LanguageCode>en</LanguageCode>'+
                '</req:TrackingResponse>';
        }
        doc.load(str);    
        DOM.XMLNode root = doc.getRootElement();
        respuesta_Tracking rt=parseXMLTRaking(root);   
        system.debug('rt'+rt);
        /*respuesta_Tracking rt=new respuesta_Tracking();
        rt.fecha=fecha_traking;
        rt.estado=estado;*/
        return rt;
    } 
    public void parseXML(DOM.XMLNode node) {
        
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            // system.debug('node.getName()'+node.getName());  
            if(node.getName()=='AirwayBillNumber' ){
                dato1 = node.getText().trim();
                
            }
            if(node.getName()=='OutputImage' ){
                base64 = node.getText().trim();
                
            }
            if(node.getName()=='ActionStatus' ){
                ActionStatus = node.getText().trim();
                
            }
            if(node.getName()=='ConditionCode' ){
                ConditionCode = node.getText().trim();
                
            }
            if(node.getName()=='ConditionData' ){
                ConditionData = node.getText().trim();
                
            }
            for (Dom.XMLNode child: node.getChildElements()) {
                parseXML(child);
                
                
            }
        }
    }
    public  respuesta_Tracking parseXMLTRaking(DOM.XMLNode res){ 
        
        
        respuesta_Tracking resp=new respuesta_Tracking();
        Dom.XMLNode Response = res; 
        Dom.XMLNode TrackingResponse = Response.getChildElement('Response', null);
        Dom.XMLNode AWBInfo = Response.getChildElement('AWBInfo', null); 
        if(AWBInfo!=null){
            string AWBNumber = AWBInfo.getChildElement('AWBNumber', null).getText();
            Dom.XMLNode Status = AWBInfo.getChildElement('Status', null);
            string ActionStatus = Status.getChildElement('ActionStatus', null).getText();  
            if(ActionStatus=='success'){
                Dom.XMLNode ShipmentInfo = AWBInfo.getChildElement('ShipmentInfo', null); 
                Dom.XMLNode ShipmentEvent = ShipmentInfo.getChildElement('ShipmentEvent', null); 
                if(ShipmentEvent!=null){
                    string fecha = ShipmentEvent.getChildElement('Date', null).getText();
                    string hora = ShipmentEvent.getChildElement('Time', null).getText();
                    
                    Dom.XMLNode ServiceEvent = ShipmentEvent.getChildElement('ServiceEvent', null);
                    string EventCode = ServiceEvent.getChildElement('EventCode', null).getText();
                    string Description = ServiceEvent.getChildElement('Description', null).getText();
                    resp.codigo=EventCode;
                    resp.fecha=fecha;
                    resp.estado=Description;
                    
                    
                    string Signatory = ShipmentEvent.getChildElement('Signatory', null).getText();
                    system.debug('Signatory'+Signatory);
                    if(Signatory!=null){
                        resp.estado+=' '+Signatory;     
                    }
                    
                    
                    Dom.XMLNode EventRemarks = ShipmentEvent.getChildElement('EventRemarks', null);
                    if(EventRemarks!=null){
                        string FurtherDetails = EventRemarks.getChildElement('FurtherDetails', null).getText();
                        string NextSteps = EventRemarks.getChildElement('NextSteps', null).getText();
                        resp.descripcion=FurtherDetails  +'  '+NextSteps;      
                    }
                }        
                
            }else{
                
                resp.fecha=string.valueOf(system.today()); 
                resp.estado=ActionStatus; 
                
            }
            
        }
        
        
        return resp;
    }
    
    ///==================Creado por: Roberto Quiroz / Divide dirección dependiendo de largo======================
    private Address GetPartitionAddress(string realAddress){
        list<string> addressesList = new list<string>();        
        
        Address address = new Address();
        if(realAddress == null)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Direccion inválida');
            ApexPages.addMessage(msg);
            return address;
        }
        if(realAddress.length() > 105){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Direccion inválida (mayor a 105 caracteres)');
            ApexPages.addMessage(msg);
            return address;
        }
                        
        addressesList = GetAddressListWithoutCutting(realAddress);
        
        //si direccion diseccionada tiene mas de 3 lineas, se corta sin importar los espacios
        if(addressesList.size() > 3){
            address = GetPartitionAddressWithCutting(realAddress);
            system.debug('--------------Direcciones cortadas sin importar los espacios-----------------');  
            system.debug('--------------address-----------------' + address);  
        }
        else{
            integer addressCounter = 0;
            for (string adress : addressesList) {
                if(addressCounter == 0){
                    address.address1 = '<AddressLine1>'+ adress +'</AddressLine1>';
                }
                else if(addressCounter == 1){
                    address.address2 = '<AddressLine2>'+ adress +'</AddressLine2>';
                }
                else if(addressCounter == 2){
                    address.address3 = '<AddressLine3>'+ adress +'</AddressLine3>';
                }     
                addressCounter++;
            }                
        }
        return address;
    }
    
    ///==================Creado por: Roberto Quiroz / Divide dirección dependiendo de largo sin cortar palabras======================
    public list<string> GetAddressListWithoutCutting(string direccion){
   
        string direcciones = '';
        list<string> direccionesList = new list<string>();                
		
        string[] trozos = direccion.split(' ');
        for(integer i = 0; i < trozos.size(); i++)
        {  	
            system.debug(i);
            if((direcciones.length() + trozos[i].length() -1) <= 34){
        
                direcciones += trozos[i] + ' ';
                if(i == (trozos.size() - 1))//ultimo
                {
                    system.debug('ultimo condicion 1.' + i);
                    direccionesList.add(direcciones.removeEnd(' '));
                }
            }
            else{
                direccionesList.add(direcciones.removeEnd(' '));        
                direcciones = trozos[i] + ' ';
                
                if(i == (trozos.size() - 1))//ultimo
                {
                    system.debug('ultimo condicion 2.' + i);
                    direccionesList.add(direcciones.removeEnd(' '));
                }
            }
        }
        
        system.debug('--------------Direcciones cortadas solo en espacios-----------------');              
        for(integer i = 0; i <= direccionesList.size() - 1; i++){
            system.debug('Direccion '+ string.valueOf(i) + ' : ' + direccionesList[i]);
        }        

        return direccionesList;
    }
    
    ///==================Creado por: Roberto Quiroz / Divide dirección sin importar si corta o no palabras======================
    public Address GetPartitionAddressWithCutting(string realAddress){
        Address address = new Address();
        if(realAddress == null)
        {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error,'Direccion inválida');
            ApexPages.addMessage(msg);
            return address;
        }
                
        if(realAddress.length() > 35){
            
            address.address1 = '<AddressLine1>'+ realAddress.substring(0, 35) +'</AddressLine1>';
            if(realAddress.length() > 70){
                
              	address.address2 = '<AddressLine2>'+ realAddress.substring(35, 70) +'</AddressLine2>';
                address.address3 = '<AddressLine3>'+ realAddress.substring(70) +'</AddressLine3>';
            }
            else{
                address.address2 = '<AddressLine2>'+ realAddress.substring(35) +'</AddressLine2>';
            }
        }
        else{
            address.address1 = '<AddressLine1>'+ realAddress +'</AddressLine1>';
        }
        return address;
    }
    
    ///==================Creado por: Roberto Quiroz / seción ExportDeclaration======================
    private string ExportDeclarationSection(List<Contenido_Envio__c> shipmentContentList){
        integer counter = 1;       
        string lines = '';
                     
        string invoiceDate = system.now().format('yyyy-MM-dd');
        
        for(Contenido_Envio__c content : shipmentContentList){
            lines += 
             '<ExportLineItem>' +
                 '<LineNumber>' + counter + '</LineNumber>' +
                 '<Quantity>' + content.Cantidad__c  + '</Quantity>' +
                 '<QuantityUnit>PCS</QuantityUnit>' +
                 '<Description>' + content.Descripcion__c  + '</Description>' +
                 '<Value>' + content.Valor_Unitario__c  + '</Value>' +
                 '<Weight>' +
                    '<Weight>1</Weight>' +
                    '<WeightUnit>K</WeightUnit>' +
                 '</Weight>' +
                 '<GrossWeight>' +
                    '<Weight>1</Weight>' +
                    '<WeightUnit>K</WeightUnit>' +
                 '</GrossWeight>' +
             	'<ManufactureCountryCode>' + GetCountry(content.Pais_fab__c).Cod_Pais__c + '</ManufactureCountryCode>' +
          	'</ExportLineItem>';
            counter++;
        }
        return 
            '<ExportDeclaration>' +
            '<InvoiceNumber>MyDHLAPI - INV-001</InvoiceNumber>' +
            '<InvoiceDate>' + invoiceDate + '</InvoiceDate>' + 
            lines +
            '</ExportDeclaration>';
    }
    
    private Pais__c GetCountry(string id){
        return [SELECT Id, Cod_Pais__c FROM Pais__c WHERE Pais__c.Id =: id LIMIT 1];
    }
    
    public class respuesta {
        public string idtraking{get;set;}
        public list<base> base{get;set;}
        public list<mensaje> mensaje{get;set;}
        public string facturabase64{get;set;}
    }     
    public class base {
        public blob base64blob{get;set;}
        public blob facturabase64{get;set;}
        public string base64{get;set;}
        public integer num{get;set;}
        
    } 
    public class mensaje {
        public string Severity{get;set;}
        public string Source{get;set;}
        public string Code{get;set;}
        public string Message{get;set;}
        public string LocalizedMessage{get;set;}
        
    } 
    public class respuesta_Tracking {
        public string codigo{get;set;}
        public string fecha{get;set;}
        public string estado{get;set;}
        public string descripcion{get;set;}
        
    }  
    //Direccion
    public class Address {
        public string address1 {get; set;}
        public string address2 {get; set;}
        public string address3 {get; set;}
    }
}