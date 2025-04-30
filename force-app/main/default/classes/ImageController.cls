public with sharing class ImageController {
     @InvocableMethod(label ='Get the property Image')
    public static List<String> getImageUrl(list<string> propertyname) {
        List<String> returnData = new List<String>();        
        Id recordId;
        for(Property__c prop : [ SELECT Id, Property_Name__c, Zip__c  FROM Property__c where Name =:propertyname or Zip__c  = :propertyname or Property_Name__c =:propertyname limit 1]){
            returnData.add(prop.Property_Name__c);
            recordId = prop.Id;
        }
        ContentDocumentLink cdl = [
            SELECT ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
            LIMIT 1
        ];

        String versionId = cdl.ContentDocument.LatestPublishedVersionId;
        String returnValue = 'https://orgfarm-418b97e32c-dev-ed.develop.my.salesforce.com/sfc/servlet.shepherd/version/download/' + versionId;
        returnValue = '<img src='+returnValue;
        return new List<String> {returnValue};
    }
}