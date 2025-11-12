@isTest
public class AutentificadorServipymeClTEST {
 @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new AutentificadorServipymeClMockImpl());
        AutentificadorServipymeClPerfilamientoWs parentObject = new AutentificadorServipymeClPerfilamientoWs();
       // new AutentificadorServipymeClPerfilamientoWs.RespuestaAdmisionTO();
       // new AutentificadorServipymeClPerfilamientoWs.ExtensionDataObject();
       // new AutentificadorServipymeClPerfilamientoWs.AdmisionTO();
        
        
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new AutentificadorServipymeClMockImpl());
        AutentificadorServipymeClPerfilamientoWs.AutenticadorSoap x = new AutentificadorServipymeClPerfilamientoWs.AutenticadorSoap();
        x.Autenticar(null,null,null,null,null);
    }
}