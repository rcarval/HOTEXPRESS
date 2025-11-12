@isTest(SeeAllData=true)
public class SDR_ServicioFedexUtils_Test {    

    @isTest
    static void test_llamarServicioShipment() {
        // Crear un registro de metadata simulado para SDR_EnpointServiciosFedex__mdt
        /*
        SDR_EnpointServiciosFedex__mdt mdt = new SDR_EnpointServiciosFedex__mdt(
            MasterLabel = 'TestService', 
            URL__c = 'https://api.fedex.com/ship', 
            Metodo__c = 'POST', 
            URL_Token__c = 'https://api.fedex.com/token', 
            Metodo_token__c = 'POST', 
            GrantType_Token__c = 'client_credentials',
            client_secret__c = 'test_secret',
            client_id__c = 'test_client_id'
        );
        insert mdt;
		*/
        Test.startTest();

        // Crear una instancia de la clase para probar
        SDR_ServicioFedexUtils service = new SDR_ServicioFedexUtils();   
        SDR_ServicioFedexUtils.test();
        // Simular el token de autenticación
        SDR_ServicioFedexUtils.RespToken mockToken = new SDR_ServicioFedexUtils.RespToken();
        mockToken.accessToken = 'mock_access_token';
        mockToken.expiresIn = 3600;
        mockToken.tokenType = 'Bearer';
        mockToken.scope = 'scope';
        
        // Usar un método de mock para retornar el token
        //service.getToken();

        // Simular la llamada al servicio de envío
        String jsonRequest = '{"shipment": {"details": "test"}}';  // JSON ficticio para la prueba
        SDR_Shipment_Response mockResponse = new SDR_Shipment_Response();  // Respuesta simulada
        mockResponse = new SDR_Shipment_Response();  // Llenar con datos adecuados si es necesario

        // Usar mock para el envío de la solicitud HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        SDR_Shipment_Response response = service.llamarServicioShipment('TestService', jsonRequest);
        
        // Verificar los resultados esperados
        System.assertNotEquals(null, response, 'La respuesta no debe ser nula');
        // Añadir más validaciones según los datos de la respuesta esperada
        
        Test.stopTest();
    }

    @isTest
    static void test_llamarServicioTracking() {
        // Crear un registro de metadata simulado para SDR_EnpointServiciosFedex__mdt
        /*
        SDR_EnpointServiciosFedex__mdt mdt = new SDR_EnpointServiciosFedex__mdt(
            MasterLabel = 'TestService', 
            URL__c = 'https://api.fedex.com/track', 
            Metodo__c = 'POST', 
            URL_Token__c = 'https://api.fedex.com/token', 
            Metodo_token__c = 'POST', 
            GrantType_Token__c = 'client_credentials',
            client_secret__c = 'test_secret',
            client_id__c = 'test_client_id'
        );
        insert mdt;
		*/
        Test.startTest();

        // Crear una instancia de la clase para probar
        SDR_ServicioFedexUtils service = new SDR_ServicioFedexUtils();
        
        // Simular el token de autenticación
        SDR_ServicioFedexUtils.RespToken mockToken = new SDR_ServicioFedexUtils.RespToken();
        mockToken.accessToken = 'mock_access_token';
        mockToken.expiresIn = 3600;
        mockToken.tokenType = 'Bearer';
        mockToken.scope = 'scope';
        
        // Usar un método de mock para retornar el token
        //service.getToken = mockToken;

        // Simular la llamada al servicio de tracking
        String jsonRequest = '{"tracking": {"details": "test"}}';  // JSON ficticio para la prueba
        SDR_Tracking_Response mockTrackingResponse = new SDR_Tracking_Response();  // Respuesta simulada
        mockTrackingResponse = new SDR_Tracking_Response();  // Llenar con datos adecuados si es necesario

        // Usar mock para el envío de la solicitud HTTP
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        SDR_Tracking_Response response = service.llamarServicioTracking('TestService', jsonRequest);
        
        // Verificar los resultados esperados
        System.assertNotEquals(null, response, 'La respuesta no debe ser nula');
        // Añadir más validaciones según los datos de la respuesta esperada
        
        Test.stopTest();
    }

    // Mock class for HTTP Response
    class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            // Mock the response based on the request type
            HTTPResponse res = new HTTPResponse();
            res.setStatusCode(200);
            res.setBody('{"shipment": {"status": "Shipped"}}');  // Body simulada para Shipment
            return res;
        }
    }

}