@isTest
public class admicionCEPTEST {
    @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new admicionCEPMockImpl());
        admicionCEP parentObject = new admicionCEP();
        new admicionCEP.RespuestaAdmisionTO();
        new admicionCEP.ExtensionDataObject();
        new admicionCEP.AdmisionTO();
        
        
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new admicionCEPMockImpl());
        admicionCEP.ServicioExternoAdmisionCEPSoap x = new admicionCEP.ServicioExternoAdmisionCEPSoap();
        x.admitirEnvio(null,null,null);
    }
    
}