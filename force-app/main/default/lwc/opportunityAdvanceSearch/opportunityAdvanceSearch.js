import { LightningElement, api, wire, track } from 'lwc';
//import { reduceErrors } from 'c/ldsUtils';
//import { getObjectInfo } from 'lightning/uiObjectInfoApi';
//import Opportunity from '@salesforce/schema/Opportunity';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';

import STAGE_FIELD from '@salesforce/schema/Opportunity.StageName';
import OPP_TYPE_FIELD from '@salesforce/schema/Opportunity.Type';
import getOpportunities from '@salesforce/apex/SearchOpportController.getOpportunities';

export default class OpportunityAdvanceSearch extends LightningElement 
{
    @api serverMsg;
    @api searchJSON;
    opportunities;
    oppTypeValue = "";
    stageValue = "";
    error;   
    oppTypeOptions;
    stageOptions;

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: OPP_TYPE_FIELD })
    oppTypePicklistValues({ error, data })
    {
        //Get data from Picklist----------------------------------------------
        if(data)
        {
            //Vars------------------------------------------------------------
            let oppTypeHolder = [];
            const oppTypeArr = data.values;

            //Add Null Search Value--------------------------------------------
            oppTypeHolder.push({'label' : '-----', 'value' : ''});

            //Get label and values---------------------------------------------
            for(let x of oppTypeArr)
            {
                oppTypeHolder.push({'label' : x.label, 'value' : x.value});
                //console.log("opportTypeOptions " + JSON.stringify(x.label) );
            }
            
            this.oppTypeOptions = oppTypeHolder; 
            console.log("opportTypeOptions " + JSON.stringify(this.oppTypeOptions) );
            this.error = undefined;
        }
        else if(error)
        {
            this.error = error;
            this.oppTypeOptions = undefined;
        }
    }

    @wire(getPicklistValues, { recordTypeId: '012000000000000AAA', fieldApiName: STAGE_FIELD })
    stagePicklistValues({ error, data })
    {
        //Get data from Picklist----------------------------------------------
        if(data)
        {
            //Vars------------------------------------------------------------
            let stageHolder = [];
            const stageArr = data.values;

            //Add Null Search Value--------------------------------------------
            stageHolder.push({'label' : '-----', 'value' : ''});

            //Get label and values---------------------------------------------
            for(let stage of stageArr)
            {
                stageHolder.push({'label' : stage.label, 'value' : stage.value});
                //console.log("stageOptions " + JSON.stringify(stage.label) );
            }
           
            this.stageOptions = stageHolder;
            console.log("stageOptions " + JSON.stringify(this.stageOptions) );            
            this.error = undefined;
        }
        else if(error)
        {
            this.error = error;
            this.stageOptions = undefined;
        }
    }
   
    //Opportunity Type Value Changed===========================================
    oppTypeChange(event)
    {
        this.oppTypeValue = event.detail.value;
    }

    //Stage Value Changed======================================================
    stageChange(event)
    {
        this.stageValue = event.detail.value;
    }

    //Send Search Object To Controller=========================================
    enterSearchClicked(event)
    {
        this.searchJSON = { stage: this.stageValue , oppType: this.oppTypeValue };        

        //Call Controller============================================
        getOpportunities({ searchObjStr: JSON.stringify(this.searchJSON)})
        .then( result => {
            
            console.log('Test Start');
            
            this.opportunities = result;
            this.error = undefined;

            console.log('result: ' + JSON.stringify(this.opportunities));
           
            //console.log('OPP PickList: ' + JSON.stringify(this.oppTypeOptions.values));
            //console.log('STAGE PickList: ' + JSON.stringify(this.stagePicklistValues.data.values));
           
            console.log('Test End');

        })
        .catch((error)=>{
            this.error = error;
            console.log('Error: ' + this.error);
        });


       
    }

    //#########################################################################
}