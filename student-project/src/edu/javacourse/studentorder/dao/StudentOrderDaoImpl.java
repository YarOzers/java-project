package edu.javacourse.studentorder.dao;

import edu.javacourse.studentorder.config.Config;
import edu.javacourse.studentorder.domain.*;
import edu.javacourse.studentorder.exception.DaoException;

import java.sql.*;
import java.time.LocalDateTime;

public class StudentOrderDaoImpl implements StudentOrderDao{
    public static final String INSERT_ORDER =
            "INSERT INTO public.jc_student_order(\n" +
                    "\tstudent_order_status, student_order_date, h_sur_name, h_given_name, h_patronymic, h_date_of_birth, " +
                    "h_passport_seria, h_passport_number, h_passport_date, h_passport_office, h_post_index, h_street_code, " +
                    "h_building, h_extension, h_apartment, w_sur_name, w_given_name, w_patronymic, w_date_of_birth, w_passport_seria, " +
                    "w_passport_number, w_passport_date, w_passport_office, w_post_index, w_street_code, w_building, w_extension, w_apartment, " +
                    "certificate_id, register_office_id, marriage_date)\n" +
                    "\tVALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);";
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

            // Header
            stmt.setInt(1, StudentOrderStatus.START.ordinal());
            stmt.setTimestamp(2, java.sql.Timestamp.valueOf(LocalDateTime.now()));

            //Husband
            int start1 = 3;
            setParamsForAdult(stmt, start1, so.getHusband());
            int start2 = 16;
            setParamsForAdult(stmt, start2, so.getWife());


            //Marriage
            stmt.setString(29,so.getMarriageCertificateId());
            stmt.setLong(30,so.getMarriageOffice().getOfficeId());
            stmt.setDate(31,java.sql.Date.valueOf(so.getMarriageDate()));


            stmt.executeUpdate();// исполнение команды для модификации данных( insert, delete и тд.)

            ResultSet gkRs = stmt.getGeneratedKeys();
            if (gkRs.next()) {
                result = gkRs.getLong(1);
            }
            gkRs.close();




        }catch (SQLException exception){
            throw new DaoException(exception);
        }
        return result;
    }

    private void setParamsForAdult(PreparedStatement stmt, int start, Adult adult) throws SQLException {
        stmt.setString(start, adult.getSurName());
        stmt.setString(++start, adult.getGivenName());
        stmt.setString(++start, adult.getPatronymic());
        stmt.setDate(++start, Date.valueOf(adult.getDateOfBirth()));
        stmt.setString(++start, adult.getPassportSeria());
        stmt.setString(++start, adult.getPassportNumber());
        stmt.setDate(++start, Date.valueOf(adult.getIssueDate()));
        stmt.setLong(++start, adult.getIssueDepartment().getOfficeId());
        Address adultAddress = adult.getAddress();
        stmt.setString(++start, adultAddress.getPostCode());
        stmt.setLong(++start, adultAddress.getStreet().getStreetCode());
        stmt.setString(++start, adultAddress.getBuilding());
        stmt.setString(++start, adultAddress.getExtension());
        stmt.setString(++start, adultAddress.getApartment());

    }
}
