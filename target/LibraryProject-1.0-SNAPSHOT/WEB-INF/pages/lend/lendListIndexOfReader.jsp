<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <title>借阅书籍</title>
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/lib/layui-v2.5.5/css/layui.css" media="all">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css" media="all">
</head>
<body>
<div class="layuimini-container">
    <div class="layuimini-main">

        <div class="layuimini-main">
            <div class="demoTable">
                <div class="layui-form-item layui-form ">
<%--                    借书卡--%>
<%--                    <div class="layui-inline">--%>
<%--                        <input class="layui-input" name="readerNumber" id="readerNumber" autocomplete="off">--%>
<%--                    </div>--%>
                    图书名称
                    <div class="layui-inline">
                        <input class="layui-input" name="name" id="name" autocomplete="off">
                    </div>
<%--                    归还类型--%>
<%--                    <div class="layui-inline">--%>
<%--                        <select class="layui-input" name="type" id="type">--%>
<%--                            <option value=""></option>--%>
<%--                            <option value="0">正常还书</option>--%>
<%--                            <option value="1">延迟还书</option>--%>
<%--                            <option value="2">破损还书</option>--%>
<%--                            <option value="3">丢失</option>--%>
<%--                        </select>--%>
<%--                    </div>--%>
<%--                    图书类型--%>
<%--                    <div class="layui-inline">--%>
<%--                        <select class="layui-input" name="status" id="status">--%>
<%--                            <option value=""></option>--%>
<%--                            <option value="0">未借出</option>--%>
<%--                            <option value="1">在借中</option>--%>
<%--                        </select>--%>
<%--                    </div>--%>
                    <button class="layui-btn" data-type="reload">搜索</button>
                </div>
            </div>
        </div>
        <script type="text/html" id="toolbarDemo">
            <div class="layui-btn-container">
                <button class="layui-btn layui-btn-normal layui-btn-sm data-add-btn" lay-event="add"> 借书</button>
            </div>
        </script>

        <table class="layui-hide" id="currentTableId" lay-filter="currentTableFilter"></table>

    </div>
</div>
<script src="${pageContext.request.contextPath}/lib/layui-v2.5.5/layui.js" charset="utf-8"></script>
<script>
    layui.use(['form', 'table'], function () {
        var $ = layui.jquery,
            form = layui.form,
            table = layui.table;

        table.render({
            elem: '#currentTableId',
            url: '${pageContext.request.contextPath}/lendListAll',//查询借阅图书记录
            toolbar: '#toolbarDemo',
            defaultToolbar: ['filter', 'exports', 'print', {
                title: '提示',
                layEvent: 'LAYTABLE_TIPS',
                icon: 'layui-icon-tips'
            }],
            cols: [[
                // {type: "checkbox", width: 50},
                //{field: 'id', width: 100, title: 'ID', sort: true},
                {
                    templet: '<div><a href="javascript:void(0)" style="color:#00b7ee" lay-event="bookInfoEvent">{{d.bookInfo.name}}</a></div>',
                    width: 360, title: '图书名称'
                },
                // {
                //     templet: '<div>{{d.readerInfo.readerNumber}}</div>',
                //     width: 150, title: '借书卡'
                // },
                // {
                //     templet: '<div><a href="javascript:void(0)" style="color:#00b7ee" lay-event="readerInfoEvent">{{d.readerInfo.realName}}</a></div>',
                //     width: 190, title: '借阅人'
                // },
                {
                    templet: "<div>{{layui.util.toDateString(d.lendDate,'yyyy-MM-dd HH:mm:ss')}}</div>",
                    width: 350,
                    title: '借阅时间'
                },
                {
                    field: 'backDate',
                    width: 390,
                    title: '还书时间'
                },
                {
                    title: "还书类型",
                    minWidth: 300,
                    templet: function (res) {
                        if (res.backType == '0') {
                            return '<span class="layui-badge layui-bg-green">已归还</span>'
                        } else if (res.backType == '1') {
                            return '<span class="layui-badge layui-bg-green">已归还</span>'
                        } else if (res.backType == '2') {
                            return '<span class="layui-badge layui-bg-green">已归还</span>'
                        } else if (res.backType == '3') {
                            return '<span class="layui-badge layui-bg-green">已归还</span>'
                        } else {
                            return '<span class="layui-badge layui-bg-red">在借中</span>'
                        }
                    }
                }
            ]],
            limits: [10, 15, 20, 25, 50, 100],
            limit: 15,
            page: true,
            skin: 'line',
            id: 'testReload'
        });


        var $ = layui.$, active = {
            reload: function () {
                var name = $('#name').val();
                var readerNumber = $('#readerNumber').val();
                var backType = $('#backType').val();
                var status = $('#status').val();
                //执行重载
                table.reload('testReload', {
                    page: {
                        curr: 1 //重新从第 1 页开始
                    }
                    , where: {
                        name: name,
                        readerNumber: readerNumber,
                        backType: backType,
                        status: status
                    }
                }, 'data');
            }
        };


        $('.demoTable .layui-btn').on('click', function () {
            var type = $(this).data('type');
            active[type] ? active[type].call(this) : '';
        });


        /**
         * tool操作栏监听事件
         */
        table.on('tool(currentTableFilter)', function (obj) {
            var data = obj.data;
            if (obj.event === 'bookInfoEvent') {//书的借阅线
                //获取书的id
                var bid = data.bookId;
                queryLookBookList("book", bid);
            } else {//读者借阅线
                //获取读者的id
                var rid = data.readerId;
                queryLookBookList("user", rid);
            }
        });

        /**
         * 借阅线打开内容
         */
        function queryLookBookList(flag, id) {
            var index = layer.open({
                title: '借阅时间线',
                type: 2,
                shade: 0.2,
                maxmin: true,
                shadeClose: true,
                area: ['60%', '60%'],
                content: '${pageContext.request.contextPath}/queryLookBookList?id=' + id + "&flag=" + flag,
            });
            $(window).on("resize", function () {
                layer.full(index);
            });
        }


        /**
         * toolbar监听事件
         */
        table.on('toolbar(currentTableFilter)', function (obj) {
            if (obj.event === 'add') {  // 监听添加操作
                var index = layer.open({
                    title: '借阅书籍',
                    type: 2,
                    shade: 0.2,
                    maxmin: true,
                    shadeClose: true,
                    area: ['100%', '100%'],
                    content: '${pageContext.request.contextPath}/addLendList',
                });
                $(window).on("resize", function () {
                    layer.full(index);
                });
            }
        });

    });
</script>

</body>
</html>
