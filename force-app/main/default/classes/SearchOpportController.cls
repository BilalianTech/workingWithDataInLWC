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
            selectStr = 'SELECT Name, StageName, Amount, Type FROM opportunity ' + whereParts;

            //Opportunity Holder---------------------------------------------
            Opportunity cOpp = new Opportunity();
            cOpp.CloseDate = Date.parse('8/25/2014');
            cOpp.StageName = oppSearchObj.stage;
            cOpp.Type = oppSearchObj.oppType;
            cOpp.Amount = 230000.00;
            cOpp.Description = selectStr;

            currentOpps.add(cOpp);

            cOpp = new Opportunity();
            cOpp.CloseDate = Date.parse('01/10/2022');
            cOpp.StageName ='Close Won';
            cOpp.Type = 'New Customer';
            cOpp.Amount = 260000.00;
            cOpp.Description = 'Free Free';

            currentOpps.add(cOpp);

            return currentOpps;
        }
        catch(Exception ex)
        {
            System.debug('An Exception: ' + ex);
            throw new AuraHandledException('An Exception: ' + ex);
            
        }
              
    }

    public class OppSearchJSON
    {
        public String stage;
        public String oppType;
    }
    //Search Opportunity Controller############################################    
}





