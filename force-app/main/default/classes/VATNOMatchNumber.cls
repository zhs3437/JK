global class VATNOMatchNumber {
    //判断数字
    public static boolean isNumericzidai(String str) {
        Pattern pattern = Pattern.compile('-?[0-9]+?[0-9]+');
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }
    //判断英文
    public static boolean isNumericzidais(String str) {
        Pattern pattern = Pattern.compile('[a-zA-Z]+');
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }
    //判断空格
    public static boolean isNumericzidaisds(String str) {
        Pattern pattern = Pattern.compile('[\\s]');
        Matcher isNum = pattern.matcher(str);
        if (!isNum.matches()) {
            return false;
        }
        return true;
    }
}