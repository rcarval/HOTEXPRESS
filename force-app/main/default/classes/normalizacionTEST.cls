@isTest
public class normalizacionTEST {
    @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new normalizacionMockImpl());
        normalizacion parentObject = new normalizacion();
        new normalizacion.DireccionNormalizadaTO();
        new normalizacion.ExtensionDataObject();
        
        
        
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new normalizacionMockImpl());
        normalizacion.ServicioExternoNormalizacionSoap x = new normalizacion.ServicioExternoNormalizacionSoap();
        x.normalizarDireccion(null,null,null,null,null);
    }
    
}