@isTest 
public class AutentificadorServipymeClMockImpl implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'AutentificadorServipymeClMockImpl.AutenticadorSoap() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf AutentificadorServipymeClPerfilamientoWs.Autenticar_element ) {
                response.put( 'response_x', new AutentificadorServipymeClPerfilamientoWs.AutenticarResponse_element());
            }
            
        }
}