@isTest
public class RegionesyComunasTEST {
    @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new RegionesyComunasMockImpl());
        RegionesyComunas parentObject = new RegionesyComunas();
         new RegionesyComunas.ArrayOfRegionTO();
         new RegionesyComunas.ComunaTO();
         new RegionesyComunas.ExtensionDataObject();
         new RegionesyComunas.RegionTO();
         new RegionesyComunas.ArrayOfComunaTO();
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new RegionesyComunasMockImpl());
        RegionesyComunas.ServicioExternoRegionYComunasSoap x = new RegionesyComunas.ServicioExternoRegionYComunasSoap();
        x.listarTodasLasComunas(null,null);
        x.listarComunasSegunRegion(null,null,null);
        x.listarTodasLasRegiones(null,null);
    }
}