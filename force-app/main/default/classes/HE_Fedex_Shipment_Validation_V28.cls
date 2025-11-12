/**********************************************************************************
Desarrollado por: Cloud Solutions
Autor: Roberto Quiroz Gonzalez (RQG)
Proyecto: HotExpress
Descripción: 
---------------------------------------------------------------------------------
No. Fecha                Autor                     Descripción
------ ---------- ---------------------------------------------------------------
1.0 24-01-2022            RQG                      Creación de la Clase Fedex V28
***********************************************************************************/
public class HE_Fedex_Shipment_Validation_V28 {
    
    public Respuesta HE_Fedex_Shipment_Validation_V28(string idexp){
        
        Guias_de_Exportacion__c  exportationGuide = [select id,Name,Direccion_Destinatario__c,Contacto__c,Correo_Electronico__c,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                          Ancho__c,Largo__c,Alto__c,Fecha_de_Envio__c,Paquetes__c,Peso_Total__c,Divisa__c,Unidad_de_Medida__c,N_de_Guia__c,Calle__c,
                                          Ciudad__c,Cod_Postal__c,Contacto__r.name,Valor_Total_del_Contenido__c,Embalaje_HOT__c ,
                                          Contacto__r.Account.name,Contacto__r.Email,Telefono__c,Valor_Paquete__c,Peso_Agente__c,ID_Remitente__c,
                                          ID_Remitente__r.BillingStreet,ID_Remitente__r.BillingCity,ID_Remitente__r.BillingState,ID_Remitente__r.BillingPostalCode,
                                          ID_Remitente__r.BillingCountry,Shipper_Original__c,DDP__c,Otro_Remitente__c, Breve_Descripcion__c, Envio_Particular_a_Particular__c,Direccion_Contacto__c,
                                          Breve_Descripcion_2__c, Breve_Descripcion_3__c, Breve_Descripcion_4__c, Seguro__c
                                          from Guias_de_Exportacion__c where id=:idexp];
        
        Direcciones__c dir_org;
        
        if(exportationGuide.Otro_Remitente__c != null){
            dir_org = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                     LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                     Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:exportationGuide.Otro_Remitente__c];
        }
        
        Direcciones__c dirdes = [SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                               LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,
                               Codigo_Postal__c, Tipo__c,Cod_Pais__c ,Pais__r.Country_Region__c
                               FROM Direcciones__c where id=:exportationGuide.Direccion_Destinatario__c];
        
        list<Contenido_Envio__c> shipContent = [select id,Cantidad__c,Condicion_de_Venta__c,Descripcion__c,Comentarios__c,/*Pais_de_Fabricacion__c,*/Pais_fab__r.Cod_Pais__c,
                                           Unidad_de_Medida__c,Valor_Unitario__c
                                           from Contenido_Envio__c where Pickup__c=:exportationGuide.id];

