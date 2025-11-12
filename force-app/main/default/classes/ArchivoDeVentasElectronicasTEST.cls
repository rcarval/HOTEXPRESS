@isTest
public class ArchivoDeVentasElectronicasTEST {
@isTest static void test1() {
        Test.setMock(WebServiceMock.class, new ArchivoDeVentasElectronicasMockImpl());
        ArchivoDeVentasElectronicas parentObject = new ArchivoDeVentasElectronicas();
        new ArchivoDeVentasElectronicas.ConsultaResultadoDocumentoConObservacionResult_element();
        new ArchivoDeVentasElectronicas.CargarYEmitir2Result_element();
        new ArchivoDeVentasElectronicas.ResultadoCargaArchivos_element();
        new ArchivoDeVentasElectronicas.ConsultaResultadoDocumentoResult_element();
        new ArchivoDeVentasElectronicas.CargarYEmitirResult_element();
        new ArchivoDeVentasElectronicas.Documentos_element();
        
    }
    @isTest static void test2(){
        Test.setMock(WebServiceMock.class, new ArchivoDeVentasElectronicasMockImpl());
        ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap x = new ArchivoDeVentasElectronicas.ArchivoDeVentasElectronicasSoap();
        x.CargarYEmitir2(null,null,null,null,null,null);
        x.ConsultaResultadoDocumento(null,null,null);
        x.ConsultaResultadoDocumentoConObservacion(null,null,null);
        x.ConsultarEstadoUsuarioPorDocumento(null,null,null);
        x.ObtenerPDF(null,null);
        x.CargarYEmitir(null,null,null,null,null);   
        x.ConsultarSucursalPorRutEmpresa(null,null);
    }
}