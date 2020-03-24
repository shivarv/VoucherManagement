({
	doInit : function(component, event, helper) {
		console.log('in doInit ');
        helper.setDefaultDataHelper(component);
	},
    
    closeMe : function(component, event, helper) {
		console.log('in closeMe ');
        component.destroy();

	},
    
    redirectUser : function(component, event, helper) {
    	var navEvent = $A.get("e.force:navigateToSObject");
         navEvent.setParams({
              recordId: event.getParam("id"),
              slideDevName: "detail"
         });
         navEvent.fire(); 
	}
})