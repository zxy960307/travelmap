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
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <base href="<%=basePath%>">
    <title>我的旅行地图</title>
    <link href="assets/css/bootstrap.css" rel="stylesheet" />
    <link href="assets/layer/theme/default/layer.css">
    <script type="text/javascript" src="assets/js/jquery-1.11.3.min.js"></script>
    <script type="text/javascript" src="assets/layer/layer.js"></script>
</head>
<body>
<div class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">我的旅行地图</h3>
    </div>
    <div class="panel-body">
        <div>
            <form role="form" class="col-lg-4" method="post" action="<%=basePath%>travelMap/insert">
                <div class="form-group">
                    <label for="place">place</label>
                    <input name="place" id="place" type="text" class="form-control" placeholder="" onblur="getLocation()">
                </div>
                <div class="form-group">
                    <label for="details">what happened</label>
                    <textarea name="details" id="details" class="form-control" rows="3"></textarea>
                </div>
                <div class="form-group" id="locationDiv">
                    <label for="location">location</label>
                    <input id="location" name="location" type="text" class="form-control" placeholder="">
                </div>
                <div class="input-group ">
                    <div class="col-lg-5 col-md-offset-2">
                        <button type="submit" class="btn btn-lg btn-info">添加</button>
                    </div>
                </div>
            </form>
        </div>
        <div class="col-md-6 col-md-offset-1">
            <div id="main" style="height:500px;"></div>
        </div>
    </div>
</div>
<script src="assets/js/jquery-1.10.2.js"></script>
<script src="assets/js/jquery.min.js"></script>
<script src="assets/js/bootstrap.js"></script>
<script src="assets/js/echarts.min.js"></script>
<script src="assets/js/echartsTheme/macarons.js"></script>
<script src="assets/js/china.js"></script>
<script>

    //初始化echarts主题
    var myChart = echarts.init(document.getElementById('main'),'macarons');

    //使用百度地图api获取经纬度
    function getLocation() {

        var token = 'R9fZGHYAqX0xnzV5f9Hgww3HeKI0ezh5'
        var url = 'http://api.map.baidu.com/geocoder/v2/?output=json&ak=' + token + '&address='
        var place = $("#place").val();

        $.getJSON(url + place + '&callback=?', function(res) {
            if (res.status === 0) {
                var locationStr = res.result.location.lng+","+res.result.location.lat;
                $("#location").val(locationStr);
            }else{
                alert('百度没有找到地址信息');
            }
        })
    }

    //获取请求信息
    var allStr = "${resultStr}";
    var elements = allStr.split("*");
    var data = [];
    var details = {};
    var element;
    for (var i =0;i<elements.length;i++) {
        var tinyElement = elements[i].split("%");
        var valueStr = tinyElement[1];
        details[tinyElement[0]] = tinyElement[2];
        data.push({name:tinyElement[0],value:valueStr.split(",")});
    }

    //绘制地图
    function drawMap(data) {
        var option = {
            backgroundColor: '#fff',
            title: {
                text: '足迹',
                left: 'center',
                textStyle: {
                    color: '#696969'
                }
            },
            tooltip: {
                trigger: 'item'
            },
            geo: {
                map: 'china',
                label: {
                    emphasis: {
                        show: false
                    }
                },
                roam: 'scale',
                itemStyle: {
                    normal: {
                        areaColor: '#ddd',
                        borderColor: '#eee'
                    },
                    emphasis: {
                        areaColor: '#e6b600'
                    }
                }
            },
            series: [{
                name: 'place',
                type: 'scatter',
                symbol:'diamond',
                coordinateSystem: 'geo',
                data: data,
                symbolSize: function(val) {
                    return 10;
                },
            }]
        }
        myChart.setOption(option);
        myChart.on('click', function(params){
            //点击相关地点时,弹出框
            if (params.componentType == "series") {
                var place = params.name;
                var detail = details[place];
                    //iframe层
                layer.open({
                    type: 1,
                    title: '详情',
                    shadeClose: true,
                    shade: 0.8,
                    area: ['500px', '50%'],
                    content: '<html>\
                            <div class="col-md-8" style="padding-top: 20px">\
                            <h3><span class="label label-success">place</span></h3>\
                            <p>'+place+'</p>\
                            <br>\
                            <h3><span class="label label-success">detail</span></h3>\
                            <p>'+detail+'</p>\
                            </div>\
                            </html>' //iframe的url
                });
            }
//            alert(params.componentType);
//            console.log(params);//此处写点击事件内容
            else{
                var icons = 6;
                layer.alert("在这儿还没有您的足迹哦，等待与您的下一次邂逅。", {
                    icon:icons
                });
            }
        });
    }
    //隐藏location
    $(document).ready(function() {
        $("#locationDiv").hide();
        drawMap(data);
    });
</script>
</body>
</html>
