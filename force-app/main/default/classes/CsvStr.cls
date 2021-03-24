public class CsvStr{
    private final String BR_TG_ESCAPE = '%%br%%';
    private final String REGEX_TAG = '<.+?>';
    public final String BR_TG = '<br>';
    //public final String BR_SLASH_TG = '<br/>';
    public final String BR_SLASH_TG = '\n';
    public final String STRING_NONE = '';
    public final String NEW_LINE_CHARACTER = '\n';
    public final String DOLLAR_CHARACTER = '$';
    public CsvStr(){
    }
    public String convertString(final String targetString, final Integer maxByte) {
        String convertStr = STRING_NONE;
        if (targetString != null) {
            String targetStr = targetString.replaceAll(BR_TG, BR_TG_ESCAPE);
            targetStr = targetStr.replaceAll(BR_SLASH_TG, BR_TG_ESCAPE);
            targetStr = targetStr.replaceAll(REGEX_TAG, STRING_NONE);
            targetStr = targetStr.replaceAll(
                NEW_LINE_CHARACTER,
                BR_SLASH_TG
            );
            
            targetStr = targetStr.replaceAll(BR_TG_ESCAPE, BR_SLASH_TG);
            if(maxByte<=0){
                convertStr =targetStr;
            }else{
                String[] strList = targetStr.split(BR_SLASH_TG);
                
                Integer lineLen = 0;
                Integer maxLine=10; //over the line number where not see
                Integer lines=0;
                for (String line : strList) {
                    
                    Integer sum = 0;
                    Integer index = 0;
                    lineLen = line.length();
                    
                    for (Integer i = 0; i < lineLen; i++) {
                        
                        String one = line.substring(i, (i + 1));
                        Integer oneSize = getBytes(one);
                        sum += oneSize;
                        
                        if (sum > maxByte) {
                            sum = 0;
                            convertStr += line.substring(index, (i + 1))
                                + BR_SLASH_TG;
                            index = i + 1;
                            lines++;
                            if(lines>=maxLine)break;
                        }
                    }
                    if(lines>=maxLine)break;
                    convertStr += line.substring(index, (line.length()))
                        + BR_SLASH_TG;
                    lines++;
                    if(lines>=maxLine)break;
                }
            }
        }
        
        convertStr =
            convertStr.replaceAll(
                BR_SLASH_TG + DOLLAR_CHARACTER,
                STRING_NONE
            );
        
        return convertStr;
    }
    
    private Integer getBytes(final String strings) {
        return Blob.valueOf(strings).size();
    }
}