public with sharing class ImageController {
     @InvocableMethod(label ='Get the property Image')
    public static List<String> getImageUrl(list<string> propertyname) {
        List<String> returnData = new List<String>();        
        Id recordId;
        String versionId;
        String returnValue = '<br/>';
        String singleImage;
        String baseUrl = URL.getOrgDomainUrl().toExternalForm();

        for(Property__c prop : [ SELECT Id, Property_Name__c, Zip__c  FROM Property__c where Name =:propertyname or Zip__c  = :propertyname or Property_Name__c =:propertyname limit 1]){
            returnData.add(prop.Property_Name__c);
            recordId = prop.Id;
        }
        List<ContentDocumentLink> cdlList = [
            SELECT ContentDocument.LatestPublishedVersionId
            FROM ContentDocumentLink
            WHERE LinkedEntityId = :recordId
        ];
        for(ContentDocumentLink cdl : cdlList){
            versionId = cdl.ContentDocument.LatestPublishedVersionId;
            singleImage = baseUrl+'/sfc/servlet.shepherd/version/download/' + versionId;
            returnValue += '<img src='+singleImage+'/><br/>';
        }        
        String buttonTag = '<br/><a href="https://api.whatsapp.com/send?phone=8825576297&text="Hi" target="_blank"> <button>Send Message</button></a>';
        returnValue += buttonTag;
        return new List<String> {returnValue};
    }
}