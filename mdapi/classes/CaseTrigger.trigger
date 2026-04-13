trigger CaseTrigger on Case (after update) {
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        Case c = Trigger.new[i];
        Case old = Trigger.old[i];

        // Fire only when Case status changes TO Closed
        if (c.Status == 'Closed' && old.Status != 'Closed') {
            SurveyDistributionService.distributeSurveyForCase(c.Id);
        }
    }
}
