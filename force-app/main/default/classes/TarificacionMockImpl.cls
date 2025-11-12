@isTest
public class TarificacionMockImpl implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'TarificacionMockImpl.ExternoTarificacionSoap() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf Tarificacion.consultaProductosPorCliente_element ) {
                response.put( 'response_x', new Tarificacion.consultaProductosPorClienteResponse_element());
            }
            if(request instanceOf Tarificacion.consultaCoberturaPorProducto_element ) {
                response.put( 'response_x', new Tarificacion.consultaCoberturaPorProductoResponse_element());
            }
            if(request instanceOf Tarificacion.consultaCobertura_element ) {
                response.put( 'response_x', new Tarificacion.consultaCoberturaResponse_element());
            }
        }
}