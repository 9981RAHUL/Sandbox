public with sharing class ProductController {
    @AuraEnabled(cacheable=true)
    public static List<Product__c> getProductsByCategory(String productFamily) {
        return [
            SELECT Id, Name, Product_Family__c 
            FROM Product__c 
            WHERE Product_Family__c = :productFamily
        ];
    }
    
    
    @AuraEnabled(cacheable=true)
    public static List<Product__c> getProductColors(String productId) {
        return [SELECT Product_Color__c FROM Product__c WHERE Id = :productId];
    }

    @AuraEnabled(cacheable=true)
    public static List<String> getMarketplaceValues(String productId) {
        Product__c product = [SELECT Market_Place_Platform__c FROM Product__c WHERE Id = :productId LIMIT 1];
        if (product != null && product.Market_Place_Platform__c != null) {
            return product.Market_Place_Platform__c.split(';');
        }
        return new List<String>();
}

}