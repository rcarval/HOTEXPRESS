@isTest
public class listarsucursalesTEST {
 @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new listarsucursalesMockImpl());
        listarsucursales parentObject = new listarsucursales();
          new listarsucursales.ArrayOfSucursalTO();
          new listarsucursales.ExtensionDataObject();
          new listarsucursales.UbicacionSucursalTO();
          new listarsucursales.SucursalTO();
         
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new listarsucursalesMockImpl());
        listarsucursales.ServicioExternoListarSucursalesSoap x = new listarsucursales.ServicioExternoListarSucursalesSoap();
        x.listarTodasLasSucursales(null,null);
        x.consultaSucursalMasCercana(null,null,null,null,null,null,null,null,null);
        x.listarSucursalesSegunComuna(null,null,null);
    }
}