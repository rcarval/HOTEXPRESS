@isTest
public class HOTEXPRESS_Subir_Doc_Evento_CTRL_TEST {
    
    @TestSetup
    static void setupTestData() {
        // Crear datos de prueba necesarios
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Guias_de_Exportacion__c testGuia = new Guias_de_Exportacion__c(
            //Name = 'Test Guia',
            ID_Remitente__c = testAccount.Id,
            Agente__c = 'Fedex',
            N_de_Guia__c = 'TEST123456789'
        );
        insert testGuia;
    }
    
    @isTest
    static void testDescargarYAdjuntarArchivo() {
        // Obtener el registro de prueba
        Guias_de_Exportacion__c testGuia = [SELECT Id FROM Guias_de_Exportacion__c LIMIT 1];
        
        // URL de prueba (simulada)
        String testUrl = 'https://wwwtest.fedex.com/document/v1/cache/retrieve/SH,0fa811441fd7686b794818789000_SHIPPING_Z?isLabel=true&autoPrint=false&retrievalMode=THERMAL';
        String testFileName = 'Test_Label.pdf';
        
        Test.startTest();
        
        // Configurar mock HTTP response
        Test.setMock(HttpCalloutMock.class, new FedExPDFMock());
        
        // Llamar al método que queremos probar
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarYAdjuntarArchivo(testGuia.Id, testFileName, testUrl);
        
        Test.stopTest();
        
        // Verificar que se creó el attachment
        List<Attachment> attachments = [SELECT Id, Name, ContentType, ParentId 
                                       FROM Attachment 
                                       WHERE ParentId = :testGuia.Id];
        
        System.assertEquals(1, attachments.size(), 'Debería haberse creado un attachment');
        System.assertEquals(testFileName, attachments[0].Name, 'El nombre del archivo debería coincidir');
        System.assertEquals('application/pdf', attachments[0].ContentType, 'El tipo de contenido debería ser PDF');
    }
    
    @isTest
    static void testDescargarMultiplesArchivos() {
        // Obtener el registro de prueba
        Guias_de_Exportacion__c testGuia = [SELECT Id, N_de_Guia__c FROM Guias_de_Exportacion__c LIMIT 1];
        
        // Lista de URLs de prueba
        List<String> testUrls = new List<String>{
            'https://wwwtest.fedex.com/document/v1/cache/retrieve/SH,0fa811441fd7686b794818789000_SHIPPING_Z?isLabel=true&autoPrint=false&retrievalMode=THERMAL',
            'https://wwwtest.fedex.com/document/v1/cache/retrieve/SH,0fa811441fd7686b794818789001_SHIPPING_Z?isLabel=true&autoPrint=false&retrievalMode=THERMAL'
        };
        
        Test.startTest();
        
        // Configurar mock HTTP response
        Test.setMock(HttpCalloutMock.class, new FedExPDFMock());
        
        // Llamar al método que queremos probar
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarMultiplesArchivos(testGuia.Id, testUrls, testGuia.N_de_Guia__c);
        
        Test.stopTest();
        
        // Verificar que se crearon los attachments
        List<Attachment> attachments = [SELECT Id, Name, ContentType, ParentId 
                                       FROM Attachment 
                                       WHERE ParentId = :testGuia.Id];
        
        System.assertEquals(2, attachments.size(), 'Deberían haberse creado 2 attachments');
        
        // Verificar nombres de archivos
        Set<String> expectedNames = new Set<String>{
            'Etiqueta_FedEx_Paquete_1_' + testGuia.N_de_Guia__c + '.pdf',
            'Etiqueta_FedEx_Paquete_2_' + testGuia.N_de_Guia__c + '.pdf'
        };
        
        Set<String> actualNames = new Set<String>();
        for(Attachment att : attachments) {
            actualNames.add(att.Name);
        }
        
        System.assertEquals(expectedNames, actualNames, 'Los nombres de archivos deberían coincidir');
    }
    
    @isTest
    static void testDescargarYAdjuntarArchivoConParametrosInvalidos() {
        Test.startTest();
        
        // Probar con parámetros inválidos
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarYAdjuntarArchivo(null, 'test.pdf', 'https://test.com');
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarYAdjuntarArchivo('001000000000000', '', 'https://test.com');
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarYAdjuntarArchivo('001000000000000', 'test.pdf', '');
        
        Test.stopTest();
        
        // No deberían haberse creado attachments
        List<Attachment> attachments = [SELECT Id FROM Attachment];
        System.assertEquals(0, attachments.size(), 'No deberían haberse creado attachments con parámetros inválidos');
    }
    
    @isTest
    static void testDescargarMultiplesArchivosConParametrosInvalidos() {
        Test.startTest();
        
        // Probar con parámetros inválidos
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarMultiplesArchivos(null, new List<String>{'https://test.com'}, 'TEST123');
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarMultiplesArchivos('001000000000000', null, 'TEST123');
        HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarMultiplesArchivos('001000000000000', new List<String>(), 'TEST123');
        
        Test.stopTest();
        
        // No deberían haberse creado attachments
        List<Attachment> attachments = [SELECT Id FROM Attachment];
        System.assertEquals(0, attachments.size(), 'No deberían haberse creado attachments con parámetros inválidos');
    }
    
    // Mock class para simular respuestas HTTP de FedEx
    public class FedExPDFMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/pdf');
            res.setStatusCode(200);
            res.setStatus('OK');
            
            // Simular contenido PDF (bytes mínimos para un PDF válido)
            String pdfContent = '%PDF-1.4\n1 0 obj\n<<\n/Type /Catalog\n/Pages 2 0 R\n>>\nendobj\n2 0 obj\n<<\n/Type /Pages\n/Kids [3 0 R]\n/Count 1\n>>\nendobj\n3 0 obj\n<<\n/Type /Page\n/Parent 2 0 R\n/MediaBox [0 0 612 792]\n/Contents 4 0 R\n>>\nendobj\n4 0 obj\n<<\n/Length 44\n>>\nstream\nBT\n/F1 12 Tf\n72 720 Td\n(Test PDF) Tj\nET\nendstream\nendobj\nxref\n0 5\n0000000000 65535 f \n0000000009 00000 n \n0000000058 00000 n \n0000000115 00000 n \n0000000204 00000 n \ntrailer\n<<\n/Size 5\n/Root 1 0 R\n>>\nstartxref\n297\n%%EOF';
            res.setBodyAsBlob(Blob.valueOf(pdfContent));
            
            return res;
        }
    }
}