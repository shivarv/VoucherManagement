({
	doInit : function(component, event, helper) {
		console.log('in doInit ');
        helper.setDefaultDataHelper(component);
	},
    
    closeMe : function(component, event, helper) {
		console.log('in closeMe ');
        component.destroy();

	}
})