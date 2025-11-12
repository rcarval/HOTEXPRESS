@isTest 
public class fedexComWsTrackV18MockImpl implements WebServiceMock {
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
            
            System.debug(LoggingLevel.INFO, 'fedexComWsTrackV18MockImpl.TrackServicePort() - ' +
                         '\n request: ' + request +
                         '\n response: ' + response +
                         '\n endpoint: ' + endpoint +
                         '\n soapAction: ' + soapAction +
                         '\n requestName: ' + requestName +
                         '\n responseNS: ' + responseNS +
                         '\n responseName: ' + responseName +
                         '\n responseType: ' + responseType);
            
            if(request instanceOf fedexComWsTrackV18.TrackRequest ) {
                response.put( 'response_x', new fedexComWsTrackV18.TrackReply());
            }
            
        }
}