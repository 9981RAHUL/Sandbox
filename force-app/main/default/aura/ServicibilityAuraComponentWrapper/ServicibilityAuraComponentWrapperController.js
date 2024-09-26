({
    quickActionClose : function(component, event, helper) {// Closing quic action
        // Close the action panel
        var dismissActionPanel = $A.get("e.force:closeQuickAction");
        dismissActionPanel.fire();
    }
})