@isTest
public class listarsucursalesMockImpl  implements WebServiceMock{
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
            
            System.debug(LoggingLevel.INFO, 'listarsucursalesMockImpl.ServicioExternoListarSucursalesSoap() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf listarsucursales.listarTodasLasSucursales_element ) {
                response.put( 'response_x', new listarsucursales.listarTodasLasSucursalesResponse_element());
            }
            if(request instanceOf listarsucursales.consultaSucursalMasCercana_element ) {
                response.put( 'response_x', new listarsucursales.consultaSucursalMasCercanaResponse_element());
            }
            if(request instanceOf listarsucursales.listarSucursalesSegunComuna_element ) {
                response.put( 'response_x', new listarsucursales.listarSucursalesSegunComunaResponse_element());
            }
        }
}