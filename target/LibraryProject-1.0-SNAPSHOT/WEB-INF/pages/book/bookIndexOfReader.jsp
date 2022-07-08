<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%--<%
    String path=request.getContextPath();
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>--%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>图书管理</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css" media="all">
    <script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">

        <div class="demoTable">
            <div class="layui-form-item layui-form ">
                图书编号：
                <div class="layui-inline">
                    <input class="layui-input" name="isbn" id="isbn" autocomplete="off">
                </div>
                书名：
                <div class="layui-inline">
                    <input class="layui-input" name="name" id="name" autocomplete="off">
                </div>
                图书分类：
                <div class="layui-inline">
                    <select id="typeId" name="typeId" lay-verify="required">
                        <option value="">请选择</option>
                    </select>
                </div>
                <button class="layui-btn" data-type="reload">搜索</button>
            </div>
        </div>

        <!--表单，查询出的数据在这里显示-->
        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

    </div>
</div>

<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery,
            form = layui.form,
            table = layui.table;

        //动态获取图书类型的数据，即下拉菜单，跳出图书类型
        $.get("findAllList", {}, function (data) {
            var list = data;
            var select = document.getElementById("typeId");
            if (list != null || list.size() > 0) {
                for (var obj in list) {
                    var option = document.createElement("option");
                    option.setAttribute("value", list[obj].id);
                    option.innerText = list[obj].name;
                    select.appendChild(option);
                }
            }
            form.render('select');
        }, "json")


        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/bookAll',//查询类型数据
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                // {type: "checkbox", width: 50},
                //{field: 'id', width: 100, title: 'ID', sort: true},
                {field: 'isbn', width: 200, title: '图书编号'},
                {field: 'name', width: 200, title: '图书名称'},
                {templet: '<div>{{d.typeInfo.name}}</div>', width: 200, title: '图书类型'},
                {field: 'author', width: 260, title: '作者'},
                {field: 'price', width: 320, title: '价格'},
                {field: 'language', width: 160, title: '语言'}
            ]],
            limits: [10, 15, 20, 25, 50, 100],
            limit: 15,  <!--默认显示15条-->
            page: true,
            skin: 'line',
            id: 'testReload'
        });

        var $ = layui.$, active = {
            reload: function () {
                var name = $('#name').val();
                var isbn = $('#isbn').val();
                var typeId = $('#typeId').val();
                console.log(name)
                //执行重载
                table.reload('testReload', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: {
                        name: name,
                        isbn: isbn,
                        typeId: typeId
                    }
                }, 'data');
            }
        };

        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });


    });
</script>

</body>
</html>
