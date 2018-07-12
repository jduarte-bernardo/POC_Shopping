public with sharing class Util {

	public static final String VALIDO = 'valido';
    public static final String INVALIDO = 'invalido';    
    
    /*
     * Return the haystack string index that is more similar to the needle string
     */
    public static Integer getClosestString(String needle, List<String> haystack){
        Integer closestDistance = 100000;
        Integer closestIndex = 0;
        
        Integer index = 0;
        for(String h: haystack){
            Integer distance = levenshtein(needle, h);
            if(distance < closestDistance){
                closestDistance = distance;
                closestIndex = index;
            }
            index++;
        }
        
        return closestIndex;
    }
    
    public static Integer levenshtein(String a, String b){
        a = a.toLowerCase();
        b = b.toLowerCase();
        // i == 0
        Integer [] costs = new Integer [b.length() + 1];
        for (Integer j = 0; j < costs.size(); j++)
            costs[j] = j;
        for (Integer i = 1; i <= a.length(); i++) {
            // j == 0; nw = lev(i - 1, j)
            costs[0] = i;
            Integer nw = i - 1;
            for (Integer j = 1; j <= b.length(); j++) {
                Integer cj = Math.min(1 + Math.min(costs[j], costs[j - 1]), a.charAt(i - 1) == b.charAt(j - 1) ? nw : nw + 1);
                nw = costs[j];
                costs[j] = cj;
            }
        }
        return costs[b.length()];
    }
}