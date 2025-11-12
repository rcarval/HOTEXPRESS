@isTest
public class RetiroTEST {
  @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new RetiroMockImpl());
        Retiro parentObject = new Retiro();
        new Retiro.ResultadoRetiroTO();
        new Retiro.ExtensionDataObject();
        new Retiro.RetiroTO();
          
        
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new RetiroMockImpl());
        Retiro.ServicioExternoRetiroSoap x = new Retiro.ServicioExternoRetiroSoap();
        x.registrarRetiro(null,null,null);
    }
}