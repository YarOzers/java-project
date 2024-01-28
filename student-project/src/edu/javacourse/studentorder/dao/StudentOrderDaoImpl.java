package edu.javacourse.studentorder.dao;

import edu.javacourse.studentorder.config.Config;
import edu.javacourse.studentorder.domain.*;
import edu.javacourse.studentorder.exception.DaoException;

import java.sql.*;
import java.time.LocalDateTime;

public class StudentOrderDaoImpl implements StudentOrderDao{
    public static final String INSERT_ORDER =
            "INSERT INTO public.jc_student_order(" +
                    "student_order_status," +//1
                    " student_order_date," +
                    " h_sur_name," +
                    " h_given_name," +
                    " h_patronymic," +
                    " h_date_of_birth, " +
                    "h_passport_seria," +
                    " h_passport_number," +
                    " h_passport_date," +
                    " h_passport_office_id," +//10
                    " h_post_index," +
                    " h_street_code, " +
                    "h_building," +
                    " h_extension," +
                    " h_apartment," +
                    "h_university_id," +
                    "h_student_number," +
                    " w_sur_name," +
                    " w_given_name," +
                    " w_patronymic," + //20
                    " w_date_of_birth, " +
                    " w_passport_seria, " +
                    "w_passport_number," +
                    " w_passport_date," +
                    " w_passport_office_id," +
                    " w_post_index," +  //26
                    " w_street_code," +
                    " w_building," +
                    " w_extension," +
                    " w_apartment," +
                    "w_university_id," + //30
                    "w_student_number, " +
                    "certificate_id," + //32
                    " register_office_id, " +
                    "marriage_date)" +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?" +
                    " ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";

    public static final String INSERT_CHILD = "insert into public.jc_student_child (student_order_id, c_sur_name, c_given_name, c_patronymic,\n" +
            "                                     c_date_of_birth, c_certificate_number, c_certificate_date, c_register_office_id,\n" +
            "                                     c_post_index, c_street_code, c_building, c_extension, c_apartment)\n" +
            "values (?,?,?,?,?,?,?,?,?,?,?,?,?)";

    //TODO refactoring - make one method

    private Connection getConnection() throws SQLException {
        Connection con = DriverManager.getConnection( // поиск драйвера с помощью драйвер менеджера ( через class path)
                Config.getProperty(Config.DB_URL),
                Config.getProperty(Config.DB_LOGIN),
                Config.getProperty(Config.DB_PASSWORD)
        );
        return con;
    }

    @Override
    public Long saveStudentOrder(StudentOrder so) throws DaoException {
        Long result = -1L;

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(INSERT_ORDER, new String[]{"student_order_id"})) {

            con.setAutoCommit(false);//отключаем автокомит для реализации транзакции

            try {
                int namberOfValues = 1;
                // Header
                stmt.setInt(namberOfValues, StudentOrderStatus.START.ordinal());
                stmt.setTimestamp(++namberOfValues, java.sql.Timestamp.valueOf(LocalDateTime.now()));
                //Husband
                namberOfValues = setParamsForAdult(stmt, namberOfValues, so.getHusband());
                //Wife
                namberOfValues = setParamsForAdult(stmt, namberOfValues, so.getWife());
                //Marriage
                stmt.setString(++namberOfValues, so.getMarriageCertificateId());
                stmt.setLong(++namberOfValues, so.getMarriageOffice().getOfficeId());
                stmt.setDate(++namberOfValues, java.sql.Date.valueOf(so.getMarriageDate()));
                System.out.println(namberOfValues);
                stmt.executeUpdate();

                ResultSet gkRs = stmt.getGeneratedKeys();
                if (gkRs.next()) {
                    result = gkRs.getLong(1);
                }
                gkRs.close();

               // saveChildren(con, so, result);
                // исполнение команды для модификации данных( insert, delete и тд.)


                con.commit();// комит транзакции в случае успуха
            }catch (SQLException exception){
                con.rollback();// отмена транзакции
                throw new DaoException(exception);
            }






        }catch (SQLException exception){
            throw new DaoException(exception);
        }
        return result;
    }

//    private void saveChildren(Connection con, StudentOrder so, Long soId) throws SQLException {
//        try (PreparedStatement stmt = con.prepareStatement(INSERT_CHILD)) {
//            for (Child child : so.getChildren()) {
//                stmt.setLong(1, soId);
//                setParamsForChild(stmt,child);
//                stmt.addBatch();
//            }
//            stmt.executeBatch();
//        }
//    }
    //пример кода, если помещается сразу много записей, более 10000 например

    private void saveChildren(Connection con, StudentOrder so, Long soId) throws SQLException {
        try (PreparedStatement stmt = con.prepareStatement(INSERT_CHILD)) {
            int counter = 0;
            int start = 1;
            for (Child child : so.getChildren()) {

                stmt.setLong(start, soId);

                setParamsForChild(stmt,start,child);
                stmt.addBatch();
                counter++;
                if(counter > 10000){
                    stmt.executeBatch();
                    counter = 0;
                }
            }
            if (counter > 0){
                stmt.executeBatch();
            }
        }
    }

    private void setParamsForChild(PreparedStatement stmt,int start, Child child) throws SQLException {
        int startContinue = setParamsForPerson(stmt,start,child);
        stmt.setString(++startContinue,child.getCertificateNumber());
        stmt.setDate(++startContinue,java.sql.Date.valueOf(child.getIssueDate()));
        stmt.setLong(++startContinue,child.getIssueDepartment().getOfficeId());
        setParamsForAddress(stmt,startContinue, child);


    }

    private int setParamsForAdult(PreparedStatement stmt, int start, Adult adult) throws SQLException {
        int startContinue = setParamsForPerson(stmt, start, adult);
        stmt.setString(++startContinue, adult.getPassportSeria());
        stmt.setString(++startContinue, adult.getPassportNumber());
        stmt.setDate(++startContinue, Date.valueOf(adult.getIssueDate()));
        stmt.setLong(++startContinue, adult.getIssueDepartment().getOfficeId());
        startContinue = setParamsForAddress(stmt, startContinue, adult);
        stmt.setLong(++startContinue,adult.getUniversity().getUniversityId());
        stmt.setString(++startContinue,adult.getStudentId());
        return startContinue;


    }

    private int setParamsForAddress(PreparedStatement stmt, int start, Person person) throws SQLException {
        Address personAddress = person.getAddress();
        stmt.setString(++start, personAddress.getPostCode());
        stmt.setLong(++start, personAddress.getStreet().getStreetCode());
        stmt.setString(++start, personAddress.getBuilding());
        stmt.setString(++start, personAddress.getExtension());
        stmt.setString(++start, personAddress.getApartment());

        return start;
    }

    private int setParamsForPerson(PreparedStatement stmt, int start, Person person) throws SQLException {
        stmt.setString(++start, person.getSurName());
        stmt.setString(++start, person.getGivenName());
        stmt.setString(++start, person.getPatronymic());
        stmt.setDate(++start, Date.valueOf(person.getDateOfBirth()));
        return start;
    }
}
