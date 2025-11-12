public class HE_Consulta_Servicio_DHL_Impor {
 public string dato1{get;set;}
    public string base64{get;set;}
    public string ActionStatus{get;set;}
    public string ConditionCode{get;set;}
    public string ConditionData{get;set;} 
     public string fecha_traking{get;set;}
    public string estado{get;set;} 
    
    
    public respuesta Shipment_Validation(string idimp){ 
        
          Solicitud_de_Pickup__c  gde=[SELECT Id, Name, Cuenta__c, Valor_Cliente__c, ID_de_Destinatario__c, Fecha_de_Envio__c, Unidad_de_Medida__c,N_de_Guia__c,
                                     Divisa__c, Agente__c, Estado_Pickup__c, Valor_Combustible__c, Total_Costos_Facturados__c,Ancho_cm__c,Etapa__c,Fecha_Estado__c,
                                     Alto_cm__c,Largo_cm__c,Total_Costos_sin_Facturar__c, Valor_Agente__c,Direccion_Destinatario__c,Cuenta__r.BillingStreet,
                                     Correo_Electronico_Destinatario__c,Direccion_Remitente__c,Cantidad_de_Paquetes__c,Contacto_Remitente__c,Cuenta__r.name,Peso_Agente__c,
                                     Cuenta__r.BillingCity,Cuenta__r.BillingState,Cuenta__r.BillingPostalCode,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                     Zona_HOT__c,Peso_Cliente__c,Zona_Fedex__c,Embalaje_HOT__c,Telefono_Remitente__c,Correo_Electronico_Remitente__c,Ciudad__c  
                                     FROM  Solicitud_de_Pickup__c where id=:idimp];
        
       /* Direcciones__c dir=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Destinatario__c];
*/
        
        
        Direcciones__c dir_org=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Remitente__c];
        
        Account acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
                     OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c,BillingPostalCode  
                     FROM Account 
                     WHERE Nombre_Fantasia__c =: 'Hot Express'];
        
        EndPoint_DHL__mdt  dhl=[SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName,
                                SiteID__c, Password__c, ShipperAccountNumber__c, tel_fono_contacto__c,
                                nombre_contacto__c, servicio__c, EndPoint__c 
                                FROM EndPoint_DHL__mdt 
                                where QualifiedApiName=:'servicio_dhl' and servicio__c=:'Shipment_Validation'  ];
        system.debug('dhl'+dhl);
        datetime fecha=system.now();
        string f1=fecha.format('yyyy-MM-dd');
        system.debug('fecha'+fecha);
        system.debug('f1'+f1);
        system.debug('Guias_de_Exportacion__c'+gde);
      //  system.debug('Direcciones__c'+dir);
        boolean d=true; 
        string estructura='<?xml version="1.0" encoding="UTF-8"?>'+
            '<req:ShipmentRequest xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com ship-val-global-req.xsd" schemaVersion="5.0">'+
            '<Request>'+
            '<ServiceHeader>'+
            '<MessageTime>2020-01-07T11:30:04-00:00</MessageTime>'+
            '<MessageReference>BookPickupGL_AP______________</MessageReference>'+
            // '<SiteID>v62_0pog1WibRN</SiteID>'+
            // '<Password>ytQEkPR8nP</Password>'+
            '<SiteID>'+dhl.SiteID__c+'</SiteID>'+
            '<Password>'+dhl.Password__c+'</Password>'+
            '</ServiceHeader>'+
            
            '</Request>'+
            '<RegionCode>AM</RegionCode>'+
            //    '<!-- <RequestedPickupTime>N</RequestedPickupTime>-->'+
            //   '<!--<NewShipper>N</NewShipper>-->'+
            '<LanguageCode>ES</LanguageCode>'+
            '<PiecesEnabled>Y</PiecesEnabled>'+
            '<LatinResponseInd>Y</LatinResponseInd>'+
            '<Billing>'+
            '<ShipperAccountNumber>'+dhl.ShipperAccountNumber__c+'</ShipperAccountNumber>'+
            //'<ShipperAccountNumber>673010319</ShipperAccountNumber>'+
            '<ShippingPaymentType>S</ShippingPaymentType>'+// siempre remitente 
            //    '<!--<BillingAccountNumber></BillingAccountNumber>-->'+
            //    '<!--<DutyPaymentType>R</DutyPaymentType>-->'+// consultar con hot
            //    '<!-- <DutyAccountNumber>R</DutyAccountNumber>-->'+// consultar con hot
            '</Billing> '+
            '<Consignee>'+
            '<CompanyName>'+gde.Contacto_Destinatario__c+'</CompanyName>'+
            // '<SuiteDepartmentName>departamento numero 1 </SuiteDepartmentName>'+
            '<AddressLine>'+acc.BillingStreet+'</AddressLine>'+
            '<City>'+acc.BillingCity+'</City>'+
            //   '<!--<Division></Division>-->'+
            //   '<!--<DivisionCode >'+dir.Pais__r.name+'</DivisionCode>-->'+
            
            '<PostalCode>'+acc.BillingPostalCode+'</PostalCode>'+
            '<CountryCode>CL</CountryCode>'+
            '<CountryName>CHILE</CountryName>'+
            //   '<!--<FederalTaxId></FederalTaxId >-->'+
            //   '<!--<StateTaxID></StateTaxID >-->'+
            '<Contact>'+
            '<PersonName>'+gde.Contacto_Destinatario__c+'</PersonName>'+
            '<PhoneNumber>'+gde.Telefono_Destinatario__c+'</PhoneNumber>'+
            //     '<!--<PhoneExtension></PhoneExtension>-->'+
            //      '<!--<FaxNumber></FaxNumber>-->'+
            //      '<!--<Telex></Telex>-->'+
            '<Email>'+gde.Correo_Electronico_Destinatario__c+'</Email>'+
            '<MobilePhoneNumber>'+gde.Telefono_Destinatario__c+'</MobilePhoneNumber>'+
            '</Contact>'+
            //     '<!--<Suburb></Suburb>-->'+
            '</Consignee>'+
            '<Dutiable>'+
            '<DeclaredValue>200</DeclaredValue>'+//consultar con hotexpress
            '<DeclaredCurrency>USD</DeclaredCurrency>'+// campo divisa '+gde.Divisa__c+'
            
            '</Dutiable>'+
            //  '  <!--	<Reference>'+
            //	'	<ReferenceID>AM international shipment</ReferenceID>'+
            //   '	<ReferenceType>St</ReferenceType>'+
            //    '   </Reference>-->'+
            '<ShipmentDetails>'+
            '<NumberOfPieces>'+gde.Cantidad_de_Paquetes__c+'</NumberOfPieces>'+ 
            '<Pieces>';
        
        for(integer i=0; i<gde.Cantidad_de_Paquetes__c;i++){
            decimal peso= (gde.Peso_Agente__c/gde.Cantidad_de_Paquetes__c).setScale(2);
            estructura=estructura+ '<Piece>'+
                '<PieceID>'+(i+1)+'</PieceID>'+
                '<PackageType>JB</PackageType>'+//campo  aun por definir 
                '<Weight>'+peso+'</Weight>'+//campo '+gde.Peso_Total__c+'
                '<DimWeight>'+peso+'</DimWeight>'+//campo aun por definir
                '<Width>'+integer.valueOf(gde.Ancho_cm__c)+'</Width>'+
                '<Height>'+integer.valueOf(gde.Alto_cm__c)+'</Height>'+
                '<Depth>'+integer.valueOf(gde.Largo_cm__c)+'</Depth>'+
                '</Piece>';
        }
        estructura=estructura+'</Pieces>'+
            '<Weight>'+gde.Peso_Agente__c+'</Weight>'+
            '<WeightUnit>K</WeightUnit>'+
            '<GlobalProductCode>P</GlobalProductCode>'+
            '<LocalProductCode>P</LocalProductCode>'+
            '<Date>'+f1+'</Date>'+
            '<Contents>rodamientos mercancia china</Contents>'+
            '<DoorTo>DD</DoorTo>'+
            '<DimensionUnit>C</DimensionUnit>'+
            '<InsuredAmount>10</InsuredAmount>'+
            '<PackageType>JB</PackageType>'+
            '<IsDutiable>Y</IsDutiable>'+
            '<CurrencyCode>USD</CurrencyCode>'+ // pais remitente o pais destino ? 
            // '<!--<AdditionalProtection></AdditionalProtection>'+
            // '<DOSFlag></DOSFlag>'+
            // '<CustData></CustData>'+
            // '<Shipmentcharges></Shipmentcharges>-->'+
            '</ShipmentDetails>';
         if(gde.Direccion_Remitente__c==null){
            estructura=estructura+'<Shipper>'+
                '<ShipperID>'+gde.name+'</ShipperID>'+
                '<CompanyName>'+gde.Cuenta__r.name+'</CompanyName>'+
                //'<!--<SuiteDepartmentName></SuiteDepartmentName>-->'+
                '<RegisteredAccount></RegisteredAccount>'+
                '<AddressLine>'+gde.Cuenta__r.BillingStreet+'</AddressLine>'+
                '<City>'+gde.Cuenta__r.BillingCity+'</City>'+
                '<Division></Division>'+
                '<DivisionCode></DivisionCode>'+
                
                // '<PostalCode></PostalCode>'+
                //FFC - Ticket 00019909
                '<PostalCode>9020000</PostalCode>'+

                '<CountryCode>CL</CountryCode>'+
                '<CountryName>'+gde.Cuenta__r.BillingCountry+'</CountryName>'+
                '<Contact>'+
                '<PersonName>'+gde.Contacto_Remitente__c+'</PersonName>'+
                '<PhoneNumber>'+gde.Telefono_Remitente__c+'</PhoneNumber>'+
                '<Email>'+gde.Correo_Electronico_Destinatario__c+'</Email>'+
                '</Contact>'+
                '</Shipper>';
        }else{
            estructura=estructura+'<Shipper>'+
                '<ShipperID>'+acc.name+'</ShipperID>'+
                '<CompanyName>'+acc.name+'</CompanyName>'+
                //'<!--<SuiteDepartmentName></SuiteDepartmentName>-->'+
                '<RegisteredAccount>673010319</RegisteredAccount>'+
                '<AddressLine>'+dir_org.Direccion__c+'</AddressLine>'+
                '<City>'+dir_org.Ciudad__c+'</City>'+
                '<Division></Division>'+
                '<DivisionCode></DivisionCode>';
                
                //FFC - Ticket 00019909
                if (dir_org.Codigo_Postal__c != null)
                    estructura=estructura +'<PostalCode>'+dir_org.Codigo_Postal__c+'</PostalCode>';
                else
                    estructura=estructura+'<PostalCode>9020000</PostalCode>';

                estructura=estructura+'<CountryCode>'+dir_org.Cod_Pais__c+'</CountryCode>'+
                '<CountryName>'+dir_org.Pais__r.name+'</CountryName>'+
                '<Contact>'+
                '<PersonName>'+gde.Contacto_Remitente__c+'</PersonName>'+
                '<PhoneNumber>'+gde.Telefono_Remitente__c+'</PhoneNumber>'+
                '<Email>'+gde.Correo_Electronico_Destinatario__c+'</Email>'+
                '</Contact>'+
                '</Shipper>';
        }
        estructura=estructura+'<SpecialService>'+
            '	<SpecialServiceType>A</SpecialServiceType>'+
            '</SpecialService>'+
            '<SpecialService>'+
            '	<SpecialServiceType>I</SpecialServiceType>'+
            '</SpecialService>'+
            '<EProcShip>N</EProcShip>'+
            '<LabelImageFormat>ZPL2</LabelImageFormat> '+ 
            '</req:ShipmentRequest>';
        
        
        
        system.debug('estructura'+estructura);
        HE_Servicios  ser=new HE_Servicios();
        string  str=ser.callOutConvenioEmpresa(estructura);
        system.debug('str'+str);
        DOM.Document doc = new DOM.Document();
        if(test.isRunningTest()){
            str='<?xml version="1.0" encoding="UTF-8"?><res:ErrorResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation= "http://www.dhl.com err-res.xsd">'+
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
        doc.load(str);    
        DOM.XMLNode root = doc.getRootElement();
        //system.debug('root'+root);
        parseXML(root);   
        /* if(dato1!=null){
gde.N_de_Guia__c=dato1;
system.debug('dato1'+dato1);
update gde;

}*/
        /*      system.debug('base64='+base64);
system.debug('base64='+base64.length());
string url='/apex/HE_visualizar_etiqueta?base64='+base64;
system.debug('url='+url);
pageReference p = new PageReference(url);
return p;*/
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
    
    
    
    
    
    public PageReference Routing(){ 
        string     estructura='<?xml version="1.0" encoding="UTF-8"?>'+
            '<ns1:RouteRequest xmlns:ns1="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com'+
            'routing-global-req.xsd" schemaVersion="1.0">'+
            '<Request>'+
            '<ServiceHeader>'+
            '<MessageTime>2013-08-04T11:28:56.000-08:00</MessageTime>'+
            '<MessageReference>1234567890123456789012345678901</MessageReference>'+
            '<SiteID>v62_0pog1WibRN</SiteID>'+
            '<Password>ytQEkPR8nP</Password>'+
            '</ServiceHeader>'+
            '</Request>'+
            '<RegionCode>AM</RegionCode>'+
            '<RequestType>O</RequestType>'+
            '<Address1>las urbinas 53</Address1>'+
            
            '<PostalCode></PostalCode>'+
            '<City>Santiago</City>'+
            '<Division></Division>'+
            '<CountryCode>CL</CountryCode>'+
            '<CountryName>CHILE</CountryName>'+
            '<OriginCountryCode>CL</OriginCountryCode>'+
            '</ns1:RouteRequest>';
        HE_Servicios  ser=new HE_Servicios();
        string  str=ser.callOutConvenioEmpresa(estructura);
        DOM.Document doc = new DOM.Document();
         if(test.isRunningTest()){
            str='<?xml version="1.0" encoding="UTF-8"?><res:ErrorResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation= "http://www.dhl.com err-res.xsd">'+
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
        doc.load(str);    
        DOM.XMLNode root = doc.getRootElement();
        parseXML(root);   
        if(dato1!=null){
            system.debug('dato1'+dato1);
        }
        return null;
    }
    
    public respuesta_Tracking Tracking(string num){
        datetime fecha=system.now();
        string f1=fecha.format('yyyy-MM-dd');
        system.debug('fecha'+fecha);
        system.debug('f1'+f1);
        
         EndPoint_DHL__mdt  dhl=[SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName,
                                SiteID__c, Password__c, ShipperAccountNumber__c, servicio__c, EndPoint__c 
                                FROM EndPoint_DHL__mdt 
                                where QualifiedApiName=:'servicio_dhl' and servicio__c=:'Shipment_Validation'  ];
        
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
            '<LevelOfDetails>ALL_CHECK_POINTS</LevelOfDetails>'+
            '<PiecesEnabled>S</PiecesEnabled> '+
            '</req:KnownTrackingRequest>';
        HE_Servicios  ser=new HE_Servicios();
        string  str=ser.callOutConvenioEmpresa(estructura);
        
        DOM.Document doc = new DOM.Document();
         if(test.isRunningTest()){
            str='<?xml version="1.0" encoding="UTF-8"?><res:ErrorResponse xmlns:res="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation= "http://www.dhl.com err-res.xsd">'+
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
        doc.load(str);    
        DOM.XMLNode root = doc.getRootElement();
        system.debug('root'+root);
        parseXMLTRaking(root);   
        
        respuesta_Tracking rt=new respuesta_Tracking();
        rt.fecha=fecha_traking;
        rt.estado=estado;
        return rt;
    }
    public void Pickup_Book(){
        string estructura='<?xml version="1.0" encoding="UTF-8"?>'+
            '<req:BookPURequest xmlns:req="http://www.dhl.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com book-pickup-global-req.xsd" schemaVersion="1.0">'+
            '<Request>'+
            '<ServiceHeader>'+
            '<MessageTime>2013-08-03T09:30:47-05:00</MessageTime>'+
            '<MessageReference>Esteemed Courier Service of DHL</MessageReference>'+
            '<SiteID>v62_0pog1WibRN</SiteID>'+
            '<Password>ytQEkPR8nP</Password>'+
            '</ServiceHeader>'+
            
            '</Request>'+
            '<RegionCode>AM</RegionCode>'+
            '<Requestor>'+
            '<AccountType>D</AccountType>'+
            '<AccountNumber>673010319</AccountNumber>'+
            '<RequestorContact>'+
            '<PersonName>Kosani</PersonName>'+
            '<Phone>0195678910</Phone>'+
            '</RequestorContact>'+
            '<CompanyName>nectia</CompanyName>'+
            
            
            '</Requestor>'+
            '<Place>'+
            '<LocationType>B</LocationType>'+
            '<CompanyName>hotexpress</CompanyName>'+
            '<Address1>echaurren 1280</Address1>'+
            '<PackageLocation>bodega</PackageLocation>'+
            '<City>SANTIAGO</City>'+
            '<CountryCode>CL</CountryCode>'+
            '<PostalCode></PostalCode>'+
            '</Place>'+
            
            '<Pickup>'+
            '<PickupDate>2019-12-23</PickupDate>'+
            '<ReadyByTime>12:00</ReadyByTime>'+
            '<CloseTime>22:00</CloseTime>'+
            '<AfterHoursClosingTime>10:00</AfterHoursClosingTime>'+
            '<AfterHoursLocation>12:00</AfterHoursLocation>'+
            '<Pieces>1</Pieces>'+
            '<weight>'+
            '<Weight>20</Weight>'+
            '<WeightUnit>K</WeightUnit>'+
            '</weight>'+
            '<SpecialInstructions></SpecialInstructions>'+
            '</Pickup>'+
            
            '<PickupContact>'+
            '<PersonName>test1</PersonName>'+
            '<Phone>123456765432</Phone>'+
            '<PhoneExtension></PhoneExtension>'+
            '</PickupContact>'+
            
            '<ShipmentDetails>'+
            '<AccountType>D</AccountType>'+
            '<AccountNumber>673010319</AccountNumber>'+
            
            '<!-- <ChargeCard>'+
            '<ChargeCardNo></ChargeCardNo>'+
            '<ChargeCardType></ChargeCardType>'+
            '<ChargeCardExpiryDate></ChargeCardExpiryDate>'+
            '</ChargeCard>-->'+
            
            '<BillToAccountNumber></BillToAccountNumber>'+
            '<AWBNumber></AWBNumber>'+
            '<NumberOfPieces>1</NumberOfPieces>'+
            '<Weight>20</Weight>'+
            '<WeightUnit>K</WeightUnit>'+
            '<GlobalProductCode>P</GlobalProductCode>'+
            '<DoorTo>DD</DoorTo>'+
            '<DimensionUnit>C</DimensionUnit>'+
            '<!--<InsuredAmount></InsuredAmount>-->'+
            '<InsuredCurrencyCode>CLP</InsuredCurrencyCode>'+
            '<!--<Pieces></Pieces>'+
            '<SpecialService></SpecialService>-->'+
            '</ShipmentDetails>'+
            '</req:BookPURequest>';
    }
    
    public PageReference Capability_Quote(string idimp){
          Solicitud_de_Pickup__c  gde=[SELECT Id, Name, Cuenta__c, Valor_Cliente__c, ID_de_Destinatario__c, Fecha_de_Envio__c, Unidad_de_Medida__c,N_de_Guia__c,
                                     Divisa__c, Agente__c, Estado_Pickup__c, Valor_Combustible__c, Total_Costos_Facturados__c,Ancho_cm__c,Etapa__c,Fecha_Estado__c,
                                     Alto_cm__c,Largo_cm__c,Total_Costos_sin_Facturar__c, Valor_Agente__c,Direccion_Destinatario__c,Cuenta__r.BillingStreet,
                                     Correo_Electronico_Destinatario__c,Direccion_Remitente__c,Cantidad_de_Paquetes__c,Contacto_Remitente__c,Cuenta__r.name,Peso_Agente__c,
                                     Cuenta__r.BillingCity,Cuenta__r.BillingState,Cuenta__r.BillingPostalCode,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                     Zona_HOT__c,Peso_Cliente__c,Zona_Fedex__c,Embalaje_HOT__c,Telefono_Remitente__c,Correo_Electronico_Remitente__c,Ciudad__c  
                                     FROM  Solicitud_de_Pickup__c where id=:idimp];
        
       /* Direcciones__c dir=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Destinatario__c];*/
        
          Account acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
                     OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c,BillingPostalCode  
                     FROM Account 
                     WHERE Nombre_Fantasia__c =: 'Hot Express'];
        
         Direcciones__c dir_org=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Remitente__c];
        
        EndPoint_DHL__mdt  dhl=[SELECT Id, DeveloperName, MasterLabel, Language, NamespacePrefix, Label, QualifiedApiName,
                                SiteID__c, Password__c, ShipperAccountNumber__c, tel_fono_contacto__c,
                                nombre_contacto__c, servicio__c, EndPoint__c 
                                FROM EndPoint_DHL__mdt 
                                where QualifiedApiName=:'servicio_dhl' and servicio__c=:'Shipment_Validation'  ];
        system.debug('dhl'+dhl);
        
        
        datetime fecha=system.now();
        string f1=fecha.format('yyyy-MM-dd');
        system.debug('fecha'+fecha);
        system.debug('f1'+f1);
        string estructura='<?xml version="1.0" encoding="utf-8"?>'+
            '<p:DCTRequest xmlns:p="http://www.dhl.com" xmlns:p1="http://www.dhl.com/datatypes" xmlns:p2="http://www.dhl.com/DCTRequestdatatypes" schemaVersion="2.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.dhl.com DCT-req.xsd ">'+
            '   <GetQuote>'+
            '      <Request>'+
            '         <ServiceHeader>'+
            '            <MessageTime>'+f1+'T03:29:26+00:00</MessageTime>'+
            '            <MessageReference>de28a010e5d441d8a5dfb3d2cadd99a8</MessageReference>'+
            '            <SiteID>'+dhl.SiteID__c+'</SiteID>'+
            '            <Password>'+dhl.Password__c+'</Password>'+
            '         </ServiceHeader>'+
            '         <MetaData>'+
            '            <SoftwareName>3PV</SoftwareName>'+
            '            <SoftwareVersion>1.0</SoftwareVersion>'+
            '        </MetaData>'+
            '      </Request>'+
            '      <From>'+
            '         <CountryCode>CL</CountryCode>'+
            '         <Postalcode></Postalcode>'+
            '         <City>'+dir_org.Ciudad__c+'</City>'+
            '      </From>'+
            '      <BkgDetails>'+
            '         <PaymentCountryCode>US</PaymentCountryCode>'+
            '          <Date>'+f1+'</Date>'+
            '         <ReadyTime>PT5M</ReadyTime>'+
            '         <DimensionUnit>CM</DimensionUnit>'+
            '         <WeightUnit>KG</WeightUnit>'+
            '         <NumberOfPieces>'+gde.Cantidad_de_Paquetes__c+'</NumberOfPieces>'+
            '         <ShipmentWeight>'+gde.Peso_Agente__c+'</ShipmentWeight>'+
            /*'         <Pieces>'+
'            <Piece>'+
'               <PieceID>1</PieceID>'+
'               <Height>7</Height>'+
'               <Depth>8</Depth>'+
'               <Width>7</Width>'+
'               <Weight>1.1</Weight>'+
'            </Piece>'+
'         </Pieces>'+*/
            '         <PaymentAccountNumber>'+dhl.ShipperAccountNumber__c+'</PaymentAccountNumber>'+
            '         <IsDutiable>Y</IsDutiable>'+
            '         <NetworkTypeCode>AL</NetworkTypeCode>'+
            /*'         <QtdShp>'+
'            <QtdShpExChrg>'+
'               <SpecialServiceType>OSINFO</SpecialServiceType>'+
'            </QtdShpExChrg>'+
'            <QtdShpExChrg>'+
'               <SpecialServiceType>TK</SpecialServiceType>'+
'            </QtdShpExChrg>'+
'         </QtdShp>'+*/
            '      </BkgDetails>'+
            '      <To>'+
            '         <CountryCode>CL</CountryCode>'+
            '         <Postalcode>'+acc.BillingPostalCode+'</Postalcode>'+
            '         <City>'+gde.Ciudad__c+'</City>'+
            '      </To>'+
            '      <Dutiable>'+
            '         <DeclaredCurrency>USD</DeclaredCurrency>'+
            '         <DeclaredValue>0</DeclaredValue>'+
            '      </Dutiable>'+
            '   </GetQuote>'+
            '</p:DCTRequest>';
         system.debug('estructura'+estructura);
        HE_Servicios  ser=new HE_Servicios();
        string  str=ser.callOutConvenioEmpresa(estructura);
       
        
        return null;
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
    
    
     public void parseXMLTRaking(DOM.XMLNode node) {
        
        
        if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
            // system.debug('node.getName()'+node.getName());  
            if(node.getName()=='Date' ){
                fecha_traking = node.getText().trim();
                
            }
             if(node.getName()=='ServiceEvent' ){
                estado = node.getText().trim();
                
            }
            
            
            for (Dom.XMLNode child: node.getChildElements()) {
                parseXML(child);
                
                
            }
        }
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
        public string fecha{get;set;}
        public string estado{get;set;}
        
        
    }  
}