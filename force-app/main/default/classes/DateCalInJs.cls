global class DateCalInJs {
    webservice static Integer DateCalMethod(string date1,string date2){
        Date td1 = Date.valueOf(date1);
        Date td2 = Date.valueOf(date2);
        Integer cdays = td1.daysBetween(td2);
        return cdays;
    } 
}