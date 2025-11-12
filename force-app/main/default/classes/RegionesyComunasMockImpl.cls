@isTest
public class RegionesyComunasMockImpl  implements WebServiceMock  {
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
            
            System.debug(LoggingLevel.INFO, 'RegionesyComunasMockImpl.ServicioExternoRegionYComunasSoap() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf RegionesyComunas.listarTodasLasRegiones_element ) {
                response.put( 'response_x', new RegionesyComunas.listarTodasLasRegionesResponse_element());
            }
            if(request instanceOf RegionesyComunas.listarComunasSegunRegion_element ) {
                response.put( 'response_x', new RegionesyComunas.listarComunasSegunRegionResponse_element());
            }
            if(request instanceOf RegionesyComunas.listarTodasLasComunas_element ) {
                response.put( 'response_x', new RegionesyComunas.listarTodasLasComunasResponse_element());
            }
        }
}