/****************************
  Desarrollado por: SEIDOR Chile
  Autor: Rodrigo López (RL)
  Proyecto: HotExpress - Migración Nibu a BSoft
  Descripción: Clase Mock para pruebas de Servicio Web Envio de datos a BSoft
 
  ---------------------------------------------------------------------------------
  No. Fecha                Autor                     Descripción
  ------ ---------- ---------------------------------------------------------------
  1.0 14-06-2023            RL                   Creación de Clase.
 *****************************/

 @isTest
global class HE_ServicioBsoftMock implements HTTPCalloutMock {
    global HTTPResponse respond (HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        String body;
		
		body = '<?xml version="1.0" encoding="utf-8"?>\n';
        body += '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">\n';
        body += '    <soap:Body>\n';
        body += '        <PROCESA_DATOSCSVResponse xmlns="http://BSOFT/">\n';
        body += '            <PROCESA_DATOSCSVResult>\n';
        body += '                <Documento xmlns="">\n';
        body += '                    <Estado>0</Estado>\n';
        body += '                    <FolioLegal>289</FolioLegal>\n';
        body += '                    <PdfByte>JVBERi0xLjQKJeLjz9MKMyAwIG9iaiA8PC9EZ</PdfByte>\n';
        body += '                    <Glosa>DTE OK</Glosa>\n';
        body += '                </Documento>\n';
        body += '            </PROCESA_DATOSCSVResult>\n';
        body += '        </PROCESA_DATOSCSVResponse>\n';
        body += '    </soap:Body>\n';
        body += '</soap:Envelope>\n';
		res.setStatusCode(200);
		res.setBody(body);
		
		return res;
	}
}