public class kk_getPropertyReleatedFloorPlanDetails {
	 @InvocableMethod(label ='Get the property floor data')
    public static list<String> relatedFileIDs( list<string> propertyname) {
        
        Property__c acc =[ SELECT Id, Name, Floor_plan__c FROM Property__c where name = :propertyname or Property_Name__c =:propertyname limit 1];
        List<ID> PropId = new  List<ID>();
        PropId.add(acc.Floor_plan__c);
        //floor_plan__c
        
        List<String> fileIDs = new List<String>();
        List<floor_plan__c> accList=[SELECT Id,content__c, (select ContentDocumentid FROM AttachedContentDocuments) FROM floor_plan__c WHERE Id =:PropId];
        for(floor_plan__c accRec: accList){
            for(AttachedContentDocument fileRec:accRec.AttachedContentDocuments){
                fileIDs.add(fileRec.ContentDocumentid);
            }
        }
        string APIoutput = OpenAIVisionService.analyzeImage(fileIDs[0]);
        list<String> contentlist =new list<String>();
        contentlist.add(APIoutput);
        List<floor_plan__c> accList2 = new List<floor_plan__c>();
        for(floor_plan__c accRec: accList){
            accRec.content__c = APIoutput;
            accList2.add(accRec);
        }
        update accList2;
        return  contentlist ;
    }

}