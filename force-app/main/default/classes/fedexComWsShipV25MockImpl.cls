public class fedexComWsShipV25MockImpl implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'fedexComWsShipV25MockImpl.ShipServicePort() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf fedexComWsShipV25.ProcessShipmentRequest ) {
                response.put( 'response_x', new fedexComWsShipV25.ProcessShipmentReply());
            }
            if(request instanceOf fedexComWsShipV25.ProcessShipmentRequest2 ) {
                response.put( 'response_x', new fedexComWsShipV25.ProcessShipmentReply());
            }
            
        }

}