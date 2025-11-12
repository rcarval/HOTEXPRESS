@istest
public class tempuriOrgTEST {
    
    
    @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new tempuriOrgMockImpl());
        tempuriOrg parentObject = new tempuriOrg();
        new tempuriOrg.Prueba_element();
        new tempuriOrg.PruebaResponse_element();
        new tempuriOrg.ConsultaCabeceraEnvio_element();
        new tempuriOrg.ConsultaCabeceraEnvioResponse_element();
        new tempuriOrg.ConsultaEnvio_element();
        new tempuriOrg.ConsultaEnvioResponse_element();
        new tempuriOrg.ArrayOfEstruct_Envio();
        new tempuriOrg.Estruct_Envio();
        new tempuriOrg.EnvioRes();
        new tempuriOrg.ArrayOfEstruct_Historial();
        new tempuriOrg.Estruct_Historial();
        new tempuriOrg.EnvioReq();
        

        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new tempuriOrgMockImpl());
        tempuriOrg.WSConsultaEnvioSoap x = new tempuriOrg.WSConsultaEnvioSoap();
        x.Prueba(null,null,null,null);
        x.ConsultaCabeceraEnvio(null);
        x.ConsultaEnvio(null);
    }
    
    
}