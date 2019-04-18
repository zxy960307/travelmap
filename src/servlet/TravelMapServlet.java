package servlet;

import utils.DBCUtil;
import utils.GeneralUtil;
import vo.TravelMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by 41463 on 2019/4/15.
 */
public class TravelMapServlet extends HttpServlet {

    String forwardJspUrl = "/pages/forward.jsp";
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        this.doGet(req, resp);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("utf-8");
        String path = "/errors.jsp"; // 定义默认界面
        //获取跳转值
        String uri = req.getRequestURI();
        String status = req.getRequestURI().substring(req.getRequestURI().lastIndexOf("/")+1);
        //跳转
        if(status != null) {
            if("insert".equals(status)) {
                path = this.insert(req);
            }
            else if ("getAll".equals(status)) {
                path = this.getAll(req);
            }
        }
        req.getRequestDispatcher(path).forward(req,resp);
    }

    public String insert(HttpServletRequest req) {

        //初始化
        String msg = ""; //表示提示信息
        String url = "travelMap/getAll";//跳转路径
        boolean msgStatus = true;
        req.setAttribute("url",url);

        //获取参数
        String place = "";
        String details = "";
        String location = "";
        place = req.getParameter("place");
        details = req.getParameter("details");
        location = req.getParameter("location");

        //检查参数
        if(GeneralUtil.isStrEmpty(place)||GeneralUtil.isStrEmpty(details)||
                GeneralUtil.isStrEmpty(location)) {
            msg = "请填入完整的事项！";
            msgStatus = false;
            req.setAttribute("msg",msg);
            req.setAttribute("msgStatus",msgStatus);
            return forwardJspUrl;
        }

        //封装参数vo
        TravelMap vo = new TravelMap();
        vo.setPlace(place);
        vo.setDetails(details);
        vo.setLocation(location);

        //向数据库插入数据
        Connection conn = new DBCUtil().getConn();
        PreparedStatement pstmt;
        String sql = "INSERT INTO travel( place,details,location ) VALUES (?,?,?)";
        try {
            pstmt = (PreparedStatement) conn.prepareStatement(sql);
            pstmt.setString(1,vo.getPlace());
            pstmt.setString(2,vo.getDetails());
            pstmt.setString(3,vo.getLocation());
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            msg = "数据库中添加记录异常了！";
            msgStatus = false;
            req.setAttribute("msg",msg);
            req.setAttribute("msgStatus",msgStatus);
            return forwardJspUrl;
        }

        msg = "添加记录成功！";
        msgStatus = true;
        req.setAttribute("msg",msg);
        req.setAttribute("msgStatus",msgStatus);
        return forwardJspUrl;
    }

    public String getAll(HttpServletRequest req) {

        //从数据库获取所有数据
        List<TravelMap> results = new ArrayList<>();
        //向数据库插入数据
        Connection conn = new DBCUtil().getConn();
        PreparedStatement pstmt;
        ResultSet rs;
        String sql = "SELECT place,details,location FROM travel";
        try {
            pstmt = (PreparedStatement) conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while(rs.next()) {
                TravelMap temp = new TravelMap();
                temp.setPlace(rs.getString(1));
                temp.setDetails(rs.getString(2));
                temp.setLocation(rs.getString(3));
                results.add(temp);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        //处理数据
        String resultStr = "";
        for (int i =0;i<results.size();i++) {
            resultStr += results.get(i).getPlace()+"%"+results.get(i).getLocation()+"%"+
                    results.get(i).getDetails()+"*";
        }
        resultStr = resultStr.substring(0,resultStr.length()-1);
        req.setAttribute("resultStr",resultStr);
        return "/pages/index.jsp";
    }
}
