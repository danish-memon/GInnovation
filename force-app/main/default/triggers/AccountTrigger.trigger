trigger AccountTrigger on Account (before insert, before update) {
    if (Trigger.isBefore){
        AccountTriggerHandler.handleBefore(Trigger.new);
    }
}
