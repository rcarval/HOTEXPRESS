public class HE_Consulta_Servicio_Fedex_Impor {
  
    public respuesta Shipment_Validation(string idimp){
        
          Solicitud_de_Pickup__c  gde=[SELECT Id, Name, Cuenta__c, Valor_Cliente__c, ID_de_Destinatario__c, Fecha_de_Envio__c, Unidad_de_Medida__c,N_de_Guia__c,
                                     Divisa__c, Agente__c, Estado_Pickup__c, Valor_Combustible__c, Total_Costos_Facturados__c,Ancho_cm__c,Etapa__c,Fecha_Estado__c,
                                     Alto_cm__c,Largo_cm__c,Total_Costos_sin_Facturar__c, Valor_Agente__c,Direccion_Destinatario__c,Cuenta__r.BillingStreet,
                                     Correo_Electronico_Destinatario__c,Direccion_Remitente__c,Cantidad_de_Paquetes__c,Contacto_Remitente__c,Cuenta__r.name,Peso_Agente__c,
                                     Cuenta__r.BillingCity,Cuenta__r.BillingState,Cuenta__r.BillingPostalCode,Telefono_Destinatario__c,Contacto_Destinatario__c,
                                     Zona_HOT__c,Peso_Cliente__c,Zona_Fedex__c,Embalaje_HOT__c,Telefono_Remitente__c,Correo_Electronico_Remitente__c,Ciudad__c  
                                     FROM  Solicitud_de_Pickup__c where id=:idimp];
        
        /* Direcciones__c dirorig=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,
Codigo_Postal__c, Tipo__c,Cod_Pais__c,Pais__r.Country_Region__c
FROM Direcciones__c where id=:gde.Solicitud_de_Retiro__r.Direcciones__c];*/
        
      /*  Direcciones__c dirdes=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                               LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,
                               Codigo_Postal__c, Tipo__c,Cod_Pais__c ,Pais__r.Country_Region__c
                               FROM Direcciones__c where id=:gde.Direccion_Destinatario__c];*/
        
                 Direcciones__c dir_org=[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, CreatedById, LastModifiedDate, LastModifiedById, SystemModstamp, 
                            LastActivityDate, Cuenta__c, Direccion__c, Ciudad__c, Estado_Provincia__c,  Pais__r.name,Cod_Pais__c,
                            Codigo_Postal__c, Tipo__c FROM Direcciones__c where id=:gde.Direccion_Remitente__c];
        
        
     /*   list<Contenido_Envio__c>  conenv= [select id,Cantidad__c,Condicion_de_Venta__c,Descripcion__c,Comentarios__c, Pais_fab__r.Cod_Pais__c,
                                           Unidad_de_Medida__c,Valor_Unitario__c
                                           from Contenido_Envio__c where Pickup__c=:gde.id];*/
        list<Contenido_Importacion_Agente__c>  conenv=[SELECT Id, Descripcion__c, Cantidad__c, Unidad_de_Medida__c, Valor_Unitario__c,
                                          Pais_de_Fabricacion__c, Importacion_Agente__c,Pais_de_Fabricacion__r.Cod_Pais__c 
                                         FROM Contenido_Importacion_Agente__c where Importacion_Agente__c=:gde.id];
        system.debug('conenv'+conenv);
        
        Account acc=[SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingCountry, BillingAddress, ShippingAddress,
                     OwnerId, RUT__c, Telefono_2__c, Nombre_Fantasia__c, Haber__c, Debe__c, Saldo__c ,BillingPostalCode
                     FROM Account 
                     WHERE Nombre_Fantasia__c =: 'Hot Express'];
        EndPoint_fedex__mdt ep =[SELECT usuario__c,contrase_a__c,numero_cuenta__c,EndPoint__c 
                                 FROM EndPoint_fedex__mdt where servicio__c=:'ShipServicePort' and flujo__c=:'Importación'];
        
        
        // formato= AAAA-MM-DDTHH:MM:SS-xx:xx.
        datetime  d=system.now();
        string fecha=d.format('yyyy-MM-DD')+'T'+d.format('HH:MM:SS')+'-04:00';
        
        
        fedexComWsShipV25   fed=new fedexComWsShipV25();
        fedexComWsShipV25.ShipServicePort  fs=new fedexComWsShipV25.ShipServicePort();
        fedexComWsShipV25.ProcessShipmentReply fdpsr=new  fedexComWsShipV25.ProcessShipmentReply();
        //   -----------------------------------------------WebAuthenticationDetail--------------------------------------------------------------------- 
        fedexComWsShipV25.WebAuthenticationCredential credenciales=new fedexComWsShipV25.WebAuthenticationCredential();
        //credenciales.Key='xgKC2IsbxAM3Nk2V';  // fijo guardar como metadato
        //credenciales.Password='lJ4s3hBor6cfXXmLbe4rHLzTH'; // fijo guardar como metadato
        credenciales.Key=ep.usuario__c;   
        credenciales.Password=ep.contrase_a__c;
        
        fedexComWsShipV25.WebAuthenticationDetail WebAuthenticationDetail=new fedexComWsShipV25.WebAuthenticationDetail();
        WebAuthenticationDetail.ParentCredential=credenciales;
        WebAuthenticationDetail.UserCredential=credenciales;
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   ---------------------------------------ClientDetail----------------------------------------------------------------------------- 
        fedexComWsShipV25.Localization Localization=new fedexComWsShipV25.Localization();
        Localization.LanguageCode='ES'; //fijo
        Localization.LocaleCode='ES'; //fijo
        
        fedexComWsShipV25.ClientDetail ClientDetail=new fedexComWsShipV25.ClientDetail();
        ClientDetail.AccountNumber='510087100';  //fijo guardar como metadato
        ClientDetail.MeterNumber='114031181';  //fijo guardar como metadato
        ClientDetail.Localization=Localization;
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   --------------------------------------------------TransactionDetail------------------------------------------------------------------   
        fedexComWsShipV25.TransactionDetail TransactionDetail=new fedexComWsShipV25.TransactionDetail();
        TransactionDetail.CustomerTransactionId='Prueba_Shipping_HotExpress_WSv25';  //  tecto de forma libre utilizado para unir solicitud y respuesta 
        TransactionDetail.Localization=Localization; 
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   ------------------------------------------------------Version-------------------------------------------------------------- 
        fedexComWsShipV25.VersionId Version=new fedexComWsShipV25.VersionId();  //  estructura fija  utilizada par identificar  el servicio y la vercion 
        Version.ServiceId='ship';
        Version.Major=25;
        Version.Intermediate=0;
        Version.Minor=0;
        //   -------------------------------------------------------------------------------------------------------------------- 
        
        //   -----------------------------------------------------Shipper--------------------------------------------------------------- 
        list<fedexComWsShipV25.TaxpayerIdentification>  Tins=new  list<fedexComWsShipV25.TaxpayerIdentification>(); //  categoria del contribuyente   
        fedexComWsShipV25.TaxpayerIdentification    fit=new fedexComWsShipV25.TaxpayerIdentification();
        fit.TinType='BUSINESS_STATE';  //  valores posibles   BUSINESS_NATIONAL , BUISNESS_STATE , BUSINESS_UNION , PERSONAL_NATIONAL , PERSONAL_STATE  
        fit.Number_x='12345';     //Tipo de identificación fiscal y número de identificación fiscal. Especifique el número de identificación del empleador (EIN). Se requiere si los aranceles, impuestos y tarifas se facturan al destinatario.
        Tins.add(fit);
        
        fedexComWsShipV25.Contact Contact=new fedexComWsShipV25.Contact();  //datos contacto   Remitente
        
        
        
        list<string> StreetLines=new list<string>();
        fedexComWsShipV25.Address Address=new fedexComWsShipV25.Address();  // direccion contacto Remitente
        if(gde.Direccion_Remitente__c==null){
            
            /*Contact.PersonName='JP';   
Contact.CompanyName='JPP';
Contact.PhoneNumber='45645';
Contact.EMailAddress='AA@AA.CL';*/
            Contact.PersonName=gde.Contacto_Remitente__c;
            Contact.CompanyName=gde.Cuenta__r.name;
            Contact.PhoneNumber=gde.Telefono_Remitente__c;
          Contact.EMailAddress=gde.Correo_Electronico_Remitente__c; 
            StreetLines.add(gde.Cuenta__r.BillingStreet);
            
            Address.StreetLines=StreetLines; 
            Address.City=   gde.Cuenta__r.BillingCity;
            Address.StateOrProvinceCode=gde.Cuenta__r.BillingState;
            Address.PostalCode=gde.Cuenta__r.BillingPostalCode;
            Address.CountryCode='CL';
        }else{
        
            Contact.PersonName=gde.Contacto_Remitente__c;
            Contact.CompanyName=gde.Cuenta__r.name;
             Contact.PhoneNumber=gde.Telefono_Remitente__c;
            Contact.EMailAddress=gde.Correo_Electronico_Remitente__c;
            StreetLines.add(dir_org.Direccion__c);
            Address.StreetLines=StreetLines;
            Address.City=   dir_org.Ciudad__c;
            Address.StateOrProvinceCode=dir_org.Estado_Provincia__c;
            Address.PostalCode=dir_org.Codigo_Postal__c;
            Address.CountryCode=dir_org.Cod_Pais__c;   
        }
        
        fedexComWsShipV25.Party Shipper=new fedexComWsShipV25.Party();   //Datos descriptivos requeridos que identifican a la parte responsable del envío del paquete. Remitente y Origen deben tener la misma dirección. 
        Shipper.AccountNumber='';//'510087100';  //  numero  cuenta  fedex  valido   opcional
        Shipper.Tins=Tins;
        Shipper.Contact=Contact;
        Shipper.Address=Address;
        
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   ----------------------------------------------------------Recipient---------------------------------------------------------- 
        
        list<fedexComWsShipV25.TaxpayerIdentification>  Tinsrecipier=new  list<fedexComWsShipV25.TaxpayerIdentification>(); //  categoria del contribuyente   
        fedexComWsShipV25.TaxpayerIdentification    fit1=new fedexComWsShipV25.TaxpayerIdentification();
        fit1.TinType='BUSINESS_STATE';  //  valores posibles   BUSINESS_NATIONAL , BUISNESS_STATE , BUSINESS_UNION , PERSONAL_NATIONAL , PERSONAL_STATE  
        fit1.Number_x='12345';     //Tipo de identificación fiscal y número de identificación fiscal. Especifique el número de identificación del empleador (EIN). Se requiere si los aranceles, impuestos y tarifas se facturan al destinatario.
        Tinsrecipier.add(fit1);
        
        fedexComWsShipV25.Contact ContactRecipient=new fedexComWsShipV25.Contact();  // datos  de quien  recibe el paquete 
        /* ContactRecipient.PersonName='EMMM';    
ContactRecipient.CompanyName='EMMMASA';
ContactRecipient.PhoneNumber='55666';
ContactRecipient.EMailAddress='EE@CC.CL';*/
        ContactRecipient.PersonName=acc.name;    
        ContactRecipient.CompanyName=acc.name;
        ContactRecipient.PhoneNumber=acc.Telefono_2__c;
        ContactRecipient.EMailAddress=gde.Correo_Electronico_Destinatario__c;
       
          
           // Contact.EMailAddress=gde.Correo_Electronico__c; 
        
        
        list<string> StreetLinesRecipient=new list<string>();
        //StreetLinesRecipient.add('UNA CALLE 123');
        StreetLinesRecipient.add(gde.Cuenta__r.BillingStreet);
        
        fedexComWsShipV25.Address AddressRecipient=new fedexComWsShipV25.Address(); // datos  de quien  recibe el paquete 
        AddressRecipient.StreetLines=StreetLinesRecipient;
        /*AddressRecipient.City='MIAMI';
AddressRecipient.StateOrProvinceCode='FL';
AddressRecipient.PostalCode='33142';
AddressRecipient.CountryCode='US'; */
        AddressRecipient.City= acc.BillingCity;
        AddressRecipient.StateOrProvinceCode=acc.BillingState;
        AddressRecipient.PostalCode=acc.BillingPostalCode;
        AddressRecipient.CountryCode='CL';      
        

           
                
        
        fedexComWsShipV25.Party Recipient=new fedexComWsShipV25.Party();  // datos  de quien  recibe el paquete 
        Recipient.AccountNumber='';//'510087100';   //  numero  cuenta  fedex  valido   opcional
        Recipient.Tins=Tinsrecipier;
        Recipient.Contact=ContactRecipient;
        Recipient.Address=AddressRecipient;
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   ------------------------------------------------------ShippingChargesPayment-------------------------------------------------------------- 
        
        /*  
fedexComWsShipV25.Contact ContactResponsibleParty=new fedexComWsShipV25.Contact(); 
ContactResponsibleParty.PersonName='EMMM';
ContactResponsibleParty.CompanyName='EMMMASA';
ContactResponsibleParty.PhoneNumber='55666';
ContactResponsibleParty.EMailAddress='EE@CC.CL';

list<string> StreetLinesResponsible=new list<string>();
StreetLinesResponsible.add('MI CASA 123');
fedexComWsShipV25.Address AddressResponsibleParty=new fedexComWsShipV25.Address();
AddressResponsibleParty.StreetLines=StreetLinesResponsible;
AddressResponsibleParty.City='SANTIAGO';
AddressResponsibleParty.StateOrProvinceCode='RM';
AddressResponsibleParty.PostalCode='99999';
AddressResponsibleParty.CountryCode='CL'; 
*/
        fedexComWsShipV25.Party ResponsibleParty=new fedexComWsShipV25.Party();
        ResponsibleParty.AccountNumber='510087100';   //Opcional. Identifica el número de cuenta de FedEx asignado al cliente. Si el envío es una transacción de Bill Sender, proporcione el número de cuenta Enterprise de 9 dígitos del remitente o el número de cuenta de Freight de 8 o 9 dígitos. Si el envío es Destinatario de la factura y se conoce el número de cuenta FedEx del pagador, proporcione el número de cuenta FedEx del pagador
        ResponsibleParty.Tins=Tins;
        ResponsibleParty.Contact=Contact;//ContactResponsibleParty;
        ResponsibleParty.Address=Address;//AddressResponsibleParty;
        
        
        fedexComWsShipV25.Payor Payor=new fedexComWsShipV25.Payor();
        Payor.ResponsibleParty=ResponsibleParty;
        
        fedexComWsShipV25.Payment ShippingChargesPayment=new  fedexComWsShipV25.Payment(); //Required.  Valid elements for the PaymentType are: • SENDER • THIRD_PARTY Note: The Payor/ResponsibleParty/AccountNumber element is required. 
        ShippingChargesPayment.PaymentType='SENDER'; //  SENDER , THIRD_PARTY
        ShippingChargesPayment.Payor=Payor;
        
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   --------------------------------------------------------CustomsClearanceDetail------------------------------------------------------------ 
        
        /* fedexComWsShipV25.Contact ContactPartyDutiesPayment=new fedexComWsShipV25.Contact(); 
ContactPartyDutiesPayment.PersonName='JP';
ContactPartyDutiesPayment.CompanyName='JPP';
ContactPartyDutiesPayment.PhoneNumber='456456';
ContactPartyDutiesPayment.EMailAddress='AA@AA.CL';

fedexComWsShipV25.Address AddressDutiesPayment=new fedexComWsShipV25.Address();
AddressDutiesPayment.StreetLines=StreetLines;
AddressDutiesPayment.City='SANTIAGO';
AddressDutiesPayment.StateOrProvinceCode='RM';
AddressDutiesPayment.PostalCode='99999';
AddressDutiesPayment.CountryCode='CL'; */
        
        fedexComWsShipV25.Party ResponsiblePartyDutiesPayment=new fedexComWsShipV25.Party();
        
        ResponsiblePartyDutiesPayment.AccountNumber='510087100';   
        ResponsiblePartyDutiesPayment.Tins=Tins;
        ResponsiblePartyDutiesPayment.Contact=Contact;//ContactPartyDutiesPayment;
        ResponsiblePartyDutiesPayment.Address=Address;//AddressDutiesPayment;
        
        fedexComWsShipV25.Payor PayorDutiesPayment=new fedexComWsShipV25.Payor();
        PayorDutiesPayment.ResponsibleParty=ResponsiblePartyDutiesPayment;
        
        fedexComWsShipV25.Payment DutiesPayment=new  fedexComWsShipV25.Payment();
       // if(gde.DDP__c==true){
         //   DutiesPayment.PaymentType='SENDER';//'SENDER';//RECIPIENT 
      //  }else{
            DutiesPayment.PaymentType='RECIPIENT';
       // }
        
        DutiesPayment.Payor=PayorDutiesPayment;
        
        fedexComWsShipV25.Money CustomsValue=new fedexComWsShipV25.Money();
        CustomsValue.Currency_x='USD';
        CustomsValue.Amount=0;//100.00;
        
        
        
        
        fedexComWsShipV25.Weight Weight=new fedexComWsShipV25.Weight();
        Weight.Units='KG';
        Weight.Value=0;//3;
        
        fedexComWsShipV25.Money CustomsValueCom=new fedexComWsShipV25.Money();
        CustomsValueCom.Currency_x='USD';
        //CustomsValueCom.Amount=100.00;
        CustomsValueCom.Amount=0;//100.00;
        
        list<fedexComWsShipV25.Commodity> listCommodities=new list<fedexComWsShipV25.Commodity>(); 
        for(integer i=0;i< conenv.size();i++){
            fedexComWsShipV25.Money UnitPrice=new fedexComWsShipV25.Money();
            UnitPrice.Currency_x='USD';
            // UnitPrice.Amount=2.00;
            UnitPrice.Amount=integer.valueOf(conenv.get(i).Valor_Unitario__c);//2.00;    
            
            
            fedexComWsShipV25.Commodity Commodities=new fedexComWsShipV25.Commodity();
            /* Commodities.NumberOfPieces=1;
Commodities.Description='JUGUETES';
Commodities.CountryOfManufacture='CH';
Commodities.Weight=Weight;
Commodities.Quantity=1;
Commodities.QuantityUnits='CM';*/
            Commodities.NumberOfPieces=i;
            Commodities.Description=conenv.get(i).Descripcion__c;
            Commodities.CountryOfManufacture=conenv.get(i).Pais_de_Fabricacion__r.Cod_Pais__c;
            Commodities.Weight=Weight;
            Commodities.Quantity=conenv.get(i).Cantidad__c;
            Commodities.QuantityUnits='PCS';
            
            Commodities.UnitPrice=UnitPrice;
            Commodities.CustomsValue=CustomsValueCom;
            listCommodities.add(Commodities);
        }
        fedexComWsShipV25.ExportDetail ExportDetail=new fedexComWsShipV25.ExportDetail();
        ExportDetail.ExportComplianceStatement='30.37(f)'; //  Campo general para exportar datos específicos del país (como B13A para CA, Exención FTSR o Cita AES para EE. UU.).
        //Para los envíos que requieren un EEI, ingrese el número ITN recibido de AES cuando presentó su envío o el número de exención FTR (Reglamento de Comercio Exterior). El formato adecuado para un número ITN es AES XYYYYMMDDNNNNNN donde YYYYMMDD es la fecha y NNNNNN son números generados por el AES.
        
        
        fedexComWsShipV25.CustomsClearanceDetail CustomsClearanceDetail=new  fedexComWsShipV25.CustomsClearanceDetail();
        CustomsClearanceDetail.DutiesPayment=DutiesPayment;   
        CustomsClearanceDetail.CustomsValue=CustomsValue;
        CustomsClearanceDetail.Commodities=listCommodities;
        CustomsClearanceDetail.ExportDetail=ExportDetail;
        //   -------------------------------------------------------------------------------------------------------------------- 
        //   ------------------------------------------------LabelSpecification-------------------------------------------------------------------- 
        
        
        fedexComWsShipV25.LabelSpecification LabelSpecification=new fedexComWsShipV25.LabelSpecification();
        LabelSpecification.LabelFormatType='COMMON2D';  //Necesario. Especifique el tipo de etiqueta que se devolverá  • COMMON2D  • ERROR  • LABEL_DATA_ONLY  • MAILROOM  • NO_LABEL  • OPERATIONAL_LABEL  • PRE_COMMON2D
        LabelSpecification.ImageType='PDF';  //Opcional. Especifique el formato de imagen utilizado para un documento de envío.
        LabelSpecification.LabelStockType='STOCK_4X6.75';//'PAPER_7X4.75'; //Los valores válidos son: • • PAPER_4X6 PAPER_4X6.75 • PAPER_4X8 • • PAPER_4X9 PAPER_7X4.75 • • PAPER_8.5X11_BOTTOM_HALF_LABEL PAPER_8.5X11_TOP_HALF_LABEL • • STOCK_4X6 STOCK_4X6.75 • • STOCK_4X6.75_LEADING_DOC_TAB STOCK_4X6.75_TRAILING_DOC_TAB • • STOCK_4X8 STOCK_4X9 • • STOCK_4X9_LEADING_DOC_TAB STOCK_4X9_TRAILING_DOC_TAB Nota: STOCK_4X6 y STOCK_4X8 están diseñados para que las etiquetas térmicas y las etiquetas pdf se impriman en una impresora térmica.
        
        //------------------------------------------------ShippingDocumentSpecification---------de -------------------RequestedShipment---------------------- 
        fedexComWsShipV25.ShippingDocumentFormat Format=new fedexComWsShipV25.ShippingDocumentFormat();
        Format.ImageType='PDF';
        Format.StockType='PAPER_LETTER';
        Format.ProvideInstructions=true;
        fedexComWsShipV25.CommercialInvoiceDetail CommercialInvoiceDetail=new fedexComWsShipV25.CommercialInvoiceDetail();
        CommercialInvoiceDetail.Format=Format;
        list<string> ShippingDocumentTypes=new list<string>();
        ShippingDocumentTypes.add('COMMERCIAL_INVOICE');
        fedexComWsShipV25.ShippingDocumentSpecification ShippingDocumentSpecification=new fedexComWsShipV25.ShippingDocumentSpecification();
        ShippingDocumentSpecification.ShippingDocumentTypes=ShippingDocumentTypes;   //ndica los tipos de documentos de envío solicitados por el remitente. Los valores válidos son: • • CERTIFICATE_OF_ORIGIN COMMERCIAL_INVOICE • • CUSTOM_PACKAGE_DOCUMENT CUSTOM_SHIPMENT_DOCUMENT • • CUSTOMER_SPECIFIED_LABELS DANGEROUS_GOODS_SHIPPERS_DECLARAT ION • • EXPORT_DECLARATION FEDEX_FREIGHT_STRAIGHT_BILL_OF_LADIN G • GENERAL_AGENCY_AGREEMENT • Etiqueta • • NAFTA_CERTIFICATE_OF_ORIGIN OP_900 • PENDING_SHIPMENT_EMAIL_NOTIFICATION
        ShippingDocumentSpecification.CommercialInvoiceDetail=CommercialInvoiceDetail;
        //---------------------------------------------------------------------------------------------------------------------------------- 
        //------------------------------------------------RateRequestTypes---------de -------------------RequestedShipment----------------------
        list<string> RateRequestTypes=new list<string>();
        RateRequestTypes.add('LIST');
        //-------------------------------------------------------------------------------------------------- 
        //-----------------------------------------------TotalWeight--------------------------------------------------- 
        fedexComWsShipV25.Weight TotalWeight=new fedexComWsShipV25.Weight();
        TotalWeight.Units='KG';
        TotalWeight.Value=10;//3;
        
        //------------------------------------------------------------------------------------------------
        //-----------------------------------------------TotalInsuredValue--------------------------------------------------- 
        fedexComWsShipV25.Money TotalInsuredValue=new fedexComWsShipV25.Money();
        TotalInsuredValue.Currency_x='USD';
        TotalInsuredValue.Amount=0.00;
        
        
        //------------------------------------------------------------------------------------------------
        respuesta res=new respuesta();
        
        string idtraking='';
        list<base>  b64=new list<base>();
        list<mensaje>  mensaje=new list<mensaje>();
         
        for(integer j=0;j< integer.valueOf(gde.Cantidad_de_Paquetes__c);j++){
            
            //------------------------------------------medidas---------------de -------------------RequestedPackageLineItems----------------------
            fedexComWsShipV25.Weight WeightRPLI=new fedexComWsShipV25.Weight();
            WeightRPLI.Units='KG';
            //  WeightRPLI.Value=20.0;
            WeightRPLI.Value=gde.Peso_Agente__c;//20.0;
            
            fedexComWsShipV25.Dimensions Dimensions=new fedexComWsShipV25.Dimensions();
            Dimensions.Length=integer.valueOf(gde.Largo_cm__c);
            Dimensions.Width=integer.valueOf(gde.Ancho_cm__c);
            Dimensions.Height=integer.valueOf(gde.Alto_cm__c);
            /*   Dimensions.Length=12;
Dimensions.Width=12;
Dimensions.Height=12;*/
            Dimensions.Units='CM';
            
            list<fedexComWsShipV25.CustomerReference>  listCustomerReferences=new  list<fedexComWsShipV25.CustomerReference>();
            fedexComWsShipV25.CustomerReference  CustomerReferences=new  fedexComWsShipV25.CustomerReference();
            CustomerReferences.CustomerReferenceType='CUSTOMER_REFERENCE';   //Opcional. Este elemento permite imprimir notas definidas por el cliente en la etiqueta de envío. El elemento de referencia también se utiliza para rastrear por referencia. Valores válidos:  • CUSTOMER_REFERENCE • DEPARTMENT_NUMBER • INTRA_REGULATORY_REFERENCE • INVOICE_NUMBER • P_O_NUMBER • RMA_ASSOCIATION • SHIPMENT_INTEGRITY 
            CustomerReferences.Value=gde.name;//'GUIA DESPACHO 2503';  //Opcional. Información de referencia que se asociará con CustomerReferenceType. Por ejemplo, si designa INVOICE_NUMBER en el elemento CustomerReferenceType, el número de factura real asociado con el paquete se incluye en el elemento CustomerReference / Value.
            listCustomerReferences.add(CustomerReferences);
            //------------------------------------------------RequestedPackageLineItems---------de -------------------RequestedShipment----------------------
            list<fedexComWsShipV25.RequestedPackageLineItem>  RequestedPackageLineItems=new list<fedexComWsShipV25.RequestedPackageLineItem>();
            fedexComWsShipV25.RequestedPackageLineItem RPLI=new fedexComWsShipV25.RequestedPackageLineItem();
            RPLI.SequenceNumber=j+1;
            RPLI.Weight=WeightRPLI;
            RPLI.Dimensions=Dimensions;
            RPLI.CustomerReferences=listCustomerReferences;
            RequestedPackageLineItems.add(RPLI);
            //---------------------------------------------------------------------------------------------------------------------
            
            
            
            
            
            if(j==0){
                system.debug('primer llamado');
                //------------------------------------------------RequestedShipment--------------------------------------------------
                fedexComWsShipV25.RequestedShipment RequestedShipment=new fedexComWsShipV25.RequestedShipment();
                RequestedShipment.ShipTimestamp='2020-03-03T18:00:00.000-03:00';
                RequestedShipment.DropoffType='REGULAR_PICKUP';    //El elemento DropoffType identifica el método por el cual el paquete se entregará a FedEx. Este elemento no envía un servicio de mensajería para la recogida del paquete.
                RequestedShipment.ServiceType='INTERNATIONAL_PRIORITY';//   Este campo contiene los valores de tipo de servicio  pagina 923   existen  56  valores para este campo 
                RequestedShipment.PackagingType='YOUR_PACKAGING';   // Valores válidos: • FEDEX_10KG_BOX • FEDEX_25KG_BOX • FEDEX_BOX • FEDEX_ENVELOPE • FEDEX_PAK • FEDEX_TUBE • YOUR_PACKAGING
                RequestedShipment.TotalWeight=TotalWeight;
                RequestedShipment.TotalInsuredValue=TotalInsuredValue;
                RequestedShipment.Shipper=Shipper;
                RequestedShipment.Recipient=Recipient;
                RequestedShipment.ShippingChargesPayment=ShippingChargesPayment;
                RequestedShipment.CustomsClearanceDetail=CustomsClearanceDetail;
                RequestedShipment.LabelSpecification=LabelSpecification;
                RequestedShipment.ShippingDocumentSpecification=ShippingDocumentSpecification;
                RequestedShipment.RateRequestTypes=RateRequestTypes;
                RequestedShipment.PackageCount=integer.valueOf(gde.Cantidad_de_Paquetes__c);
                RequestedShipment.RequestedPackageLineItems=RequestedPackageLineItems;
                //-------------------------------------------------------------------------------------------------- 
                if(!test.isRunningTest()){
                    fdpsr=fs.processShipment(WebAuthenticationDetail,ClientDetail,TransactionDetail,Version,RequestedShipment);
                }else{
                    fedexComWsShipV25.ProcessShipmentReply fd=new  fedexComWsShipV25.ProcessShipmentReply();
                    
                    list<fedexComWsShipV25.Notification> ln=new  list<fedexComWsShipV25.Notification>();
                    fedexComWsShipV25.Notification n=new  fedexComWsShipV25.Notification();
                    n.Severity='';
                    n.Source='';
                    n.Code='';
                    n.Message='';
                    n.LocalizedMessage='';
                    ln.add(n);
                    fd.Notifications=ln;
                    fedexComWsShipV25.CompletedShipmentDetail  fdc=new fedexComWsShipV25.CompletedShipmentDetail();
                    
                    fedexComWsShipV25.TrackingId fdt=new  fedexComWsShipV25.TrackingId();
                    fdt.TrackingNumber='321421142';
                    fdc.MasterTrackingId=fdt; 
                    fd.CompletedShipmentDetail=fdc;
                     
                   fdpsr= fd;
                    
                }
                system.debug('fdpsr='+fdpsr.HighestSeverity);
                system.debug('fdpsr='+fdpsr.Notifications);
                for(integer i=0;i<=fdpsr.Notifications.size()-1;i++){
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Severity);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Source);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Code);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Message);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).LocalizedMessage);
                }
              /*  system.debug('fdpsr='+fdpsr.TransactionDetail);
                system.debug('TransactionDetail='+fdpsr.TransactionDetail.CustomerTransactionId);
                system.debug('TransactionDetail='+fdpsr.TransactionDetail.Localization.LanguageCode);
                system.debug('TransactionDetail='+fdpsr.TransactionDetail.Localization.LocaleCode);
                system.debug('fdpsr='+fdpsr.Version);
                system.debug('fdpsr='+fdpsr.JobId);
                system.debug('fdpsr='+fdpsr.CompletedShipmentDetail);
                system.debug('CompletedShipmentDetail='+fdpsr.CompletedShipmentDetail.MasterTrackingId.TrackingNumber);
                system.debug('CompletedShipmentDetail='+fdpsr.CompletedShipmentDetail.CompletedPackageDetails.get(0).Label.Parts.get(0).Image);
                system.debug('fdpsr='+fdpsr.ErrorLabels);
                system.debug('fdpsr='+fdpsr.AdvisoryDetail);  
*/                
                idtraking= fdpsr.CompletedShipmentDetail.MasterTrackingId.TrackingNumber;
                
                
            }else{
                system.debug('  n  llamado');
                fedexComWsShipV25.TrackingId MasterTrackingId=new fedexComWsShipV25.TrackingId();   
                MasterTrackingId.TrackingIdType='FEDEX';
                MasterTrackingId.FormId='0430';
                MasterTrackingId.TrackingNumber=idtraking;   
                //------------------------------------------------RequestedShipment--------------------------------------------------
                fedexComWsShipV25.RequestedShipment2 RequestedShipment=new fedexComWsShipV25.RequestedShipment2();
                RequestedShipment.ShipTimestamp='2020-03-03T18:00:00.000-03:00';
                RequestedShipment.DropoffType='REGULAR_PICKUP';    //El elemento DropoffType identifica el método por el cual el paquete se entregará a FedEx. Este elemento no envía un servicio de mensajería para la recogida del paquete.
                RequestedShipment.ServiceType='INTERNATIONAL_PRIORITY';//   Este campo contiene los valores de tipo de servicio  pagina 923   existen  56  valores para este campo 
                RequestedShipment.PackagingType='YOUR_PACKAGING';   // Valores válidos: • FEDEX_10KG_BOX • FEDEX_25KG_BOX • FEDEX_BOX • FEDEX_ENVELOPE • FEDEX_PAK • FEDEX_TUBE • YOUR_PACKAGING
                RequestedShipment.TotalWeight=TotalWeight;
                RequestedShipment.TotalInsuredValue=TotalInsuredValue;
                RequestedShipment.Shipper=Shipper;
                RequestedShipment.Recipient=Recipient;
                RequestedShipment.ShippingChargesPayment=ShippingChargesPayment;
                RequestedShipment.CustomsClearanceDetail=CustomsClearanceDetail;
                RequestedShipment.LabelSpecification=LabelSpecification;
                RequestedShipment.ShippingDocumentSpecification=ShippingDocumentSpecification;
                RequestedShipment.RateRequestTypes=RateRequestTypes;
                RequestedShipment.MasterTrackingId=MasterTrackingId;   
                RequestedShipment.PackageCount=integer.valueOf(gde.Cantidad_de_Paquetes__c);
                RequestedShipment.RequestedPackageLineItems=RequestedPackageLineItems;
                //--------------------------------------------------------------------------------------------------  
                if(!test.isRunningTest()){   
                fdpsr=fs.processShipmentmulti(WebAuthenticationDetail,ClientDetail,TransactionDetail,Version,RequestedShipment);  
                }else{
                    fedexComWsShipV25.ProcessShipmentReply fd=new  fedexComWsShipV25.ProcessShipmentReply();
                    
                    list<fedexComWsShipV25.Notification> ln=new  list<fedexComWsShipV25.Notification>();
                    fedexComWsShipV25.Notification n=new  fedexComWsShipV25.Notification();
                    n.Severity='';
                    n.Source='';
                    n.Code='';
                    n.Message='';
                    n.LocalizedMessage='';
                    ln.add(n);
                    fd.Notifications=ln;
                    fedexComWsShipV25.CompletedShipmentDetail  fdc=new fedexComWsShipV25.CompletedShipmentDetail();
                    
                    fedexComWsShipV25.TrackingId fdt=new  fedexComWsShipV25.TrackingId();
                    fdt.TrackingNumber='321421142';
                    fdc.MasterTrackingId=fdt; 
                    fd.CompletedShipmentDetail=fdc;
                     
                   fdpsr= fd;
                    
                }
                
                system.debug('fdpsr='+fdpsr.HighestSeverity);
                system.debug('fdpsr='+fdpsr.Notifications);
                for(integer i=0;i<=fdpsr.Notifications.size()-1;i++){
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Severity);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Source);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Code);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).Message);
                    system.debug('Notifications='+fdpsr.Notifications.get(i).LocalizedMessage);
                }
              /*  system.debug('fdpsr='+fdpsr.TransactionDetail);
                system.debug('TransactionDetail='+fdpsr.TransactionDetail.CustomerTransactionId);
                system.debug('TransactionDetail='+fdpsr.TransactionDetail.Localization.LanguageCode);
                system.debug('TransactionDetail='+fdpsr.TransactionDetail.Localization.LocaleCode);
                system.debug('fdpsr='+fdpsr.Version);
                system.debug('fdpsr='+fdpsr.JobId);
                system.debug('fdpsr='+fdpsr.CompletedShipmentDetail);
                system.debug('CompletedShipmentDetail='+fdpsr.CompletedShipmentDetail.MasterTrackingId.TrackingNumber);
                system.debug('CompletedShipmentDetail='+fdpsr.CompletedShipmentDetail.CompletedPackageDetails.get(0).Label.Parts.get(0).Image);
                system.debug('fdpsr='+fdpsr.ErrorLabels);
                system.debug('fdpsr='+fdpsr.AdvisoryDetail); 
*/
            }
            
            
            
            
            
            res.idtraking=fdpsr.CompletedShipmentDetail.MasterTrackingId.TrackingNumber;
            for(integer i=0;i<=fdpsr.Notifications.size()-1;i++){
                mensaje  m=new mensaje();
                m.Severity=fdpsr.Notifications.get(i).Severity;
                m.Source=fdpsr.Notifications.get(i).Source;
                m.Code=fdpsr.Notifications.get(i).Code;
                m.Message=fdpsr.Notifications.get(i).Message;
                m.LocalizedMessage=fdpsr.Notifications.get(i).LocalizedMessage;
                mensaje.add(m);     
            }
            res.mensaje=mensaje;
            
            if(!test.isRunningTest()){
            base b=new base();
            b.base64blob=blob.valueOf(fdpsr.CompletedShipmentDetail.CompletedPackageDetails.get(0).Label.Parts.get(0).Image);
            //  b.base64=fdpsr.CompletedShipmentDetail.CompletedPackageDetails.get(0).Label.Parts.get(0).Image;
            b.num=j+1;
            if(j+1==integer.valueOf(gde.Cantidad_de_Paquetes__c)){
                b.facturabase64=blob.valueOf(fdpsr.CompletedShipmentDetail.ShipmentDocuments.get(0).Parts.get(0).Image);          
            }
            b64.add(b);
            res.base=b64;
            if(j+1==integer.valueOf(gde.Cantidad_de_Paquetes__c)){
                res.facturabase64=fdpsr.CompletedShipmentDetail.ShipmentDocuments.get(0).Parts.get(0).Image;  
            }
           } 
            // 
            
        } 
        
        system.debug('res'+res);
        return res;
    }
    
    public PageReference Track_Validation(string numero){
        EndPoint_fedex__mdt ep =[SELECT usuario__c,contrase_a__c,numero_cuenta__c,EndPoint__c 
                                 FROM EndPoint_fedex__mdt where servicio__c=:'TrackServicePort' and flujo__c=:'exportación'];
        
        fedexComWsTrackV18   fed=new fedexComWsTrackV18();
        fedexComWsTrackV18.TrackServicePort  ft=new fedexComWsTrackV18.TrackServicePort();
        fedexComWsTrackV18.TrackReply TrackReply=new fedexComWsTrackV18.TrackReply();
        fedexComWsTrackV18.WebAuthenticationCredential ParentCredential=new fedexComWsTrackV18.WebAuthenticationCredential();
        ParentCredential.Key=ep.usuario__c;
        ParentCredential.Password=ep.contrase_a__c;
        
        fedexComWsTrackV18.WebAuthenticationDetail WebAuthenticationDetail=new fedexComWsTrackV18.WebAuthenticationDetail();
        WebAuthenticationDetail.ParentCredential=ParentCredential;
        WebAuthenticationDetail.ParentCredential=ParentCredential;
        
        fedexComWsTrackV18.Localization Localization=new fedexComWsTrackV18.Localization();
        Localization.LanguageCode='ES';
        Localization.LocaleCode='ES';
        
        fedexComWsTrackV18.ClientDetail ClientDetail=new fedexComWsTrackV18.ClientDetail();
        ClientDetail.AccountNumber='510087100';
        ClientDetail.MeterNumber='114031181';
        ClientDetail.Localization=Localization;
        
        fedexComWsTrackV18.TransactionDetail TransactionDetail=new fedexComWsTrackV18.TransactionDetail();
        TransactionDetail.CustomerTransactionId='servicio_Tracking_HotExpress_WSv25';
        TransactionDetail.Localization=Localization; 
        
        fedexComWsTrackV18.VersionId Version=new fedexComWsTrackV18.VersionId();
        Version.ServiceId='trck';
        Version.Major=18;
        Version.Intermediate=0;
        Version.Minor=0;
        
        fedexComWsTrackV18.TrackPackageIdentifier  PackageIdentifier=new fedexComWsTrackV18.TrackPackageIdentifier();
        PackageIdentifier.Type_x='CUSTOMER_REFERENCE';
        PackageIdentifier.Value=numero;//'115380173';
        
        list<fedexComWsTrackV18.TrackSelectionDetail> SelectionDetails=new list<fedexComWsTrackV18.TrackSelectionDetail>();
        fedexComWsTrackV18.TrackSelectionDetail fts=new fedexComWsTrackV18.TrackSelectionDetail();
        fts.PackageIdentifier=PackageIdentifier;
        fts.ShipDateRangeBegin=date.valueOf('2018-08-07-03:00');
        fts.ShipDateRangeEnd=date.valueOf('2018-08-30-03:00');
        fts.ShipmentAccountNumber='510088000';
        SelectionDetails.add(fts);
         if(!test.isRunningTest()){
        TrackReply=ft.track(WebAuthenticationDetail, ClientDetail, TransactionDetail, Version, SelectionDetails);
        system.debug('TrackReply=='+TrackReply);
         }
        return null;
    }
    
    public PageReference rate_Validation(string idexp){
        EndPoint_fedex__mdt ep =[SELECT usuario__c,contrase_a__c,numero_cuenta__c,EndPoint__c 
                                 FROM EndPoint_fedex__mdt where servicio__c=:'RateServicePort' and flujo__c=:'exportación'];
        
        
        fedexComWsRateV26 fcWR=new fedexComWsRateV26();
        fedexComWsRateV26.RateServicePort fr=new fedexComWsRateV26.RateServicePort();
        fedexComWsRateV26.RateReply  resp=new fedexComWsRateV26.RateReply();
        //---------------------- credenciales WebAuthenticationDetail----------------------------------
        fedexComWsRateV26.WebAuthenticationCredential credenciales=new fedexComWsRateV26.WebAuthenticationCredential();
        credenciales.Key=ep.usuario__c;
        credenciales.Password=ep.contrase_a__c;
        
        fedexComWsRateV26.WebAuthenticationDetail WebAuthenticationDetail=new fedexComWsRateV26.WebAuthenticationDetail();
        WebAuthenticationDetail.ParentCredential=credenciales;
        WebAuthenticationDetail.UserCredential=credenciales;
        //----------------------fin   credenciales WebAuthenticationDetail----------------------------------   
        //---------------------- datos ClientDetail----------------------------------
        fedexComWsRateV26.Localization Localization=new fedexComWsRateV26.Localization();
        Localization.LanguageCode='ES';
        Localization.LocaleCode='ES';
        
        fedexComWsRateV26.ClientDetail ClientDetail=new fedexComWsRateV26.ClientDetail();
        ClientDetail.AccountNumber='510087100';
        ClientDetail.MeterNumber='114031181';
        ClientDetail.Localization=Localization;
        //----------------------fin  datos ClientDetail----------------------------------  
        //----------------------  datos TransactionDetail----------------------------------  
        fedexComWsRateV26.TransactionDetail TransactionDetail=new fedexComWsRateV26.TransactionDetail();
        TransactionDetail.CustomerTransactionId='PRUEBA_COTIZAR_ENVIO_WSv26';
        TransactionDetail.Localization=Localization; 
        //----------------------fin  datos TransactionDetail----------------------------------  
        //----------------------  datos Version----------------------------------  
        fedexComWsRateV26.VersionId Version=new fedexComWsRateV26.VersionId();
        Version.ServiceId='trck';
        Version.Major=18;
        Version.Intermediate=0;
        Version.Minor=0;
        //---------------------  datos Version----------------------------------  
        fedexComWsRateV26.Weight TotalWeight=new fedexComWsRateV26.Weight();
        TotalWeight.Units='KG';
        TotalWeight.Value=15.0;
        
        list<fedexComWsRateV26.TaxpayerIdentification>  Tins=new  list<fedexComWsRateV26.TaxpayerIdentification>();
        fedexComWsRateV26.TaxpayerIdentification    fit=new fedexComWsRateV26.TaxpayerIdentification();
        fit.TinType='BUSINESS_STATE';
        fit.Number_x='12345';
        Tins.add(fit);
        
        fedexComWsRateV26.Contact Contact=new fedexComWsRateV26.Contact(); 
        Contact.PersonName='JP';
        Contact.CompanyName='JPP';
        Contact.PhoneNumber='456456';
        Contact.EMailAddress='AA@AA.CL';
        
        list<string> re=new list<string>();
        re.add('MI CASA 123');
        fedexComWsRateV26.Address Address=new fedexComWsRateV26.Address();
        Address.StreetLines=re;
        Address.City='SANTIAGO';
        Address.StateOrProvinceCode='RM';
        Address.PostalCode='99999';
        Address.CountryCode='CL'; 
        
        fedexComWsRateV26.Party Shipper=new fedexComWsRateV26.Party();
        Shipper.AccountNumber='510087100';
        Shipper.Tins=Tins;
        Shipper.Contact=Contact;
        Shipper.Address=Address;
        
        fedexComWsRateV26.Party Recipient=new fedexComWsRateV26.Party();
        Recipient.AccountNumber='510087100';
        Recipient.Tins=Tins;
        Recipient.Contact=Contact;
        Recipient.Address=Address;
        
        
        
        fedexComWsRateV26.Party ResponsibleParty=new fedexComWsRateV26.Party();
        ResponsibleParty.AccountNumber='510087100';
        ResponsibleParty.Tins=Tins;
        ResponsibleParty.Contact=Contact;
        ResponsibleParty.Address=Address;
        
        fedexComWsRateV26.Payor Payor =new fedexComWsRateV26.Payor();
        Payor.ResponsibleParty=ResponsibleParty;
        
        fedexComWsRateV26.Payment ShippingChargesPayment=new  fedexComWsRateV26.Payment();
        ShippingChargesPayment.PaymentType='SENDER';
        ShippingChargesPayment.Payor=Payor ;
        
        fedexComWsRateV26.Money CustomsValue=new fedexComWsRateV26.Money();
        CustomsValue.Currency_x='USD';
        CustomsValue.Amount=100.00;
        
        fedexComWsRateV26.Weight Weight=new fedexComWsRateV26.Weight();
        Weight.Units='KG';
        Weight.Value=1;
        
        fedexComWsRateV26.Money UnitPrice=new   fedexComWsRateV26.Money();
        UnitPrice.Currency_x='USD';
        UnitPrice.Amount=3.00;
        
        fedexComWsRateV26.Money CustomsValue2=new   fedexComWsRateV26.Money();
        CustomsValue2.Currency_x='USD';
        CustomsValue2.Amount=100.00;
        
        list<fedexComWsRateV26.Commodity> Commodities=new list<fedexComWsRateV26.Commodity>();
        fedexComWsRateV26.Commodity Commod=new fedexComWsRateV26.Commodity();
        Commod.NumberOfPieces=1;
        Commod.Description='tets';
        Commod.CountryOfManufacture='Santiago' ;
        Commod.Weight=Weight;
        Commod.Quantity=1;
        Commod.QuantityUnits='CM';
        Commod.UnitPrice=UnitPrice;
        Commod.CustomsValue=CustomsValue2;
        Commodities.add(Commod);
        
        fedexComWsRateV26.CustomsClearanceDetail CustomsClearanceDetail=new fedexComWsRateV26.CustomsClearanceDetail();
        CustomsClearanceDetail.DutiesPayment=ShippingChargesPayment;
        CustomsClearanceDetail.CustomsValue=CustomsValue;
        CustomsClearanceDetail.Commodities=Commodities;
        
        list<string> rr=new list<string>(); 
        rr.add('LIST');
        fedexComWsRateV26.RequestedShipment RequestedShipment=new fedexComWsRateV26.RequestedShipment();
        RequestedShipment.ShipTimestamp= '2020-03-02T14:34:56-06:00' ;
        RequestedShipment.DropoffType='REGULAR_PICKUP';
        RequestedShipment.ServiceType='INTERNATIONAL_PRIORITY';
        RequestedShipment.PackagingType='YOUR_PACKAGING';
        RequestedShipment.TotalWeight=TotalWeight;
        RequestedShipment.Shipper=Shipper;
        RequestedShipment.Recipient=Recipient;
        RequestedShipment.ShippingChargesPayment=ShippingChargesPayment;
        RequestedShipment.CustomsClearanceDetail=CustomsClearanceDetail;
        RequestedShipment.RateRequestTypes=rr;
        RequestedShipment.PackageCount=1;
       
        if(!test.isRunningTest()){
            resp=fr.getRates(WebAuthenticationDetail, ClientDetail, TransactionDetail, Version, RequestedShipment);
        
        system.debug('resp'+resp.HighestSeverity);
        }
        return null;
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