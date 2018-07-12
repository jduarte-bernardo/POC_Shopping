public class Anc_Utils_cls {
    
  private static final String DEBUG_BREAKLINE = '\n';
  private static final String DEBUG_PREFIX   = DEBUG_BREAKLINE + DEBUG_BREAKLINE + ' >>> ';
  private static final String DEBUG_SUFIX   = DEBUG_BREAKLINE + DEBUG_BREAKLINE + ' ';

  public static void LogToSystemDebug(String paMessage){
    System.debug(DEBUG_PREFIX + paMessage + DEBUG_SUFIX);
  }

    public class Cal_Exception extends Exception{

    }
}