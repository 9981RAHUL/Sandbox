trigger Boult_Order_statusUpdation on Order__c (After Insert, After Update) {
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Id> orderIds = new List<Id>();
        for (Order__c order : Trigger.new) {
            orderIds.add(order.Id);
        }
        Boult_Order_statusUpdationHandler.assignVouchersFlow(orderIds);
    }
}