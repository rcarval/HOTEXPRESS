@isTest
public class TarificacionTEST {
    @isTest static void test1() {
        Test.setMock(WebServiceMock.class, new TarificacionMockImpl());
        Tarificacion parentObject = new Tarificacion();
        new Tarificacion.CoberturaProductoTO();
        new Tarificacion.ArrayOfServicioTO();
        new Tarificacion.ServicioTO();
        new Tarificacion.TotalTasacionTO();
        new Tarificacion.ProductoTO();
        new Tarificacion.ArrayOfConceptoTasacionTO();
        new Tarificacion.CoberturaTO(); 
        new Tarificacion.ConceptoTasacionTO();  
        new Tarificacion.ArrayOfProductoTO(); 
        new Tarificacion.ExtensionDataObject(); 
        
        
        
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new TarificacionMockImpl());
        Tarificacion.ExternoTarificacionSoap x = new Tarificacion.ExternoTarificacionSoap();
        x.consultaProductosPorCliente(null,null);
        x.consultaCoberturaPorProducto(null,null,null);
        x.consultaCobertura(null,null,null);
    }
}