        Account account = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
                     OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c 
                     FROM Account 
                     WHERE Nombre_Fantasia__c =: 'Hot Express'];
        
        list<Contact> contacts =[SELECT Id, AccountId, Name, MailingAddress, Email,Phone, MobilePhone, OwnerId, Tipo_Cargo__c, Aprobador_Final__c 
                            FROM Contact where AccountId=:account.id];
        
        Contacto_HotExpress__mdt contacto_hotexpress = [SELECT Name__c, Email__c, Phone__c FROM Contacto_HotExpress__mdt WHERE MasterLabel =: 'ContactoPrincipal' LIMIT 1];
        
        EndPoint_fedex__mdt endPoint =[SELECT usuario__c,contrase_a__c,numero_cuenta__c,EndPoint__c,Meter_Number__c,Fedex_Accoun__c 
                                 FROM EndPoint_fedex__mdt where servicio__c=:'ShipServicePort' and MasterLabel=:'fedexComWsShipV28'];
        
        fedexComWsShipV28.UserDetail userDetail = new fedexComWsShipV28.UserDetail();
        fedexComWsShipV28.ProcessShipmentReply shipmentReply = new  fedexComWsShipV28.ProcessShipmentReply();
        fedexComWsShipV28.ShipmentReply shipmentValidationReply = new fedexComWsShipV28.ShipmentReply();
        fedexComWsShipV28.ShipServicePort servicePort = new fedexComWsShipV28.ShipServicePort();
        servicePort.endpoint_x = endPoint.EndPoint__c;
		fedexComWsShipV28.ProcessShipmentRequest processShipmentRequest = new fedexComWsShipV28.ProcessShipmentRequest();
        
        //   -----------------------------------------------WebAuthenticationDetail--------------------------------------------------------------------- 
        fedexComWsShipV28.WebAuthenticationDetail webAuthenticationDetail = new fedexComWsShipV28.WebAuthenticationDetail();
        fedexComWsShipV28.WebAuthenticationCredential credentials = new fedexComWsShipV28.WebAuthenticationCredential();
        credentials.Key = endPoint.usuario__c;   
        credentials.Password = endPoint.contrase_a__c;
               
        webAuthenticationDetail.UserCredential = credentials;                      
		webAuthenticationDetail.ParentCredential = credentials;   
        
         //---------------------------------------ClientDetail----------------------------------------------------------------------------- 
        fedexComWsShipV28.ClientDetail clientDetail = new fedexComWsShipV28.ClientDetail();
        clientDetail.AccountNumber = endPoint.Fedex_Accoun__c; 
        clientDetail.MeterNumber = endPoint.Meter_Number__c;  
        
        fedexComWsShipV28.Localization localization = new fedexComWsShipV28.Localization();
        localization.LanguageCode = 'ES';
        localization.LocaleCode = 'ES';
        clientDetail.Localization = localization;       
        
        //--------------------------------------------------TransactionDetail------------------------------------------------------------------   
        fedexComWsShipV28.TransactionDetail transactionDetail = new fedexComWsShipV28.TransactionDetail();
        transactionDetail.CustomerTransactionId = 'Shipment_Validation_HotExpress_WSv28'; 
        transactionDetail.Localization = localization; 
        
        //------------------------------------------------------Version-------------------------------------------------------------- 
        fedexComWsShipV28.VersionId version = new fedexComWsShipV28.VersionId();  //  estructura fija  utilizada par identificar  el servicio y la vercion 
        version.ServiceId = 'ship';
        version.Major = 28 ;
        version.Intermediate = 0;
        version.Minor = 0;      
        
        //------------------------------------------------------RequestedShipment-------------------------------------------------------------- 
        fedexComWsShipV28.RequestedShipment requestedShipment = new fedexComWsShipV28.RequestedShipment();
        requestedShipment.ShipTimestamp = system.now();
        requestedShipment.DropoffType = 'REGULAR_PICKUP';
        requestedShipment.ServiceType = 'INTERNATIONAL_PRIORITY'; 
        if(exportationGuide.Embalaje_HOT__c == 'Sobre'){
            requestedShipment.PackagingType = 'FEDEX_ENVELOPE'; 
        }else if(exportationGuide.Embalaje_HOT__c == 'Pack'){
            requestedShipment.PackagingType = 'FEDEX_PAK';   
        }else{
            requestedShipment.PackagingType = 'YOUR_PACKAGING'; 
        }
        
        //------------------------------------------------------TotalWeight-------------------------------------------------------------- 
        fedexComWsShipV28.Weight weight = new fedexComWsShipV28.Weight();
        weight.Units = 'KG';
        weight.Value = exportationGuide.Peso_Agente__c;
        requestedShipment.TotalWeight = weight;
                
        //-----------------------------------------------TotalInsuredValue--------------------------------------------------- 
        fedexComWsShipV28.Money totalInsuredValue = new fedexComWsShipV28.Money();
        totalInsuredValue.Currency_x = exportationGuide.Divisa__c;
        if(exportationGuide.Seguro__c == true){
            totalInsuredValue.Amount = 0; //exportationGuide.Valor_Total_del_Contenido__c
        }
        else{
        	totalInsuredValue.Amount = 0.00; 
        }
        requestedShipment.TotalInsuredValue = totalInsuredValue;
        
    	//----------------------------------------------------------Shipper----------------------------------------------------------
        fedexComWsShipV28.Party shipper = new fedexComWsShipV28.Party();
        shipper.AccountNumber = '';                 
        
        //-------------------------Direcciones y Contacto------------------------------
        fedexComWsShipV28.Contact contact = new fedexComWsShipV28.Contact();
        list<string> addresses = new list<string>();
        fedexComWsShipV28.Address address = new fedexComWsShipV28.Address();  // direccion contacto Remitente
        if(exportationGuide.Shipper_Original__c == true)
        {
            contact.PersonName = exportationGuide.Contacto__r.name;
            contact.CompanyName = exportationGuide.Contacto__r.Account.name;
            contact.PhoneNumber = exportationGuide.Telefono__c;
            contact.EMailAddress = exportationGuide.Contacto__r.Email; 
            
            if(exportationGuide.Otro_Remitente__c == null){
                contact.CompanyName = (exportationGuide.Envio_Particular_a_Particular__c == true ? exportationGuide.Contacto__r.name : exportationGuide.Contacto__r.Account.name);
                //addresses.add(exportationGuide.ID_Remitente__r.BillingStreet);
                address.StreetLines = GetAddressListWithoutCutting(exportationGuide.Direccion_Contacto__c); 
                address.City = exportationGuide.ID_Remitente__r.BillingCity;
                address.StateOrProvinceCode = exportationGuide.ID_Remitente__r.BillingState;
                address.PostalCode = exportationGuide.ID_Remitente__r.BillingPostalCode;                
                address.CountryCode = 'CL';               
            }
            else
            {
                //addresses.add(dir_org.Direccion__c);
                contact.CompanyName = (exportationGuide.Envio_Particular_a_Particular__c == true ? exportationGuide.Contacto__r.name : exportationGuide.Contacto__r.Account.name);
                address.StreetLines =  GetAddressListWithoutCutting(dir_org.Direccion__c); 
                address.City = dir_org.Ciudad__c;
                address.StateOrProvinceCode = dir_org.Estado_Provincia__c;
                address.PostalCode = dir_org.Codigo_Postal__c;
                address.CountryCode = 'CL';    //address.CountryCode = dir_org.Cod_Pais__c; 
            }
        }
        else
        {          
            contact.PersonName = contacto_hotexpress.Name__c;
            contact.CompanyName = (exportationGuide.Envio_Particular_a_Particular__c == true ? contacto_hotexpress.Name__c : account.name);
            contact.PhoneNumber = contacto_hotexpress.Phone__c;
            contact.EMailAddress = contacto_hotexpress.Email__c;
            
            //addresses.add(account.BillingStreet);
            address.StreetLines = GetAddressListWithoutCutting(account.BillingStreet);
            address.City = account.BillingCity;
            address.StateOrProvinceCode = account.BillingState;
            address.PostalCode = exportationGuide.ID_Remitente__r.BillingPostalCode;
            address.CountryCode = 'CL';   
        }
        
     	shipper.Contact = contact;
        shipper.Address = address;
        requestedShipment.Shipper = shipper;
        
        //----------------------------------------------------------Recipient---------------------------------------------------------- 
        fedexComWsShipV28.Party recipient = new fedexComWsShipV28.Party();
        recipient.AccountNumber = '';       
        
        fedexComWsShipV28.Contact contactRecipient = new fedexComWsShipV28.Contact();  // datos  de quien  recibe el paquete         
        contactRecipient.PersonName = exportationGuide.Contacto_Destinatario__c;    
        contactRecipient.CompanyName = (exportationGuide.Envio_Particular_a_Particular__c == true ?  exportationGuide.Contacto_Destinatario__c : dirdes.Name);
        contactRecipient.PhoneNumber = exportationGuide.Telefono_Destinatario__c;
        contactRecipient.EMailAddress = exportationGuide.Correo_Electronico__c; 
        recipient.Contact = contactRecipient;
        
        system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'+exportationGuide);
        system.debug('XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'+dirdes);
        //list<string> addressesRecipient = new list<string>();        
        //addressesRecipient.add(dirdes.Direccion__c);
        
        fedexComWsShipV28.Address addressRecipient = new fedexComWsShipV28.Address(); // datos  de quien  recibe el paquete 
        addressRecipient.StreetLines = GetAddressListWithoutCutting(dirdes.Direccion__c);
        addressRecipient.City = dirdes.Ciudad__c;
        addressRecipient.StateOrProvinceCode = dirdes.Estado_Provincia__c;
        addressRecipient.PostalCode = dirdes.Codigo_Postal__c;
        addressRecipient.CountryCode = dirdes.Cod_Pais__c; 
        addressRecipient.Residential = false;
        recipient.Address = addressRecipient;
        requestedShipment.Recipient = recipient;
        
        //   ------------------------------------------------------ShippingChargesPayment-------------------------------------------------------------- 
        fedexComWsShipV28.Payment shippingChargesPayment = new fedexComWsShipV28.Payment();
        shippingChargesPayment.PaymentType = 'SENDER';
                    
        list<fedexComWsShipV28.TaxpayerIdentification> tins = new list<fedexComWsShipV28.TaxpayerIdentification>(); //  categoria del contribuyente   
        fedexComWsShipV28.TaxpayerIdentification tin = new fedexComWsShipV28.TaxpayerIdentification();
        tin.TinType = 'BUSINESS_STATE'; 
        tin.Number_x = '12345';
        tins.add(tin);
        
        fedexComWsShipV28.Payor payor = new fedexComWsShipV28.Payor();
        fedexComWsShipV28.Party responsibleParty = new fedexComWsShipV28.Party();        
        responsibleParty.AccountNumber = endpoint.Fedex_Accoun__c;//exportationGuide.DDP__c ?  endpoint.Fedex_Accoun__c : '-';   
        responsibleParty.Tins = tins;
        responsibleParty.Contact = contact;
        //responsibleParty.Address = address;
        
        payor.ResponsibleParty = responsibleParty;
        shippingChargesPayment.Payor = payor;
        requestedShipment.ShippingChargesPayment = shippingChargesPayment;
        
        //--------------------------------------------------------CustomsClearanceDetail------------------------------------------------------------   
        fedexComWsShipV28.CustomsClearanceDetail customsClearanceDetail = new fedexComWsShipV28.CustomsClearanceDetail();                
        fedexComWsShipV28.Payment dutiesPayment = new  fedexComWsShipV28.Payment();
        
        if(exportationGuide.DDP__c == true){
            //se mostrará la cuenta
            dutiesPayment.Payor = payor;
            dutiesPayment.PaymentType = 'SENDER';
        }else{
            dutiesPayment.PaymentType = 'RECIPIENT';
        }      
        
        //dutiesPayment.Payor = payor;
        customsClearanceDetail.DutiesPayment = dutiesPayment;
        customsClearanceDetail.DocumentContent = 'NON_DOCUMENTS'; //DOCUMENTS_ONLY
        
        fedexComWsShipV28.Money customsValue = new fedexComWsShipV28.Money();
        customsValue.Currency_x = exportationGuide.Divisa__c;
        customsValue.Amount = exportationGuide.Valor_Total_del_Contenido__c;
        customsClearanceDetail.CustomsValue = customsValue;        
        customsClearanceDetail.PartiesToTransactionAreRelated = false;
        
        fedexComWsShipV28.CommercialInvoice commercialInvoice = new fedexComWsShipV28.CommercialInvoice();
        commercialInvoice.Purpose = 'SOLD';
        list<fedexComWsShipV28.CustomerReference> custReferences = new list<fedexComWsShipV28.CustomerReference>();
        fedexComWsShipV28.CustomerReference custReference = new fedexComWsShipV28.CustomerReference();
        custReference.CustomerReferenceType = 'INVOICE_NUMBER';
        custReferences.add(custReference);
        commercialInvoice.CustomerReferences = custReferences;
        commercialInvoice.TermsOfSale = 'ddp';
        customsClearanceDetail.CommercialInvoice = commercialInvoice;
        
        integer commoditiesQty = 0;
        if(exportationGuide.Breve_Descripcion__c != null)
            commoditiesQty++;
        if(exportationGuide.Breve_Descripcion_2__c != null)
            commoditiesQty++;
        if(exportationGuide.Breve_Descripcion_3__c != null)
            commoditiesQty++;
        if(exportationGuide.Breve_Descripcion_4__c != null)
            commoditiesQty++;
        
        list<fedexComWsShipV28.Commodity> commodities = new list<fedexComWsShipV28.Commodity>(); 
        for(integer i = 0; i < commoditiesQty; i++)
        {
            fedexComWsShipV28.Commodity commodity = new fedexComWsShipV28.Commodity(); 
            commodity.NumberOfPieces = 1;
            /*if(i == 0){
            	commodity.Description = exportationGuide.Breve_Descripcion__c;
            }
            else{
                commodity.Description = '-';
            }*/
            commodity.CountryOfManufacture = shipContent.get(0).Pais_fab__r.Cod_Pais__c;
            commodity.HarmonizedCode = '987456321';

            fedexComWsShipV28.Weight weightCommodity = new fedexComWsShipV28.Weight();
            weightCommodity.Units = 'KG';
            weightCommodity.Value = 0;
            commodity.Weight = weightCommodity;
            commodity.Quantity = shipContent.get(0).Cantidad__c;
            commodity.QuantityUnits = 'PCS';         
            
            fedexComWsShipV28.Money unitPrice = new fedexComWsShipV28.Money();
            unitPrice.Currency_x = exportationGuide.Divisa__c;
            unitPrice.Amount = integer.valueOf(shipContent.get(0).Valor_Unitario__c);    
            commodity.UnitPrice = unitPrice;  
            
            fedexComWsShipV28.Money customsValueCommodity = new fedexComWsShipV28.Money();
            customsValueCommodity.Currency_x = exportationGuide.Divisa__c;
            customsValueCommodity.Amount = exportationGuide.Valor_Total_del_Contenido__c;
            commodity.CustomsValue = customsValueCommodity;
            commodity.CIMarksAndNumbers = string.valueOf(i) + ' of ' + string.valueOf(shipContent.size());
            
            if(exportationGuide.Breve_Descripcion__c != null && i == 0){
                commodity.Description = exportationGuide.Breve_Descripcion__c;
                commodities.add(commodity);                
            }
            if(exportationGuide.Breve_Descripcion_2__c != null && i == 1){
                commodity.Description = exportationGuide.Breve_Descripcion_2__c;
                commodities.add(commodity);               
            }
            if(exportationGuide.Breve_Descripcion_3__c != null && i == 2){
                commodity.Description = exportationGuide.Breve_Descripcion_3__c;
                commodities.add(commodity);                
            }
            if(exportationGuide.Breve_Descripcion_4__c != null && i == 3){
                commodity.Description = exportationGuide.Breve_Descripcion_4__c;
                commodities.add(commodity);               
            }			            
        }        
        customsClearanceDetail.Commodities = commodities;
        fedexComWsShipV28.ExportDetail exportDetail = new fedexComWsShipV28.ExportDetail();
        exportDetail.ExportComplianceStatement = '30.37(f)'; //  Campo general para exportar datos específicos del país (como B13A para CA, Exención FTSR o Cita AES para EE. UU.).
        customsClearanceDetail.ExportDetail = exportDetail;
        requestedShipment.CustomsClearanceDetail = customsClearanceDetail;
        
        //------------------------------------------------LabelSpecification--------------------------------------------------------------------                  
        fedexComWsShipV28.LabelSpecification labelSpecification = new fedexComWsShipV28.LabelSpecification();
        fedexComWsShipV28.CustomerSpecifiedLabelDetail customerSpecifiedDetail = new fedexComWsShipV28.CustomerSpecifiedLabelDetail();
        labelSpecification.LabelFormatType = 'COMMON2D';
        labelSpecification.ImageType = 'PDF'; 
        labelSpecification.LabelStockType = 'STOCK_4X6.75';
        
        fedexComWsShipV28.CustomerSpecifiedLabelDetail customerSpecifiedLabelDetail = new fedexComWsShipV28.CustomerSpecifiedLabelDetail();         
         //tag para esconder cuenta principal------
        
        list<string> maskedData = new list<string>();
        maskedData.add('TRANSPORTATION_CHARGES_PAYOR_ACCOUNT_NUMBER'); 
        maskedData.add('DUTIES_AND_TAXES_PAYOR_ACCOUNT_NUMBER');
        customerSpecifiedLabelDetail.MaskedData = maskedData;
        
        fedexComWsShipV28.Localization termsAndConditionsLocalization = new fedexComWsShipV28.Localization();
        termsAndConditionsLocalization.LanguageCode = 'en';
        termsAndConditionsLocalization.LocaleCode = 'CL';  
        customerSpecifiedLabelDetail.TermsAndConditionsLocalization = termsAndConditionsLocalization;
        labelSpecification.CustomerSpecifiedDetail = customerSpecifiedLabelDetail;
        
        requestedShipment.LabelSpecification = labelSpecification;            		
        
        //------------------------------------------------ShippingDocumentSpecification------------------------------------------------------------------
        fedexComWsShipV28.ShippingDocumentSpecification shippingDocumentSpecification = new fedexComWsShipV28.ShippingDocumentSpecification();
    
        list<string> shippingDocumentTypes = new list<string>();
        shippingDocumentTypes.add('COMMERCIAL_INVOICE');
        shippingDocumentSpecification.ShippingDocumentTypes = shippingDocumentTypes;
        
        fedexComWsShipV28.CommercialInvoiceDetail commercialInvoiceDetail = new fedexComWsShipV28.CommercialInvoiceDetail();        
        fedexComWsShipV28.ShippingDocumentFormat format = new fedexComWsShipV28.ShippingDocumentFormat();
        format.ImageType = 'PDF';
        format.StockType = 'PAPER_LETTER';
        format.ProvideInstructions = true;        
        
        fedexComWsShipV28.ShippingDocumentDispositionDetail shippingDocumentDispositionDetail = new fedexComWsShipV28.ShippingDocumentDispositionDetail();
        list<fedexComWsShipV28.ShippingDocumentDispositionDetail> shippingDocumentDispositionDetails = new list<fedexComWsShipV28.ShippingDocumentDispositionDetail>();
        shippingDocumentDispositionDetail.DispositionType = 'RETURNED';
        shippingDocumentDispositionDetails.add(shippingDocumentDispositionDetail);
        format.Dispositions = shippingDocumentDispositionDetails;
        commercialInvoiceDetail.Format = format;
        
        shippingDocumentSpecification.CommercialInvoiceDetail = commercialInvoiceDetail;
       	requestedShipment.ShippingDocumentSpecification = shippingDocumentSpecification;
        
        //------------------------------------------------RateRequestTypes------------------------------------------------------------  
        list<string> rateRequestTypes = new list<string>();
        rateRequestTypes.add('LIST');
        rateRequestTypes.add('PREFERRED');
        requestedShipment.RateRequestTypes = rateRequestTypes;                                      
        requestedShipment.PackageCount = integer.valueOf(exportationGuide.Paquetes__c);

        Respuesta response = new Respuesta();        
        string trackingId = '';
        string labelsPdfbase64 = '';
        list<Base> bases64 = new list<Base>();
        List<string> bases64Files = new List<string>();
        list<Mensaje> messages = new list<Mensaje>();
        boolean firstShipment = true;
        list<fedexComWsShipV28.RequestedPackageLineItem> requestedPackageLineItems = new list<fedexComWsShipV28.RequestedPackageLineItem>();
        fedexComWsShipV28.TrackingId masterTrackingId = new fedexComWsShipV28.TrackingId(); 
        masterTrackingId.TrackingIdType = 'FEDEX';
        masterTrackingId.FormId = '0430';
        Base base = new base();
        
        //Recorre paquetes
        for(integer packageCounter = 0; packageCounter < integer.valueOf(exportationGuide.Paquetes__c); packageCounter++)
        {    
            fedexComWsShipV28.RequestedPackageLineItem line = new fedexComWsShipV28.RequestedPackageLineItem();
            line.SequenceNumber = packageCounter + 1; 
            line.InsuredValue = totalInsuredValue;
            
            fedexComWsShipV28.Weight lineWeight = new fedexComWsShipV28.Weight();
            lineWeight.Units = 'KG';
            lineWeight.Value = (exportationGuide.Peso_Agente__c/exportationGuide.Paquetes__c).setScale(2);
            line.Weight = lineWeight;
            
            fedexComWsShipV28.Dimensions lineDimension = new fedexComWsShipV28.Dimensions();
            lineDimension.Length = integer.valueOf(exportationGuide.Largo__c);
            lineDimension.Width = integer.valueOf(exportationGuide.Ancho__c);
            lineDimension.Height = integer.valueOf(exportationGuide.Alto__c);
            lineDimension.Units = 'CM';
            line.ItemDescription = 'DESCRIPCION DE LA MERCANCIA';
            line.Dimensions = lineDimension;
            
            fedexComWsShipV28.PackageSpecialServicesRequested special = new fedexComWsShipV28.PackageSpecialServicesRequested();
        	list<string> specialServicetypes = new list<string>();
        	specialServicetypes.add('SIGNATURE_OPTION');
        	special.SpecialServiceTypes = specialServicetypes;
            
            fedexComWsShipV28.SignatureOptionDetail signature = new fedexComWsShipV28.SignatureOptionDetail();
            signature.OptionType = 'SERVICE_DEFAULT';
            
            special.SignatureOptionDetail = signature;
            line.SpecialServicesRequested = special;
            
            list<fedexComWsShipV28.CustomerReference> linesCustomerReferences = new  list<fedexComWsShipV28.CustomerReference>();
            
            fedexComWsShipV28.CustomerReference lineCustomerReference = new  fedexComWsShipV28.CustomerReference();
            lineCustomerReference.CustomerReferenceType = 'CUSTOMER_REFERENCE';   
            lineCustomerReference.Value = exportationGuide.name;
            
            linesCustomerReferences.add(lineCustomerReference);            
            line.CustomerReferences = linesCustomerReferences;
            requestedPackageLineItems.add(line); 

            requestedShipment.RequestedPackageLineItems = requestedPackageLineItems;
            system.debug('requestedShipment Seidor: '+JSON.serialize(requestedShipment));
            if(Test.isRunningTest() == false){
                
            	shipmentReply = servicePort.processShipment(webAuthenticationDetail, clientDetail, userDetail, transactionDetail, version, requestedShipment);
                System.debug('RESPONSE X:' + shipmentReply); 
                               
                if(shipmentReply.CompletedShipmentDetail != null)
                {
                    labelsPdfbase64 = shipmentReply.CompletedShipmentDetail.CompletedPackageDetails.get(0).Label.Parts.get(0).Image;
                	bases64Files.add(labelsPdfbase64); 
                }
            }
            else{
                fedexComWsShipV28.ProcessShipmentReply shipmentReplyTest = new  fedexComWsShipV28.ProcessShipmentReply();
                    
                list<fedexComWsShipV28.Notification> notitificationsTest = new  list<fedexComWsShipV28.Notification>();
                fedexComWsShipV28.Notification notificationTest = new  fedexComWsShipV28.Notification();
                notificationTest.Severity = '';
                notificationTest.Source = '';
                notificationTest.Code = '';
                notificationTest.Message = '';
                notificationTest.LocalizedMessage = '';
                notitificationsTest.add(notificationTest);
                shipmentReplyTest.Notifications = notitificationsTest;
                fedexComWsShipV28.CompletedShipmentDetail  resultTest = new fedexComWsShipV28.CompletedShipmentDetail();
                
                fedexComWsShipV28.TrackingId trackingTest = new  fedexComWsShipV28.TrackingId();
                trackingTest.TrackingNumber = '321421142';
                resultTest.MasterTrackingId = trackingTest; 
                shipmentReplyTest.CompletedShipmentDetail = resultTest;
                
                shipmentReply = shipmentReplyTest;                
            }
            system.debug('packageCounter ' + packageCounter + '---> ' +requestedPackageLineItems);
            requestedPackageLineItems = new list<fedexComWsShipV28.RequestedPackageLineItem>();   
            requestedShipment.RequestedPackageLineItems = requestedPackageLineItems;
            
            if(firstShipment == true){          
                                
                system.debug('master:' + requestedShipment.RequestedPackageLineItems);
                if(shipmentReply.CompletedShipmentDetail != null){    
                    if(shipmentReply.CompletedShipmentDetail.MasterTrackingId != null){                   
                        masterTrackingId.TrackingNumber = shipmentReply.CompletedShipmentDetail.MasterTrackingId.TrackingNumber;                  
                        response.idtraking = masterTrackingId.TrackingNumber;
                        requestedShipment.MasterTrackingId = masterTrackingId;                        
                        firstShipment = false;
                        trackingId = masterTrackingId.TrackingNumber;
                        system.debug('TrackingNumber:' + masterTrackingId.TrackingNumber);
                    }
                }                                
            }
            else{     
                system.debug('child:' + requestedShipment.RequestedPackageLineItems);
                if(shipmentReply.CompletedShipmentDetail != null){
                    if(shipmentReply.CompletedShipmentDetail.MasterTrackingId != null){
                        response.idtraking = shipmentReply.CompletedShipmentDetail.MasterTrackingId.TrackingNumber;
                    }
                }                                                               
            }
            
            for(integer i = 0; i <= shipmentReply.Notifications.size()-1; i++){
                Mensaje message = new Mensaje();
                message.Severity = shipmentReply.Notifications.get(i).Severity;
                message.Source = shipmentReply.Notifications.get(i).Source;
                message.Code = shipmentReply.Notifications.get(i).Code;
                message.Message = shipmentReply.Notifications.get(i).Message;
                message.LocalizedMessage = shipmentReply.Notifications.get(i).LocalizedMessage;
                messages.add(message);    
                system.debug('mensaje ' + message);
            }  
            response.mensaje = messages; 
            
            base = new base();
            if(shipmentReply.CompletedShipmentDetail != null){
                if(shipmentReply.CompletedShipmentDetail.CompletedPackageDetails != null){
                    
                    base.base64blob = blob.valueOf(shipmentReply.CompletedShipmentDetail.CompletedPackageDetails.get(0).Label.Parts.get(0).Image);                       
                    base.num = packageCounter + 1;                                       
                    
                    if(base.num == integer.valueOf(exportationGuide.Paquetes__c)){
                        if(shipmentReply.CompletedShipmentDetail.ShipmentDocuments != null){                          
                            base.facturabase64 = blob.valueOf(shipmentReply.CompletedShipmentDetail.ShipmentDocuments.get(0).Parts.get(0).Image);                           
                        }
                    }
                }
            }
            
            bases64.add(base);
            response.base = bases64;
            if(packageCounter + 1 == integer.valueOf(exportationGuide.Paquetes__c)){
                if(shipmentReply.CompletedShipmentDetail != null){
                    if(shipmentReply.CompletedShipmentDetail.ShipmentDocuments != null){
                        response.facturabase64 = shipmentReply.CompletedShipmentDetail.ShipmentDocuments.get(0).Parts.get(0).Image;
                    }
                }
            }                                 
        }      
        
        for(string file : bases64Files){
           HE_AttachmentGuides.saveAttachment(exportationGuide.id, file, 'Etiquetas - ' + trackingId + '_' + string.valueOf(bases64Files.size()) +'.pdf');
        }
        
        //system.debug('funcking bases64Files ' + bases64Files);
        return response;
    }
    
    ///==================Creado por: Roberto Quiroz / Divide dirección dependiendo de largo======================
    private list<string> GetPartitionAddressWithCutting(string realAddress){
        list<string> addresses = new list<string>();
		if(realAddress == null)
            return addresses;
        
        if(realAddress.length() > 35){
            
            addresses.add(realAddress.substring(0, 35));
            if(realAddress.length() > 70){
                
            	addresses.add(realAddress.substring(35, 70));
                
                addresses.add(realAddress.substring(70));
            }
            else{
                addresses.add(realAddress.substring(35));
            }
        }
        else{
            addresses.add(realAddress);
        }
        
        system.debug('Direccion2 cortada: ' + addresses);
        return addresses;
    }

    ///==================Creado por: Roberto Quiroz / Divide dirección dependiendo de largo sin cortar palabras======================
    
	public list<string> GetAddressListWithoutCutting(string direccion){
        string direcciones = '';
        list<string> direccionesList = new list<string>();
        
        if(direccion.length() > 105){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Direccion inválida (mayor a 105 caracteres)');
            ApexPages.addMessage(msg);
            return null;
        }
		
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
                
        //si dire es muy larga, redimensiona direcciones sin importar si se cortan palabras
        if(direccionesList.size() > 3){
            return GetPartitionAddressWithCutting(direccion);
        }
        
        for(integer i = 0; i <= direccionesList.size() - 1; i++){
            system.debug('Direccion '+ string.valueOf(i) + ' : ' + direccionesList[i]);
        } 
        return direccionesList;
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
}