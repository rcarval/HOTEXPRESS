public with sharing class HOTEXPRESS_Subir_Doc_Evento_CTRL {

    @future(callout=true)
    public static void descargarYAdjuntarArchivo(Id recordId, String fileName, String urlArchivo) {
        try {
            System.debug('Iniciando descarga de archivo: ' + fileName + ' desde URL: ' + urlArchivo);
            
            // Validar parámetros de entrada
            if (recordId == null || String.isBlank(fileName) || String.isBlank(urlArchivo)) {
                System.debug('Error: Parámetros inválidos - recordId: ' + recordId + ', fileName: ' + fileName + ', urlArchivo: ' + urlArchivo);
                return;
            }
            
            // Llamado HTTP GET a la URL del PDF
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(urlArchivo);
            request.setMethod('GET');
            request.setTimeout(60000); // 60 segundos por si el archivo demora
            request.setHeader('Accept', 'application/pdf');

            HttpResponse response = http.send(request);
            System.debug('Respuesta HTTP - Status Code: ' + response.getStatusCode() + ', Status: ' + response.getStatus());

            if (response.getStatusCode() == 200) {
                Blob pdfContent = response.getBodyAsBlob();
                System.debug('Tamaño del archivo descargado: ' + pdfContent.size() + ' bytes');

                // Crear Attachment para mostrar en "Notas y Archivos adjuntos" (CombinedAttachments)
                Attachment adj = new Attachment();
                adj.ParentId = recordId;
                adj.Name = fileName.endsWith('.pdf') ? fileName : fileName + '.pdf';
                adj.ContentType = 'application/pdf';
                adj.Body = pdfContent;
                insert adj;

                System.debug('Archivo adjunto cargado exitosamente al registro: ' + recordId + ' con nombre: ' + adj.Name);
            } else {
                System.debug('Error al obtener el PDF desde FedEx. Código: ' + response.getStatusCode() + ', Mensaje: ' + response.getStatus());
                System.debug('Body de respuesta: ' + response.getBody());
            }

        } catch (Exception e) {
            System.debug('Error en descargarYAdjuntarArchivo: ' + e.getMessage());
            System.debug('StackTrace: ' + e.getStackTraceString());
        }
    }
    
    /**
     * Método para descargar múltiples archivos de FedEx y adjuntarlos al registro
     * @param recordId ID del registro al que se adjuntarán los archivos
     * @param urls Lista de URLs de los archivos a descargar
     * @param trackingNumber Número de tracking para nombrar los archivos
     */
    public static void descargarMultiplesArchivos(Id recordId, List<String> urls, String trackingNumber) {
        if (recordId == null || urls == null || urls.isEmpty()) {
            System.debug('Error: Parámetros inválidos para descargar múltiples archivos');
            return;
        }
        
        System.debug('Iniciando descarga de ' + urls.size() + ' archivos para el registro: ' + recordId);
        
        for (Integer i = 0; i < urls.size(); i++) {
            String urlArchivo = urls[i];
            String nombreArchivo = 'Etiqueta_FedEx_Paquete_' + (i + 1) + '_' + trackingNumber + '.pdf';
            
            // Llamar al método @future para cada archivo
            HOTEXPRESS_Subir_Doc_Evento_CTRL.descargarYAdjuntarArchivo(recordId, nombreArchivo, urlArchivo);
        }
        
        System.debug('Se han iniciado las descargas de ' + urls.size() + ' archivos');
    }
}