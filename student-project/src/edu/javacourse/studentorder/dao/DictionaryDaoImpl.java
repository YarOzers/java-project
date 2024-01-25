package edu.javacourse.studentorder.dao;

import edu.javacourse.studentorder.config.Config;
import edu.javacourse.studentorder.domain.PassportOffice;
import edu.javacourse.studentorder.domain.RegisterOffice;
import edu.javacourse.studentorder.domain.Street;
import edu.javacourse.studentorder.exception.DaoException;

import java.sql.*;
import java.util.LinkedList;
import java.util.List;

public class DictionaryDaoImpl implements DictionaryDao
{
    private final static String GET_STREET = "SELECT street_code, street_name FROM jc_street WHERE UPPER(street_name) LIKE UPPER(?)";// SQL запрос
    private final static String GET_PASSPORT= "SELECT * FROM jc_passport_office WHERE UPPER(p_office_area_id) LIKE UPPER(?)";// SQL запрос
    private final static String GET_REGISTER= "SELECT * FROM jc_register_office WHERE UPPER(r_office_area_id) LIKE UPPER(?)";// SQL запрос
    private Connection getConnection() throws SQLException {
        Connection con = DriverManager.getConnection( // поиск драйвера с помощью драйвер менеджера ( через class path)
                Config.getProperty(Config.DB_URL),
                Config.getProperty(Config.DB_LOGIN),
                Config.getProperty(Config.DB_PASSWORD)
        );
        return con;
    }
    @Override
    public List<Street> findStreet(String pattern) throws DaoException {
        //        Class.forName("org.postgresql.Driver");//импорт класса с помощью JAVA reflection (не обязательная строка)
        List<Street> result = new LinkedList<>();

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(GET_STREET);){
            stmt.setString(1,"%" + pattern + "%");


            ResultSet rs = stmt.executeQuery();
            while(rs.next()){
            Street str = new Street(rs.getLong("street_code"), rs.getString("street_name"));
            result.add((str));
            }
         }catch (SQLException exception){
            throw new DaoException(exception);
         }
        return result;
    }

    @Override
    public List<PassportOffice> findPassportOffice(String areaId) throws DaoException {
        List<PassportOffice> result = new LinkedList<>();

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(GET_PASSPORT);){
            stmt.setString(1,areaId);


            ResultSet rs = stmt.executeQuery();
            while(rs.next()){
                PassportOffice passportOffice = new PassportOffice(
                        rs.getLong("p_office_id"),
                        rs.getString("p_office_area_id"),
                        rs.getString("p_office_name"));
                result.add((passportOffice));
            }
        }catch (SQLException exception){
            throw new DaoException(exception);
        }
        return result;
    }

    @Override
    public List<RegisterOffice> findRegisterOffice(String areaId) throws DaoException {
        List<RegisterOffice> result = new LinkedList<>();

        try (Connection con = getConnection();
             PreparedStatement stmt = con.prepareStatement(GET_REGISTER);){
            stmt.setString(1,areaId);


            ResultSet rs = stmt.executeQuery();
            while(rs.next()){
                RegisterOffice registerOffice = new RegisterOffice(
                        rs.getLong("r_office_id"),
                        rs.getString("r_office_area_id"),
                        rs.getString("r_office_name"));
                result.add((registerOffice));
            }
        }catch (SQLException exception){
            throw new DaoException(exception);
        }
        return result;
    }

    ;

}
