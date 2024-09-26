public class MetadataUtils {
    public static Map<String, String> fetchWhatsAppMetadata() {
        Map<String, String> metadataValues = new Map<String, String>();
        // Perform your metadata query here
        List<whatsAppData__mdt> metadataRecords = [SELECT DeveloperName, Value__c FROM whatsAppData__mdt];
        for (whatsAppData__mdt record : metadataRecords) {
            metadataValues.put(record.DeveloperName, record.Value__c);
        }
        return metadataValues;
    }
}