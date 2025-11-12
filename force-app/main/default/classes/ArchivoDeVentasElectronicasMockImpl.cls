@isTest 
public class ArchivoDeVentasElectronicasMockImpl implements WebServiceMock {
 public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType) {
            
            System.debug(LoggingLevel.INFO, 'ArchivoDeVentasElectronicasMockImpl.ArchivoDeVentasElectronicasSoap() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf ArchivoDeVentasElectronicas.CargarYEmitir2_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.CargarYEmitir2Response_element());
            }
            if(request instanceOf ArchivoDeVentasElectronicas.ConsultaResultadoDocumento_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.ConsultaResultadoDocumentoResponse_element());
            }
            if(request instanceOf ArchivoDeVentasElectronicas.ConsultaResultadoDocumentoConObservacion_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.ConsultaResultadoDocumentoConObservacionResponse_element());
            }
            if(request instanceOf ArchivoDeVentasElectronicas.ConsultarEstadoUsuarioPorDocumento_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.ConsultarEstadoUsuarioPorDocumentoResponse_element());
            }
            if(request instanceOf ArchivoDeVentasElectronicas.ObtenerPDF_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.ObtenerPDFResponse_element());
            }
            if(request instanceOf ArchivoDeVentasElectronicas.CargarYEmitir_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.CargarYEmitirResponse_element());
            }
            if(request instanceOf ArchivoDeVentasElectronicas.ConsultarSucursalPorRutEmpresa_element ) {
                response.put( 'response_x', new ArchivoDeVentasElectronicas.ConsultarSucursalPorRutEmpresaResponse_element());
            }
            
            
            
        }

}