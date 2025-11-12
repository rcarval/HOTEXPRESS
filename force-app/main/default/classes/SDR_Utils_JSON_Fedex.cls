public with sharing class SDR_Utils_JSON_Fedex {

    private static final Map<String, String> countryCodeMap = new Map<String, String>{
        'Afg,anistán' => 'AF',
        'albania' => 'AL',
        'argelia' => 'DZ',
        'samoa americana' => 'AS',
        'andorra' => 'AD',
        'angola' => 'AO',
        'anguila' => 'AI',
        'antartida' => 'AQ',
        'antigua, barbuda' => 'AG',
        'argentina' => 'AR',
        'armenia' => 'AM',
        'aruba' => 'AW',
        'australia' => 'AU',
        'austria' => 'AT',
        'azerbaiyan' => 'AZ',
        'bahamas' => 'BS',
        'bahrein' => 'BH',
        'banglades' => 'BD',
        'barbados' => 'BB',
        'bielorrusia' => 'BY',
        'belgica' => 'BE',
        'belice' => 'BZ',
        'benin' => 'BJ',
        'bermudas' => 'BM',
        'butan' => 'BT',
        'bolivia' => 'BO',
        'bonaire, caribe holandes, saba, san eustaquio' => 'BQ',
        'bosnia y herzegovina' => 'BA',
        'botswana' => 'BW',
        'isla bouvet' => 'BV',
        'brasil' => 'BR',
        'territorio britanico del oceano indico' => 'IO',
        'brunei' => 'BN',
        'bulgaria' => 'BG',
        'burkina faso' => 'BF',
        'burundi' => 'BI',
        'camboya' => 'KH',
        'camerun' => 'CM',
        'canada' => 'CA',
        'cabo verde' => 'CV',
        'republica centroafricana' => 'CF',
        'chad' => 'TD',
        'chile' => 'CL',
        'china' => 'CN',
        'isla navidad' => 'CX',
        'islas cocos (keeling)' => 'CC',
        'colombia' => 'CO',
        'comoros' => 'KM',
        'congo' => 'CG',
        'congo, republica democratica del' => 'CD',
        'islas cook' => 'CK',
        'costa rica' => 'CR',
        'croacia' => 'HR',
        'cuba' => 'CU',
        'curazao' => 'CW',
        'chipre' => 'CY',
        'republica checa' => 'CZ',
        'dinamarca' => 'DK',
        'yibuti' => 'DJ',
        'dominica' => 'DM',
        'republica dominicana' => 'DO',
        'timor oriental' => 'TL',
        'ecuador' => 'EC',
        'egipto' => 'EG',
        'el salvador' => 'SV',
        'inglaterra, gran bretana, irlanda del norte, escocia, reino unido, gales, islas del canal' => 'GB',
        'guinea ecuatorial' => 'GQ',
        'eritrea' => 'ER',
        'estonia' => 'EE',
        'esuatini' => 'SZ',
        'etiopia' => 'ET',
        'islas faroe' => 'FO',
        'islas malvinas (falkland)' => 'FK',
        'fiyi' => 'FJ',
        'finlandia' => 'FI',
        'francia' => 'FR',
        'guayana francesa' => 'GF',
        'territorios franceses del sur' => 'TF',
        'gabon' => 'GA',
        'gambia' => 'GM',
        'georgia' => 'GE',
        'alemania' => 'DE',
        'ghana' => 'GH',
        'gibraltar' => 'GI',
        'gran caiman, islas caiman' => 'KY',
        'isla gran thatch, islas gran tobago, islas jost van dyke, isla norman, isla tortola, islas virgenes britanicas' => 'VG',
        'grecia' => 'GR',
        'groenlandia' => 'GL',
        'granada' => 'GD',
        'guadalupe' => 'GP',
        'guam' => 'GU',
        'guatemala' => 'GT',
        'guinea' => 'GN',
        'guinea bissau' => 'GW',
        'guyana' => 'GY',
        'haiti' => 'HT',
        'islas heard y mcdonald' => 'HM',
        'honduras' => 'HN',
        'hong kong' => 'HK',
        'hungria' => 'HU',
        'islandia' => 'IS',
        'india' => 'IN',
        'indonesia' => 'ID',
        'iran' => 'IR',
        'irak' => 'IQ',
        'irlanda' => 'IE',
        'israel' => 'IL',
        'italia, ciudad de vaticano, san marino' => 'IT',
        'costa de marfil' => 'CI',
        'jamaica' => 'JM',
        'japon' => 'JP',
        'jordania' => 'JO',
        'kazajstan' => 'KZ',
        'kenya' => 'KE',
        'kiribati' => 'KI',
        'kuwait' => 'KW',
        'kirguizistan' => 'KG',
        'laos' => 'LA',
        'letonia' => 'LV',
        'libano' => 'LB',
        'lesoto' => 'LS',
        'liberia' => 'LR',
        'libia' => 'LY',
        'liechtenstein' => 'LI',
        'lituania' => 'LT',
        'luxemburgo' => 'LU',
        'macao' => 'MO',
        'macedonia' => 'MK',
        'madagascar' => 'MG',
        'malawi' => 'MW',
        'malasia' => 'MY',
        'maldivas' => 'MV',
        'mali' => 'ML',
        'malta' => 'MT',
        'islas marshall' => 'MH',
        'martinica' => 'MQ',
        'mauritania' => 'MR',
        'mauricio' => 'MU',
        'mayotte' => 'YT',
        'mexico' => 'MX',
        'micronesia' => 'FM',
        'moldavia' => 'MD',
        'monaco' => 'MC',
        'mongolia' => 'MN',
        'montenegro' => 'ME',
        'montserrat' => 'MS',
        'marruecos' => 'MA',
        'mozambique' => 'MZ',
        'myanmar/birmania' => 'MM',
        'namibia' => 'NA',
        'nauru' => 'NR',
        'nepal' => 'NP',
        'paises bajos, holanda' => 'NL',
        'nueva caledonia' => 'NC',
        'nueva zelanda' => 'NZ',
        'nicaragua' => 'NI',
        'niger' => 'NE',
        'nigeria' => 'NG',
        'niue' => 'NU',
        'isla norfolk' => 'NF',
        'corea del norte' => 'KP',
        'islas marianas del norte, rota, saipan, tinian' => 'MP',
        'noruega' => 'NO',
        'oman' => 'OM',
        'pakistan' => 'PK',
        'palaos' => 'PW',
        'palestina' => 'PS',
        'panama' => 'PA',
        'papua nueva guinea' => 'PG',
        'paraguay' => 'PY',
        'peru' => 'PE',
        'filipinas' => 'PH',
        'pitcairn' => 'PN',
        'polonia' => 'PL',
        'portugal' => 'PT',
        'puerto rico' => 'PR',
        'catar' => 'QA',
        'reunion' => 'RE',
        'rumania' => 'RO',
        'rusia' => 'RU',
        'ruanda' => 'RW',
        'samoa' => 'WS',
        'santo tome y principe' => 'ST',
        'arabia saudita' => 'SA',
        'senegal' => 'SN',
        'serbia' => 'RS',
        'seychelles' => 'SC',
        'sierra leona' => 'SL',
        'singapur' => 'SG',
        'republica eslovaca' => 'SK',
        'eslovenia' => 'SI',
        'islas salomon' => 'SB',
        'somalia' => 'SO',
        'sudafrica' => 'ZA',
        'islas georgia del sur y sandwich del sur' => 'GS',
        'corea del sur' => 'KR',
        'espana, islas canarias' => 'ES',
        'sri lanka' => 'LK',
        'san bartolome' => 'BL',
        'san cristobal, san kitts y nevis' => 'KN',
        'san juan, san tomas, islas virgenes de los estados unidos, isla de santa cruz' => 'VI',
        'santa helena' => 'SH',
        'santa lucia' => 'LC',
        'san martin (dominio holandes)' => 'SX',
        'san martin (dominio frances)' => 'MF',
        'san pierre' => 'PM',
        'san vicente, isla union' => 'VC',
        'sudan' => 'SD',
        'surinam' => 'SR',
        'islas svalbard y jan mayen' => 'SJ',
        'suecia' => 'SE',
        'suiza' => 'CH',
        'siria' => 'SY',
        'tahiti, polinesia francesa' => 'PF',
        'taiwan' => 'TW',
        'tayikistan' => 'TJ',
        'tanzania' => 'TZ',
        'tailandia' => 'TH',
        'togo' => 'TG',
        'tokelau' => 'TK',
        'tonga' => 'TO',
        'trinidad y tobago' => 'TT',
        'tunez' => 'TN',
        'turquia' => 'TR',
        'turkmenistan' => 'TM',
        'islas turcas y caicos' => 'TC',
        'tuvalu' => 'TV',
        'islas ultramarinas menores de estados unidos' => 'UM',
        'uganda' => 'UG',
        'ucrania' => 'UA',
        'emiratos arabes unidos' => 'AE',
        'estados unidos' => 'US',
        'uruguay' => 'UY',
        'uzbekistan' => 'UZ',
        'vanuatu' => 'VU',
        'venezuela' => 'VE',
        'vietnam' => 'VN',
        'islas wallis y futuna' => 'WF',
        'sahara occidental' => 'EH',
        'yemen' => 'YE',
        'zambia' => 'ZM',
        'zimbabue' =>	'ZW'
    };
        
    
        public static List<String> splitTextMetod(String text, Integer maxLength) {
            List<String> result = new List<String>();
            if (String.isBlank(text) || maxLength <= 0) {
                return result;
            }
            String remaining = text.trim();
            while (remaining.length() > maxLength) {
                Integer splitPos = remaining.lastIndexOf(' ', maxLength);
                if (splitPos <= 0) {
                    splitPos = maxLength;
                }
                String part = remaining.substring(0, splitPos).trim();
                result.add(part);
                remaining = remaining.substring(splitPos).trim();
            }
            if (!String.isBlank(remaining)) {
                result.add(remaining);
            }
            return result;
        }

    public class CommodityWrapper {
        public Decimal quantity;
        public Decimal unitPriceAmount;
    }
    
    public static String getCountryCode(String countryName) {
        if (String.isBlank(countryName)) {
            return '';
        }
        String normalizedName = countryName.trim().toLowerCase();
        return countryCodeMap.containsKey(normalizedName) ? countryCodeMap.get(normalizedName) : '';
    }
    // public class FedexHelper {}
    
        private static final Map<String, String> PACKAGING_TYPE_MAP = new Map<String, String>{
            'cajas'  => 'YOUR_PACKAGING',
            'sobre'  => 'FEDEX_ENVELOPE',
            'pack'   => 'FEDEX_PAK',
            'pallet' => 'YOUR_PACKAGING'
        };
        
        public static String getFedexPackagingType(String embalajeHOT) {
            if (String.isBlank(embalajeHOT)) {
                return 'YOUR_PACKAGING'; // Valor por defecto si viene vacío
            }
    
            String normalizedValue = embalajeHOT.trim().toLowerCase();
            return PACKAGING_TYPE_MAP.containsKey(normalizedValue) ? PACKAGING_TYPE_MAP.get(normalizedValue) : 'YOUR_PACKAGING'; // También default si no encuentra match
        }   
   

    public static String generarJSONShipment(String idGuia){                           
        
        Guias_de_Exportacion__c guia;
        String msjErr = 'No se encontró la guía de exportación con el ID proporcionado.';
        try
        {
        	guia = [SELECT  Id, Name, Contacto__r.Name, Contacto__r.MobilePhone, ID_Remitente__r.Name, Contacto__r.MailingAddress,Contacto__r.MailingCity,
                                                Contacto__r.MailingState, Contacto__r.MailingPostalCode, Contacto__r.MailingCountry, Contacto_Destinatario__c, Telefono_Destinatario__c,
                                                Direccion_Destinatario__r.Telefono__c, Direccion_Destinatario__r.Cuenta__r.Name, Direccion_Destinatario__r.Name, Direccion_Destinatario__r.Pais__r.Cod_Pais__c,
                                                Direccion_Destinatario__r.Direccion__c, Direccion_Destinatario__r.Ciudad__c, Direccion_Destinatario__r.Cod_Pais__c ,Calle__c,
                                                Direccion_Destinatario__r.Estado_Provincia__c, Direccion_Destinatario__r.Codigo_Postal__c, Breve_Descripcion__c, Fecha_de_Envio__c,
                                                Embalaje_HOT__c, Paquetes__c, Valor_Total_del_Contenido__c, Divisa__c, Breve_Descripcion_2__c, Breve_Descripcion_3__c,
                                                Breve_Descripcion_4__c, Unidad_de_Medida__c, Peso_Agente__c, Largo__c, Ancho__c, Alto__c, Tipo_Contenido__c, DDP__c,
                                        		Contacto__r.MailingStreet, Envio_Particular_a_Particular__c, Shipper_Original__c, Direccion_Destinatario__r.Pais__r.Name, Seguro__c, Pais__c
                                        FROM Guias_de_Exportacion__c WHERE Id =: idGuia];
            Account acc = [SELECT Id, Name, OwnerId, Owner.Name, Phone, BillingAddress, BillingCity, BillingState, BillingPostalCode, BillingCountry, ShippingCountry, BillingStreet  FROM Account WHERE Name ='HOT Express S.A.'];
    
            /*
            accountNumberFedex__mdt accRecord = [SELECT accountNumber__c FROM accountNumberFedex__mdt LIMIT 1];
            String accountNumberFedex = accRecord.accountNumber__c;
        	*/
        // Consulta la guía
        // Guias_de_Exportacion__c guiaDescripciones = [
        //     SELECT Id, Breve_Descripcion__c, Breve_Descripcion_2__c, Breve_Descripcion_3__c, Breve_Descripcion_4__c
        //     FROM Guias_de_Exportacion__c 
        //     WHERE Id = :idGuia
        // ];

        // Lista para almacenar las descripciones válidas (no nulas ni vacías)
        // List<String> descripciones = new List<String>();

        // Validamos y agregamos solo las descripciones no nulas y no vacías
        // if (!String.isBlank(guia.Breve_Descripcion__c)) {
        //     descripciones.add(guia.Breve_Descripcion__c);
        // }
        // if (!String.isBlank(guia.Breve_Descripcion_2__c)) {
        //     descripciones.add(guia.Breve_Descripcion_2__c);
        // }
        // if (!String.isBlank(guia.Breve_Descripcion_3__c)) {
        //     descripciones.add(guia.Breve_Descripcion_3__c);
        // }
        // if (!String.isBlank(guia.Breve_Descripcion_4__c)) {
        //     descripciones.add(guia.Breve_Descripcion_4__c);
        // }

        // Decimal cantidadDescripciones = descripciones.size();
        // System.debug('Cantidad de descripciones: ' + cantidadDescripciones);

        Integer valorSeguroCero = 0;

        // Validar si la guía existe
        system.debug('guia: '+guia);
        system.debug('guia.Id: '+guia.Id);
    
        // Validar campos críticos
        if (guia.Contacto__r == null || String.isBlank(guia.Contacto__r.Name) || String.isBlank(guia.Contacto__r.MobilePhone)) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos del remitente (nombre o teléfono).');
            ApexPages.addMessage(msg);
        }
        if (guia.Direccion_Destinatario__r == null || String.isBlank(guia.Direccion_Destinatario__r.Name) || 
            String.isBlank(guia.Direccion_Destinatario__r.Direccion__c)) {
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos del destinatario (nombre o dirección).');
            ApexPages.addMessage(msg);
        }
        if (guia.Paquetes__c == null || guia.Peso_Agente__c == null || guia.Largo__c == null || 
            guia.Ancho__c == null || guia.Alto__c == null) {
            
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Faltan datos de dimensiones o peso del paquete.');
            ApexPages.addMessage(msg);
        }

        List<Contenido_Envio__c> lstContenidoEnvio = [SELECT    Id, Total__c, Valor_Unitario__c, Cantidad__c, Descripcion__c, Unidad_de_Medida__c, Pais_fab__r.Name, Pais_fab__r.Cod_Pais__c 
                                                      FROM Contenido_Envio__c WHERE Pickup__c =: guia.Id];
        system.debug('lstContenidoEnvio: '+lstContenidoEnvio);


        String tipoServicio = 'FEDEX_INTERNATIONAL_PRIORITY';
        //String tipoServicio ='FEDEX_EXPRESS_SAVER';
        
        // String tipoServicio = 'FEDEX_INTERNATIONAL_ECONOMY'; // Cambiar a FEDEX_INTERNATIONAL_PRIORITY si es necesario
        // String tipoServicio = 'FEDEX_INTERNATIONAL_FIRST'; // Cambiar a FEDEX_INTERNATIONAL_PRIORITY si es necesario
        // String tipoServicio = 'FEDEX_EXPRESS_SAVER';
        String paymentTypeRecipient;
        String paymentTypeDuties;
        if(guia.DDP__c){
            paymentTypeRecipient = 'SENDER';
            paymentTypeDuties = 'SENDER';
        }else{                        
            paymentTypeRecipient = 'SENDER';
            paymentTypeDuties = 'RECIPIENT';
        }
        JSONGenerator gen = JSON.createGenerator(true);
        try {
            gen.writeStartObject();
                gen.writeStringField('labelResponseOptions', 'URL_ONLY');
                gen.writeStringField('mergeLabelDocOption', 'LABELS_AND_DOCS');                
                gen.writeFieldName('requestedShipment');                
                gen.writeStartObject();
                    gen.writeFieldName('shipper');  
                    gen.writeStartObject();                            
                        gen.writeFieldName('contact');
                        gen.writeStartObject();
								if(guia.Shipper_Original__c){
                                    system.debug('Adentro if shipper true');
                                    gen.writeStringField('personName', guia.Contacto__r.Name);                
                                	gen.writeStringField('phoneNumber', guia.Contacto__r.MobilePhone);                
                                	gen.writeStringField('companyName', guia.Envio_Particular_a_Particular__c ? guia.Contacto__r.Name : guia.ID_Remitente__r.Name);                
                                }else if(guia.Shipper_Original__c == false){ //|| guia.Envio_Particular_a_Particular__c == true
                                    system.debug('Adentro if shipper false');
                                    gen.writeStringField('companyName', acc.Name);
                                    gen.writeStringField('personName', acc.Owner.Name);
                                    gen.writeStringField('phoneNumber', acc.Phone);
                                    gen.writeStringField('direccion', acc.BillingStreet != null ?  acc.BillingStreet : '');
                                    
                                } 
            
            				else {
                                    system.debug('Adentro if shipper true');
                                    gen.writeStringField('personName', guia.Contacto__r.Name);                
                                    gen.writeStringField('phoneNumber', guia.Contacto__r.MobilePhone);                
                                    gen.writeStringField('companyName', guia.Envio_Particular_a_Particular__c ? guia.Contacto__r.Name : guia.ID_Remitente__r.Name);
                                
                                    // system.debug('Adentro if shipper false');
                                    // gen.writeStringField('companyName', acc.Name);
                                    // gen.writeStringField('personName', acc.Owner.Name);
                                    // gen.writeStringField('phoneNumber', acc.Phone);
                                    // gen.writeStringField('direccion', acc.BillingStreet != null ?  acc.BillingStreet : '');
                                 }                            
                            gen.writeEndObject();
                            gen.writeFieldName('address');
            
            
                           /*
                            *  gen.writeStartObject();
                                gen.writeFieldName('streetLines');
                                //Si la direccion supera largo 35 agregar los caracteres restantes en otra posicion
                                String[] auxMailingStreet = new List<String>();
                                if(guia.Contacto__r.MailingStreet.length() >= 35){
                                    auxMailingStreet = splitText(guia.Contacto__r.MailingStreet);                                                
                                }
            					system.debug('auxMailingStreet: '+auxMailingStreet);
            					gen.writeStartArray();
                                if(auxMailingStreet.size() > 0){
                                    for(String str : auxMailingStreet){                                        
                                        gen.writeString(str);                                                                                        
                                    }                                                
                                }else{                                    
                                    gen.writeString(guia.Contacto__r.MailingStreet);                                                                                    
                                }      
            					gen.writeEndArray();
								*/
            
                                gen.writeStartObject();
                                gen.writeFieldName('streetLines');
                                
                                // Si la dirección supera largo 35, agregar los caracteres restantes en otra posición
                                String[] auxMailingStreet = new List<String>();
                                
                                if (!String.isBlank(guia.Contacto__r.MailingStreet)) {
                                    Integer maxLength = 35;
                                    List<String> palabras = guia.Contacto__r.MailingStreet.split(' ');
                                    String lineaActual = '';
                                
                                    for (String palabra : palabras) {
                                        if ((lineaActual.length() + palabra.length() + 1) <= maxLength) {
                                            if (lineaActual == '') {
                                                lineaActual = palabra;
                                            } else {
                                                lineaActual += ' ' + palabra;
                                            }
                                        } else {
                                            auxMailingStreet.add(lineaActual);
                                            lineaActual = palabra;
                                        }
                                    }
                                
                                    if (!String.isBlank(lineaActual)) {
                                        auxMailingStreet.add(lineaActual);
                                    }
                                }
                                
                                System.debug('auxMailingStreet: ' + auxMailingStreet);
                                
                                gen.writeStartArray();
                                if (auxMailingStreet.size() > 0) {
                                    for (String str : auxMailingStreet) {
                                        gen.writeString(str);
                                    }
                                } else {
                                    gen.writeString(guia.Contacto__r.MailingStreet);
                                }
                                gen.writeEndArray();
            
            

                                //  gen.writeStringField('city', guia.Direccion_Destinatario__r.Ciudad__c);                
                                //  gen.writeStringField('stateOrProvinceCode', guia.Direccion_Destinatario__r.Estado_Provincia__c);                
                                //  gen.writeStringField('postalCode', String.valueOf(guia.Direccion_Destinatario__r.Codigo_Postal__c)); 
                                //  gen.writeStringField('countryCode', 'CL'); 
                                gen.writeStringField('city', guia.Contacto__r.MailingCity != null ? guia.Contacto__r.MailingCity : '');                
                                gen.writeStringField('stateOrProvinceCode', guia.Contacto__r.MailingState != null ? guia.Contacto__r.MailingState : '');                
                                gen.writeStringField('postalCode', guia.Contacto__r.MailingPostalCode != null ? guia.Contacto__r.MailingPostalCode : ''); 
                                gen.writeStringField('countryCode', getCountryCode(guia.Contacto__r.MailingCountry) != NULL ? getCountryCode(guia.Contacto__r.MailingCountry) : 'CL');
                                // gen.writeStringField('countryCode', guia.Contacto__r.MailingCountry != NULL ? guia.Contacto__r.MailingCountry : getCountryCode(guia.Contacto__r.MailingCountry));


                            gen.writeEndObject();            
                        gen.writeEndObject(); 
                            gen.writeFieldName('recipients');
                                gen.writeStartArray();
                                    gen.writeStartObject();
                                        gen.writeFieldName('contact');
                                        gen.writeStartObject();
            								//if(guia.Shipper_Original__c){
                                            if (guia.Envio_Particular_a_Particular__c) {
                                                system.debug('Adentro if shipper false');
                                                gen.writeStringField('personName', guia.Contacto_Destinatario__c);
                                                gen.writeStringField('companyName', guia.Direccion_Destinatario__r.Name != null ? guia.Contacto_Destinatario__c: '');
                                                gen.writeStringField('phoneNumber', guia.Telefono_Destinatario__c);      
                                            } else {
                                                // Si no, usamos la dirección del destinatario
                                                system.debug('Adentro if shipper false');
                                                gen.writeStringField('personName', guia.Contacto_Destinatario__c);
                                                gen.writeStringField('companyName', guia.Direccion_Destinatario__r.Name != null ? guia.Direccion_Destinatario__r.Name : '');
                                                gen.writeStringField('phoneNumber', guia.Telefono_Destinatario__c); 
                                                
                                            }
                                        gen.writeEndObject();  
                                        gen.writeFieldName('address');
                                                gen.writeStartObject();
                                                gen.writeFieldName('streetLines');
                                                
                                                // Obtener la dirección
                                                String direcDestinatario = guia.Calle__c;
                                                System.debug('Calle destinatario : ' + direcDestinatario);
                                                List<String> auxdirecDestinatario = new List<String>();
                                                
                                                if (!String.isBlank(direcDestinatario)) {
                                                    Integer maxLength = 35;
                                                    List<String> palabras = direcDestinatario.trim().split(' ');
                                                    String lineaActual = '';
                                                
                                                    for (String palabra : palabras) {
                                                        if ((lineaActual.length() + palabra.length() + 1) <= maxLength) {
                                                            if (String.isBlank(lineaActual)) {
                                                                lineaActual = palabra;
                                                            } else {
                                                                lineaActual += ' ' + palabra;
                                                            }
                                                        } else {
                                                            auxdirecDestinatario.add(lineaActual);
                                                            lineaActual = palabra;
                                                        }
                                                    }
                                                
                                                    if (!String.isBlank(lineaActual)) {
                                                        auxdirecDestinatario.add(lineaActual);
                                                    }
                                                }
                                                
                                                System.debug('auxdirecDestinatario: ' + auxdirecDestinatario);
                                                
                                                // Escribir el array en el JSON
                                                gen.writeStartArray();
                                                if (auxdirecDestinatario.size() > 0) {
                                                    for (String str : auxdirecDestinatario) {
                                                        gen.writeString(str);
                                                    }
                                                } else {
                                                    gen.writeString(direcDestinatario);
                                                }
                                                gen.writeEndArray();
            
                                                gen.writeStringField('city', guia.Direccion_Destinatario__r.Ciudad__c == null ? '' : guia.Direccion_Destinatario__r.Ciudad__c);                
                                                gen.writeStringField('stateOrProvinceCode', guia.Direccion_Destinatario__r.Estado_Provincia__c == null ? '' : guia.Direccion_Destinatario__r.Estado_Provincia__c);
                                                gen.writeStringField('postalCode', guia.Direccion_Destinatario__r.Codigo_Postal__c == null ? '' : guia.Direccion_Destinatario__r.Codigo_Postal__c); 
                                                // gen.writeStringField('countryCode', getCountryCode(guia.Direccion_Destinatario__r.Cod_Pais__c) != NULL ? getCountryCode(guia.Pais__c) : 'AR');
                                                gen.writeStringField('countryCode', guia.Direccion_Destinatario__r.Cod_Pais__c != NULL ? guia.Direccion_Destinatario__r.Cod_Pais__c : getCountryCode(guia.Direccion_Destinatario__r.Cod_Pais__c));
                                        gen.writeEndObject();                                                                                
                                    gen.writeEndObject();                                      
                                    gen.writeEndArray();  
                                gen.writeStringField('shipDatestamp', String.valueOf(guia.Fecha_de_Envio__c)); // REVISAR FORMATO DE FECHA PERMITIDOS POR FEDEX
                                gen.writeStringField('serviceType', tipoServicio);
                                    gen.writeStringField('packagingType', getFedexPackagingType(guia.Embalaje_HOT__c) != NULL ? getFedexPackagingType(guia.Embalaje_HOT__c) : 'YOUR_PACKAGING'); // Utilizar el método para obtener el tipo de embalaje

                                // Al generar el JSON:
                                gen.writeStringField('pickupType', 'USE_SCHEDULED_PICKUP');
                                gen.writeFieldName('shippingChargesPayment');
                                //Si el campo DDP esta marcado paga el recipient sino el sender
                                gen.writeStartObject();
                                    gen.writeStringField('paymentType', paymentTypeRecipient);                                    
                                gen.writeEndObject();                              
                                gen.writeFieldName('labelSpecification');
                                gen.writeStartObject();
                                    gen.writeStringField('labelFormatType', 'COMMON2D'); // Campo requerido agregado
                                    gen.writeStringField('imageType', 'PDF');
                                    gen.writeStringField('labelStockType', 'STOCK_4X6');
                                    gen.writeStringField('labelOrder', 'SHIPPING_LABEL_FIRST');
                                    gen.writeFieldName('customerSpecifiedDetail');
                                    gen.writeStartObject();
                                            gen.writeFieldName('maskedData');
                                            gen.writeStartArray();
                                                gen.writeString('TRANSPORTATION_CHARGES_PAYOR_ACCOUNT_NUMBER');
                                                gen.writeString('DUTIES_AND_TAXES_PAYOR_ACCOUNT_NUMBER');
                                            gen.writeEndArray();
                                    gen.writeEndObject();
                                gen.writeEndObject(); 
                                gen.writeFieldName('requestedPackageLineItems');
                                gen.writeStartArray();
                                /**
                                 * INICIAR IMPLEMENTACIÓN DEL FOR PARA ITERAR TODOS LOS PAQUETES/ITEMS EN LA LISTA DE CONTENIDO DE ENVIO
                                 */
                                	gen.writeStartObject(); 
                                        gen.writeNumberField('groupPackageCount', guia.Paquetes__c ); // 1 - guia.Paquetes__c     //groupCount                                   
                                        gen.writeStringField('itemDescriptionForClearance', '');
                                        gen.writeFieldName('declaredValue');
                                        gen.writeStartObject();
                                            Decimal total = guia.Valor_Total_del_Contenido__c;
                                            Integer units = (guia.Paquetes__c != null && guia.Paquetes__c > 0) ? Integer.valueOf(guia.Paquetes__c) : 1;
                                            Decimal base = (total / units).setScale(6, RoundingMode.DOWN);
                                            Decimal rest = total - (base * units);
                                            Decimal declaredAmount = base + rest - 0.00001; // Suma el resto solo una vez
                                            gen.writeNumberField('amount', guia.Seguro__c ? declaredAmount.setScale(6, RoundingMode.HALF_UP) : valorSeguroCero);
                                            gen.writeStringField('currency', guia.Divisa__c);
                                        gen.writeEndObject();
                                        gen.writeFieldName('customerReferences');                                          
                                        gen.writeStartArray();                                        
                                            gen.writeStartObject(); 
                                                gen.writeStringField('customerReferenceType', 'CUSTOMER_REFERENCE');
                                                gen.writeStringField('value', guia.Name);
                                            gen.writeEndObject();
                                        
                                        // Iterar sobre los ítems relacionados
                                        gen.writeEndArray();    
                
                                        gen.writeFieldName('weight');
                                        gen.writeStartObject(); 
                                            gen.writeStringField('units', 'KG');
                                            Decimal pesoPorPaquete = guia.Peso_Agente__c / guia.Paquetes__c;
                                            gen.writeNumberField('value', pesoPorPaquete.setScale(6, RoundingMode.DOWN)); // Peso_Agente__c / Paquetes__c
                                        gen.writeEndObject();  
                                        gen.writeFieldName('dimensions');
                                        gen.writeStartObject(); 
                                                 gen.writeNumberField('width', guia.Ancho__c != null ? guia.Ancho__c : 0);
                                                gen.writeNumberField('length', guia.Largo__c != null ? guia.Largo__c : 0);
                                                gen.writeNumberField('height',  guia.Alto__c != null ? guia.Alto__c : 0);
                                                gen.writeStringField('units', 'CM');                                       
                                        gen.writeEndObject();
                                    gen.writeEndObject();
                                    /**
                                     * END IMPLEMENTACIÓN DEL FOR PARA ITERAR TODOS LOS PAQUETES/ITEMS EN LA LISTA DE CONTENIDO DE ENVIO
                                     */
                                gen.writeEndArray();   
                                gen.writeFieldName('customsClearanceDetail');
                                gen.writeStartObject(); 
                                    gen.writeFieldName('commodities');
                                    gen.writeStartArray();
                                    Integer contador = 1; // Contador para manejar las descripciones de contenido
                                        if (lstContenidoEnvio.size() > 0)
                                        {
                                            for(Contenido_Envio__c contenido : lstContenidoEnvio)
                                        {  
                                        	gen.writeStartObject(); 
                                            	gen.writeFieldName('unitPrice');
                                            	gen.writeStartObject(); 
                                            		//gen.writeNumberField('amount', guia.Valor_Total_del_Contenido__c); //valorTotal - contenido.Valor_Unitario__c
                                            		decimal varAmount = guia.Valor_Total_del_Contenido__c;
                                            		varAmount = varAmount / guia.Paquetes__c;
                                            
                                            		gen.writeNumberField('amount', varAmount); //valorTotal - contenido.Valor_Unitario__c
                                            		
                                            		gen.writeStringField('currency',  guia.Divisa__c);
                                            	gen.writeEndObject();

                                             
                                                    if(contador == 1){
                                                        gen.writeStringField('description', guia.Breve_Descripcion__c != null ? guia.Breve_Descripcion__c : 'S/D');//contenido.Descripcion__c   
                                                        
                                                    } else if(contador == 2){
                                                        gen.writeStringField('description', guia.Breve_Descripcion_2__c != null ? guia.Breve_Descripcion_2__c : 'S/D');
                                                        
                                                    } else if(contador == 3){
                                                        gen.writeStringField('description', guia.Breve_Descripcion_3__c != null ? guia.Breve_Descripcion_3__c : 'S/D');                                                    
                                                    } else if(contador == 4){
                                                        gen.writeStringField('description', guia.Breve_Descripcion_4__c != null ? guia.Breve_Descripcion_4__c : 'S/D');
                                                    }
                                                    else //en el caso que tenga mas de 4 contenidos
                                                    {
                                                        gen.writeStringField('description', 'S/D');
                                                    }

                                            	gen.writeNumberField('quantity', guia.Paquetes__c); // groupCountcontenido.Cantidad__c
                                            	//gen.writeNumberField('quantity', guia.Paquetes__c); // groupCountcontenido.Cantidad__c
                                            	gen.writeStringField('quantityUnits', 'EA');//Corroborar en productivo //String.valueOf(guia.Paquetes__c)
                                            	gen.writeFieldName('weight');
                                            	gen.writeStartObject();    
                                            		gen.writeStringField('units', 'KG');
                                                    // Decimal pesoTotalGuia = guia.Peso_Agente__c;
                                                    Integer totalCommodities = lstContenidoEnvio.size();
                                                    // Decimal pesoPorCommodity = (pesoTotalGuia / totalCommodities).setScale(6, RoundingMode.DOWN);
                                                    Decimal pesoPorCommoditie = guia.Peso_Agente__c / guia.Paquetes__c;
                                                    Decimal pesoPorCommoditieRounded = pesoPorCommoditie / totalCommodities;
                                                    gen.writeNumberField('value', pesoPorCommoditieRounded.setScale(2, RoundingMode.DOWN)); // Peso_Agente__c / Paquetes__c
                                            		//gen.writeNumberField('value', contenido.Cantidad__c > guia.Peso_Agente__c ? guia.Peso_Agente__c : contenido.Cantidad__c);//contenido.Cantidad__c > guia.Peso_Agente__c ? guia.Peso_Agente__c : contenido.Cantidad__c
                                            	gen.writeEndObject();
                                            
                                            	gen.writeFieldName('customsValue');
                                            	gen.writeStartObject();
                                                decimal varAmountValue = guia.Valor_Total_del_Contenido__c;
                                                
                                                Integer totalValorCommodities = lstContenidoEnvio.size();
                                                Decimal valorPorCommodity = (varAmountValue / totalCommodities).setScale(6, RoundingMode.DOWN);
                                            		gen.writeNumberField('amount', valorPorCommodity); // valorTotal - Valor total para aduana
                                                    //gen.writeNumberField('amount', contenido.Valor_Unitario__c); // valorTotal - Valor total para aduana
                                                    gen.writeStringField('currency', guia.Divisa__c);
                                            	gen.writeEndObject(); 
                                            
                                            	//system.debug('guia.Pais__c ' + guia.Pais__c);
                                            	gen.writeStringField('countryOfManufacture', guia.Direccion_Destinatario__r.Pais__r.Cod_Pais__c); // getCountryCode(guia.Pais__c)
                                            	//gen.writeStringField('countryOfManufacture', contenido.Pais_fab__r.Cod_Pais__c);
                                            	gen.writeNumberField('numberOfPieces', guia.Paquetes__c); // groupCount
                                            	gen.writeStringField('name', guia.Tipo_Contenido__c);
                                            gen.writeEndObject();
                                        contador++;
                                        }
                                    }

                                    gen.writeEndArray();                                      
                                    gen.writeFieldName('dutiesPayment');
                                    gen.writeStartObject();                                                                                        
                                        gen.writeStringField('paymentType', paymentTypeDuties);    
                                        gen.writeFieldName('payor');
                                        gen.writeStartObject();  
                                            gen.writeFieldName('responsibleParty');
                                            gen.writeStartObject();    
                                                gen.writeFieldName('accountNumber');
                                                gen.writeStartObject();
                                                        gen.writeStringField('value', guia.DDP__c == true ? '740561073' : '740561073'); // 228013862 Prd || 740561073 Sdx Solo se envía visible si DDP__c es true                                                                            
                                                gen.writeEndObject();     
                                                gen.writeStringField('countryCode', guia.Direccion_Destinatario__r.Cod_Pais__c != NULL ? guia.Direccion_Destinatario__r.Cod_Pais__c : getCountryCode(guia.Direccion_Destinatario__r.Cod_Pais__c)); //'ARG'
                                            gen.writeEndObject();                                                                                                                                  
                                        gen.writeEndObject();
                                    gen.writeEndObject(); 
                                    gen.writeStringField('documentContent', guia.Tipo_Contenido__c);                                                                              
                                gen.writeEndObject();                                                                                                      
                    gen.writeEndObject();
                    gen.writeFieldName('accountNumber');
                    gen.writeStartObject();    
                            gen.writeStringField('value', '740561073'); //228013862 Prd || 740561073 Sdx Solo se envía visible si DDP__c es false
                    gen.writeEndObject();
                gen.writeEndObject();                                             
            
        } catch (Exception e) {
            //System.debug('Excepcion: '+e.getException());
            System.debug('Mensaje: '+e.getMessage());
            System.debug('Traer la excepcion: '+e.getStackTraceString());                                     
        }
        system.debug('gen.getAsString(): '+gen.getAsString());
        return gen.getAsString();
    
        }
        catch (Exception e)
        {
            if (guia == null) 
            {
            	ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, msjErr);
            	ApexPages.addMessage(msg);
                return e.getMessage();
	        }
            else
            {
                return e.getMessage();
            }
        }
        
        
    }

    public static String generarJSONTracking(String trackingNumber){
        // Tracking number de prueba '794817384940'
        JSONGenerator gen = JSON.createGenerator(true);
        try {
            gen.writeStartObject();                            
                gen.writeFieldName('masterTrackingNumberInfo');
                gen.writeStartObject();
                    gen.writeFieldName('trackingNumberInfo');
                    gen.writeStartObject();
                        gen.writeStringField('trackingNumber',  trackingNumber); 
                    gen.writeEndObject();                                        
                gen.writeEndObject();
                gen.writeStringField('associatedType', 'STANDARD_MPS');
            gen.writeEndObject();
            
        } catch (Exception e) {
            //System.debug('Excepcion: '+e.getException());
            System.debug('Mensaje: '+e.getMessage());
            System.debug('Traer la excepcion: '+e.getStackTraceString()); 
        }
        system.debug('gen.getAsString(): '+gen.getAsString());
        return gen.getAsString();
    }
    public static List<String> splitText(String inputText) {
        List<String> result = new List<String>();
        Integer maxLength = 35;
        // Recorre el texto y lo divide en fragmentos de 35 caracteres
        for (Integer i = 0; i < inputText.length(); i += maxLength) {
            // Extrae una subcadena de hasta 35 caracteres y agrégala al arreglo
            result.add(inputText.substring(i, Math.min(i + maxLength, inputText.length())));
        }
        return result;
    }    
}