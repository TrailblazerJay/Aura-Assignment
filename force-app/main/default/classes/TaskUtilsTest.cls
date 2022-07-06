@isTest
private class TaskUtilsTest 
{
    @isTest static void testTaskPriority() {
        String pri = TaskUtils.getTaskPriority('NY');
        System.assertEquals('Normal', pri);
    }
    @isTest static void testHighPriority()
    {
        String pri = TaskUtils.getTaskPriority('CA');
        System.assertEquals('High', pri);  
    }
    @isTest static void testTaskPriorityInvalid()
    {
        String pri = TaskUtils.getTaskPriority('Montana');
        System.assertEquals(null, pri);  
    }
}