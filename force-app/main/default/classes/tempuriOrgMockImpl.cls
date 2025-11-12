@isTest
public class tempuriOrgMockImpl implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'tempuriOrgMockImpl.WSConsultaEnvioSoap() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf tempuriOrg.Prueba_element ) {
                response.put( 'response_x', new tempuriOrg.PruebaResponse_element());
            }
            if(request instanceOf tempuriOrg.ConsultaCabeceraEnvio_element ) {
                response.put( 'response_x', new tempuriOrg.ConsultaCabeceraEnvioResponse_element());
            }
            if(request instanceOf tempuriOrg.ConsultaEnvio_element ) {
                response.put( 'response_x', new tempuriOrg.ConsultaEnvioResponse_element());
            }
        }
}