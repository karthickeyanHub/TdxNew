public class propertyVerification {
    //'PROP-0006
    @InvocableMethod(label ='Get the property Verification')
    public static List<String> getPropertyVerificationData(List<String> propId){
        List<String> returnData = new List<String>(); 
        String propIds;
        for(Property__c prop : [ SELECT Id, Property_Name__c, Zip__c, name  FROM Property__c where Name =:propId or Zip__c  = :propId or Property_Name__c =:propId]){
            propIds = prop.Property_Name__c;
        }
        //propId[0] = propId[0].replaceAll(' ','%20');
        String encodeName = EncodingUtil.urlEncode(propId[0], 'UTF-8').replace('+', '%20');
        system.debug(encodeName);
        HttpRequest req = new HttpRequest();
        String endPoint = 'http://3.84.172.115:3000/api/properties/name/'+propIds;
        req.setEndpoint(endPoint);  // Use actual API endpoint
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Status: ' + res.getStatus());
        System.debug('Body: ' + res.getBody());
        if(res.getStatus()=='OK'){
            return new List<String>{res.getBody()};
        }else{
            return new List<String>{'Error in fetching the data'};
        }
    }
}