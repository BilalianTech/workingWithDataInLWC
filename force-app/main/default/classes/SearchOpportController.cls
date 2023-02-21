public with sharing class SearchOpportController 
{
    @AuraEnabled
    public static List<Opportunity> getOpportunities(string searchObjStr) 
    {
        try
        {
            //Main Var-------------------------------------------------------
            List<Opportunity> currentOpps = new List<Opportunity>();
            String selectStr;
            String whereParts;

            //Parse Object---------------------------------------------------
            OppSearchJSON oppSearchObj = (OppSearchJSON) JSON.deserialize(searchObjStr, OppSearchJSON.class);              
            String stageNameStr = oppSearchObj.stage;
            String typeStr = oppSearchObj.oppType;

            //Setup Where Clause-------------------------------------------
            if((oppSearchObj.stage != '') && (oppSearchObj.oppType != ''))
            {                
                whereParts = 'WHERE (StageName = :stageNameStr) AND (Type = :typeStr)';
            } 
            else if (oppSearchObj.stage != '') 
            {
                whereParts = 'WHERE (StageName = :stageNameStr)';
            } 
            else if (oppSearchObj.oppType != '') 
            {
                whereParts = 'WHERE (Type = :typeStr)';
            } 
            else 
            {
                whereParts = '';
            }       

            //Select Query-----------------------------------------------------
            selectStr = 'SELECT Name, Account.Name , StageName, Amount, Type, CloseDate FROM opportunity ' + whereParts;
            List<Opportunity> curOpportList = Database.query(selectStr);           

            return curOpportList;
        }
        catch(Exception ex)
        {
            System.debug('An Exception: ' + ex);
            throw new AuraHandledException('An Exception: ' + ex);            
        }
              
    }

    //Opportunity Search JSON CLASS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    public class OppSearchJSON
    {
        public String stage;
        public String oppType;
    }
    //Search Opportunity Controller############################################    
}





