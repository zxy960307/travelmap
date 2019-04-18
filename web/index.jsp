<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://"
                + request.getServerName() + ":" + request.getServerPort()
                + path + "/";
    %>
    <title>$Title$</title>
    <base href="<%=basePath%>">
    <link href="assets/css/bootstrap.css" type="text/css" rel="stylesheet" media="all">
    <link href="assets/css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="assets/css/font-awesome.min.css" rel="stylesheet">
  </head>
  <body>
  <div>
      <section class="main-banner" id="home">
          <div class="container">
              <div class="baner-info-w3ls text-left">
                  <h1><a href="index.html">Your Travel Map</a></h1>
                  <h6 class="mx-auto mt-4">记录你一生的旅行足迹。</h6>
                  <a class="btn btn-primary mt-lg-5 mt-3 agile-link-bnr scroll" href="<%=basePath%>travelMap/getAll" role="button">进入 “旅行地图”</a>
              </div>
          </div>
      </section>
  </div>
  <script>
    <%--window.onload=function(){--%>
      <%--window.location="<%=basePath%>travelMap/getAll";--%>
    <%--}--%>
  </script>
  </body>
</html>
