@isTest
public class SDR_Utils_JSON_Fedex_Test {
     @testSetup
    static void DataTest()
    {
        // Crear cuenta HOT Express S.A. (requerida por la clase principal)
        Account hotExpress = new Account(
            Name = 'HOT Express S.A.',
            Phone = '111111111',
            BillingStreet = 'Calle Principal 123',
            BillingCity = 'Santiago',
            BillingState = 'RM',
            BillingPostalCode = '8320000',
            BillingCountry = 'Chile'
        );
        insert hotExpress;
        
        // Crear datos de prueba para Guias_de_Exportacion__c
        Account acc = new Account(
          Name = 'EMPRESAS LOURDES S.A.',                  // Razón Social
          Nombre_Fantasia__c = 'LOURDES',                    // Nombre Fantasia
          Phone = '228192104',                               // Teléfono 1
          RUT__c = '79868770-0',                             // RUT
          Telefono_2__c = '228192104',                       // Teléfono 2
          Calidad__c = 'PREMIUM',                            // Calidad
          Website = 'www.chileangrapegroup.com',             // Sitio Web
          Industry = 'Vinos',                                // Sector
          Condicion_Comercial_Global__c = '30 días',         // Condición Comercial Global
          Forma_de_Facturacion__c = 'Fin de Mes',            // Forma de Facturación
          Monto_DDP__c = 35,                               // Monto DDP
          Requiere_OC__c = false,                            // Requiere OC
          Giro__c = 'CULTIVO DE UVA PARA MESA',              // Giro
          Requiere_HES__c = false,                           // Requiere HES
          Solicita_DICOM__c = false,                         // Solicita DICOM
          Cliente_con_Dicom__c = false,                      // Cliente con Dicom
          Courier_Importacion__c = false,                    // Courier Importación
          Condici_n_Courier_Importaci_n__c = '30 días',      // Condición Courier Importación
          Otra_Condicion_Courier_Importaci_n__c = 'TRUE',    // Otra Condición Courier Importación
          Courier_Exportacion__c = false,                    // Courier Exportación
          Condici_n_Courier_Exportaci_n__c = '30 días',      // Condición Courier Exportación
          Carga_Aerea_Importacion__c = false,                // Carga Aérea Importación
          Carga_Aerea_Exportacion__c = false,                // Carga Aérea Exportación
          Carga_Mar_tima_Importaci_n__c = false,             // Carga Marítima Importación
          Carga_Mar_tima_Exportaci_n__c = false,             // Carga Marítima Exportación
          Casillero_Importacion__c = false,                  // Casillero Importación
          Otra_Condici_n_Casillero_Importaci_n__c = 'TRUE',  // Otra Condición Casillero Importación
          Distribuci_n_Nacional__c = false,                  // Distribución Nacional
          Condici_n_Distribuci_n_Nacional__c = '30 días',    // Condición Distribución Nacional
          Otro__c = false                                   // Otro
        );
        insert acc; 
        Contact contacto = new Contact();
            contacto.FirstName = 'John';
            contacto.LastName = 'Doe';
            contacto.MobilePhone = '123456789';
            contacto.AccountId = acc.Id;
            contacto.MailingStreet = 'Calle Larga 1234, Piso 2'; //
            contacto.MailingCity = 'Santiago';
            contacto.MailingState = 'RM';
            contacto.MailingPostalCode = '8320000';
            contacto.MailingCountry = 'Chile';
        insert contacto;
        
        Contact contacto2 = new Contact();
            contacto2.FirstName = 'John';
            contacto2.LastName = 'Doe';
            contacto2.MobilePhone = '123456789';
            contacto2.AccountId = acc.Id;
            contacto2.MailingStreet = 'Calle Larga 1234, Piso 2'; //Calle Larga 1234, Piso 2
            contacto2.MailingCity = 'Santiago';
            contacto2.MailingState = 'RM';
            contacto2.MailingPostalCode = '8320000';
            contacto2.MailingCountry = 'Chile';
        insert contacto2;
        
        Direcciones__c ctoDestinatario = new Direcciones__c();
            ctoDestinatario.Ciudad__c = 'DUTTLENHEIM';
            ctoDestinatario.Pais__c = 'a0C5A00000swh5iUAA';
            ctoDestinatario.Cuenta__c = acc.Id;
            ctoDestinatario.Direccion__c = 'Calle Larga 1234, Piso 2'; //Calle Larga 1234, Piso 2
            ctoDestinatario.Codigo_Postal__c = '67120';
        insert ctoDestinatario;
        
        // Crear país para la dirección
        Pais__c pais = new Pais__c(
            Name = 'Argentina',
            Cod_Pais__c = 'AR'
        );
        insert pais;
        
        Guias_de_Exportacion__c guia = new Guias_de_Exportacion__c(
            Contacto__c = contacto.Id,
            ID_Remitente__c = acc.Id,
            Contacto_Destinatario__c = 'Jane Doe',
            Telefono_Destinatario__c = '987654321',            
            Fecha_de_Envio__c = System.today(),
            EmbalajeSustentable__c = 'Si',
            Embalaje_HOT__c = 'Cajas',
            Paquetes__c = 1,            
            Divisa__c = 'USD',
            Envio_Particular_a_Particular__c = true,
            Breve_Descripcion__c = 'Item description',
            Breve_Descripcion_2__c = 'Item description 2',
            Breve_Descripcion_3__c = 'Item description 3',
            Breve_Descripcion_4__c = 'Item description 4',
            Unidad_de_Medida__c = 'kg',
            Peso_Agente__c = 10,
            Largo__c = 20,
            Ancho__c = 30,
            Alto__c = 40,
            Tipo_Contenido__c = 'Goods',
            DDP__c = true,
            Shipper_Original__c = true
        );
        insert guia;
        
        Guias_de_Exportacion__c guia2 = new Guias_de_Exportacion__c(
            Direccion_Destinatario__c = ctoDestinatario.Id,
            Contacto__c = contacto2.Id,
            ID_Remitente__c = acc.Id,
            Contacto_Destinatario__c = 'Jane Doe',
            Telefono_Destinatario__c = '923629315',
            Fecha_de_Envio__c = System.today(),
            EmbalajeSustentable__c = 'Si',
            Embalaje_HOT__c = 'Cajas',
            Paquetes__c = 1,            
            Divisa__c = 'USD',
            Envio_Particular_a_Particular__c = true,
            Breve_Descripcion__c = 'Item description',
            Breve_Descripcion_2__c = 'Item description 2',
            Breve_Descripcion_3__c = 'Item description 3',
            Breve_Descripcion_4__c = 'Item description 4',
            Unidad_de_Medida__c = 'kg',
            Peso_Agente__c = 10,
            Largo__c = 20,
            Ancho__c = 30,
            Alto__c = 40,
            Tipo_Contenido__c = 'Goods',
            DDP__c = true,
            Shipper_Original__c = true
        );
        insert guia2;
        
        Guias_de_Exportacion__c guia3 = new Guias_de_Exportacion__c(
            Contacto__c = contacto.Id,
            ID_Remitente__c = acc.Id,
            Contacto_Destinatario__c = 'Jane Doe',
            Telefono_Destinatario__c = '9999999999',
            Fecha_de_Envio__c = System.today(),
            EmbalajeSustentable__c = 'Si',
            Embalaje_HOT__c = 'Cajas',
            //Paquetes__c = 1,            
            Divisa__c = 'USD',
            Envio_Particular_a_Particular__c = false,
            Breve_Descripcion__c = 'Item description',
            Breve_Descripcion_2__c = 'Item description 2',
            Breve_Descripcion_3__c = 'Item description 3',
            Breve_Descripcion_4__c = 'Item description 4',
            Unidad_de_Medida__c = 'kg',
            //Peso_Agente__c = 10,
            //Largo__c = 20,
            //Ancho__c = 30,
            //Alto__c = 40,
            Tipo_Contenido__c = 'Goods',
            DDP__c = true,
            Shipper_Original__c = false
        );
        insert guia3;
        
        // Crear datos de prueba para Contenido_Envio__c
        Contenido_Envio__c contenido = new Contenido_Envio__c(
            Valor_Unitario__c = 100,
            Cantidad__c = 1,
            Descripcion__c = 'Item description',
			Unidad_de_Medida__c = 'Unidades',            
            Pickup__c = guia.Id,
            Pais_fab__c = pais.Id
        );
        insert contenido;
    }
    @isTest
    static void testGenerarJSONShipment()
    {
        // Llamar al método para generar el JSON
        Test.startTest();
        
        Guias_de_Exportacion__c guia =[SELECT Id FROM Guias_de_Exportacion__c WHERE Telefono_Destinatario__c = '987654321' LIMIT 1];
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONShipment(guia.Id);
        
        Test.stopTest();

        // Validar que el JSON contiene algunas claves importantes
        System.assertNotEquals(null, jsonResult, 'El JSON no debe ser nulo');
        System.assert(jsonResult.contains('"requestedShipment"'), 'Debe contener requestedShipment');
        System.assert(jsonResult.contains('"shipper"'), 'Debe contener shipper');
        System.assert(jsonResult.contains('"recipients"'), 'Debe contener recipients');        
    }
    @isTest
    static void testGenerarJSONShipment2()
    {
        // Llamar al método para generar el JSON
        Test.startTest();
        
        Guias_de_Exportacion__c guia =[SELECT Id FROM Guias_de_Exportacion__c WHERE Telefono_Destinatario__c = '923629315' LIMIT 1];
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONShipment(guia.Id);
        
        Test.stopTest();

        // Validar que el JSON contiene algunas claves importantes
        System.assertNotEquals(null, jsonResult, 'El JSON no debe ser nulo');
        System.assert(jsonResult.contains('"requestedShipment"'), 'Debe contener requestedShipment');
        System.assert(jsonResult.contains('"shipper"'), 'Debe contener shipper');
        System.assert(jsonResult.contains('"recipients"'), 'Debe contener recipients');        
    }
    @isTest
    static void testGenerarJSONContactoNull()
    {
        // Llamar al método para generar el JSON
        Test.startTest();
        Guias_de_Exportacion__c guia2 = new Guias_de_Exportacion__c(
            //Contacto__c = contacto.Id,
            //ID_Remitente__c = acc.Id,
            Contacto_Destinatario__c = 'Jane Doe',
            Telefono_Destinatario__c = '923629315',
            Fecha_de_Envio__c = System.today(),
            EmbalajeSustentable__c = 'Si',
            Embalaje_HOT__c = 'Cajas',
            //Paquetes__c = 1,            
            Divisa__c = 'USD',
            Breve_Descripcion__c = 'Item description',
            Breve_Descripcion_2__c = 'Item description 2',
            Breve_Descripcion_3__c = 'Item description 3',
            Breve_Descripcion_4__c = 'Item description 4',
            Unidad_de_Medida__c = 'kg',
            //Peso_Agente__c = 10,
            //Largo__c = 20,
            //Ancho__c = 30,
            //Alto__c = 40,
            Tipo_Contenido__c = 'Goods',
            DDP__c = true,
            Shipper_Original__c = true
        );
        insert guia2;
        
        Guias_de_Exportacion__c guia =[SELECT Id FROM Guias_de_Exportacion__c WHERE Telefono_Destinatario__c = '923629315' LIMIT 1];
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONShipment(guia.Id);
        
        Test.stopTest();

        // Validar que el JSON contiene algunas claves importantes
        System.assertNotEquals(null, jsonResult, 'El JSON no debe ser nulo');
        System.assert(jsonResult.contains('"requestedShipment"'), 'Debe contener requestedShipment');
        System.assert(jsonResult.contains('"shipper"'), 'Debe contener shipper');
        System.assert(jsonResult.contains('"recipients"'), 'Debe contener recipients');        
    }
    @isTest
    static void testGenerarJSONDimensionesNull()
    {
        // Llamar al método para generar el JSON
        Test.startTest();
        
        
        Guias_de_Exportacion__c guia =[SELECT Id FROM Guias_de_Exportacion__c WHERE Telefono_Destinatario__c = '9999999999' LIMIT 1];
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONShipment(guia.Id);
        
        Test.stopTest();

        // Validar que el JSON contiene algunas claves importantes
        System.assertNotEquals(null, jsonResult, 'El JSON no debe ser nulo');
        System.assert(jsonResult.contains('"requestedShipment"'), 'Debe contener requestedShipment');
        System.assert(jsonResult.contains('"shipper"'), 'Debe contener shipper');
        System.assert(jsonResult.contains('"recipients"'), 'Debe contener recipients');        
    }
    @isTest
    static void testGenerarJSONGDNull()
    {
        // Llamar al método para generar el JSON
        Test.startTest();
        
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONShipment('ERROR');
        
        Test.stopTest();

        // Validar que el JSON contiene algunas claves importantes
        /*System.assertNotEquals(null, jsonResult, 'El JSON no debe ser nulo');
        System.assert(jsonResult.contains('"requestedShipment"'), 'Debe contener requestedShipment');
        //System.assert(jsonResult.contains('"shipper"'), 'Debe contener shipper');
        System.assert(jsonResult.contains('"recipients"'), 'Debe contener recipients');      */  
    }
    @isTest
    static void testGenTrackingNumber()
    {
        Test.startTest();
        
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONTracking('794817384940');
        
        Test.stopTest();
    }
    @isTest
    static void testShipperOriginalFalse()
    {
        Test.startTest();
        Guias_de_Exportacion__c guia = new Guias_de_Exportacion__c(
            //Contacto__c = contacto.Id,
            //ID_Remitente__c = acc.Id,
            Contacto_Destinatario__c = 'Jane Doe',
            Telefono_Destinatario__c = '9999999999',
            Fecha_de_Envio__c = System.today(),
            EmbalajeSustentable__c = 'Si',
            Embalaje_HOT__c = 'Cajas',
            //Paquetes__c = 1,            
            Divisa__c = 'USD',
            Breve_Descripcion__c = 'Item description',
            Breve_Descripcion_2__c = 'Item description 2',
            Breve_Descripcion_3__c = 'Item description 3',
            Breve_Descripcion_4__c = 'Item description 4',
            Unidad_de_Medida__c = 'kg',
            //Peso_Agente__c = 10,
            //Largo__c = 20,
            //Ancho__c = 30,
            //Alto__c = 40,
            Tipo_Contenido__c = 'Goods',
            DDP__c = true,
            Shipper_Original__c = false
        );
        insert guia;
        
        String jsonResult = SDR_Utils_JSON_Fedex.generarJSONShipment(guia.Id);
        
        Test.stopTest();
    }
}