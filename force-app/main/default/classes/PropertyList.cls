public class PropertyList {
    @InvocableMethod(label ='Get property belongs to zipcode')
    public static List<Property__c> getPropertyrelatedToZipCode(List<String> zipCode){
        return [SELECT id, Name FROM Property__c WHERE Zip__c IN :zipCode];
    }
}