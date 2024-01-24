package edu.javacourse.studentorder.dao;

import edu.javacourse.studentorder.domain.Street;
import edu.javacourse.studentorder.exception.DaoException;

import java.sql.*;
import java.util.LinkedList;
import java.util.List;

public class DictionaryDaoImpl implements DictionaryDao
{
    private final static String GET_STREET = "SELECT street_code, street_name FROM jc_street WHERE UPPER(street_name) LIKE UPPER(?)";// SQL запрос
    private Connection getConnection() throws SQLException {
        Connection con = DriverManager.getConnection( // поиск драйвера с помощью драйвер менеджера ( через class path)
                "jdbc:postgresql://localhost:5432/jc_student",
                "postgres",
                "123123"
        );
        return con;
    }

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
    };

}
