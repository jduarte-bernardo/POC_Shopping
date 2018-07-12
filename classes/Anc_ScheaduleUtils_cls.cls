public class Anc_ScheaduleUtils_cls{  
  
  public static void scheadule(String paSchedulableClassName,DateTime paScheaduleDateInterval){
      
    DateTime vaCurrentDateAndTime  = DateTime.now();
    DateTime nextRunTime = paScheaduleDateInterval;
    String vaCronString = ''   + 
      nextRunTime.second() + ' '   + nextRunTime.minute() + ' ' + 
      nextRunTime.hour()   + ' '   + nextRunTime.day()    + ' ' + 
      nextRunTime.month()  + ' ? ' + nextRunTime.year(); 
       
      Schedulable paSchedulableClass = (Schedulable) type.forName(paSchedulableClassName).newInstance();
      System.schedule(paSchedulableClassName + '-' + vaCurrentDateAndTime.format(), vaCronString, paSchedulableClass);
  }  
  public static void abortScheadule(SchedulableContext paSchedulableContext) {
    Id jobId = paSchedulableContext.getTriggerId();
    System.abortJob(jobId);       
  }

}