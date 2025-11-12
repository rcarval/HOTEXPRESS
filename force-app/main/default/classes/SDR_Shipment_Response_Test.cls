@isTest
private class SDR_Shipment_Response_Test {

    @isTest
    static void testParseShipmentResponse() {
        String sampleJson = '{'+
            '"transactionId": "1234-5678",' +
            '"errors": [{' +
                '"code": "ERR001",' +
                '"message": "Sample error message"' +
            '}],' +
            '"output": {' +
                '"transactionShipments": [{' +
                    '"masterTrackingNumber": "794817384940",' +
                    '"serviceType": "FEDEX_INTERNATIONAL_PRIORITY",' +
                    '"shipDatestamp": "2025-01-30",' +
                    '"serviceName": "FedEx International Priority®",' +
                    '"serviceCategory": "EXPRESS",' +
                    '"alerts": [{' +
                        '"code": "SHIPMENT.SHIPDATESTAMP.INVALID",' +
                        '"message": "Invalid date",' +
                        '"alertType": "WARNING",' +
                        '"parameterList": ["2025-01-30"]' +
                    '}],' +
                    '"pieceResponses": [{' +
                        '"masterTrackingNumber": "794817384940",' +
                        '"trackingNumber": "794817384940",' +
                        '"netRateAmount": 1097.82,' +
                        '"baseRateAmount": 1039.61,' +
                        '"currencyPR": "USD",' +
                        '"packageDocuments": [{' +
                            '"url": "https://example.com/label.pdf",' +
                            '"contentType": "LABEL",' +
                            '"copiesToPrint": 1,' +
                            '"encodedLabel": "B64",' +
                            '"docType": "PDF"' +
                        '}],' +
                        '"customerReferences": [{' +
                            '"customerReferenceType": "CUSTOMER_REFERENCE",' +
                            '"value": "REF_78855"' +
                        '}]' +
                    '}],' +
                    '"completedShipmentDetail": {' +
                        '"usDomestic": false,' +
                        '"carrierCode": "FDXE",' +
                        '"masterTrackingId": {' +
                            '"trackingIdType": "FEDEX",' +
                            '"formId": "0430",' +
                            '"trackingNumber": "794817384940"' +
                        '},' +
                        '"serviceDescription": {' +
                            '"serviceId": "EP1000000300",' +
                            '"serviceType": "FEDEX_INTERNATIONAL_PRIORITY",' +
                            '"code": "2P",' +
                            '"serviceCategory": "parcel",' +
                            '"description": "International Priority EOD (IP EOD)",' +
                            '"astraDescription": "IP EOD",' +
                            '"names": [{' +
                                '"type": "long",' +
                                '"encoding": "utf-8",' +
                                '"value": "FedEx International Priority®"' +
                            '}],' +
                            '"operatingOrgCodes": ["ORG1", "ORG2"]' +
                        '}' +
                    '}' +
                '}]' +
            '}' +
        '}';

        SDR_Shipment_Response response = SDR_Shipment_Response.parse(sampleJson);

        System.assertNotEquals(null, response);
        System.assertEquals('1234-5678', response.transactionId);
        System.assertEquals(1, response.errors.size());
        System.assertEquals('ERR001', response.errors[0].code);

        SDR_Shipment_Response.cls_transactionShipments shipment = response.output.transactionShipments[0];
        System.assertEquals('794817384940', shipment.masterTrackingNumber);
        System.assertEquals('FEDEX_INTERNATIONAL_PRIORITY', shipment.serviceType);
        System.assertNotEquals(null, shipment.pieceResponses);
    }
}