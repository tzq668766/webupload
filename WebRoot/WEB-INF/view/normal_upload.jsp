<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@include file="common/taglibs.jsp" %>
<html>
<head>
    <jsp:include page="common/header_content.jsp"/>
    <!--引入webuploader CSS-->
    <link rel="stylesheet" type="text/css" href="${contextPath}/js/webuploader/webuploader.css">
    <!--引入webuploader JS-->
    <script type="text/javascript" src="${contextPath}/js/webuploader/webuploader.js"></script>
    <title>File Upload</title>
</head>
<body class="dark">
<div class="wrapper">
    <div class="row text-center" id="msgBox" style="font-size:16px;"></div>
    <div class="container text-center" style="margin-top:20px;">
        <div class="row page-header">
            使用<a class="btn" href="http://fex.baidu.com/webuploader/getting-started.html"   target="_blank">WEB uploader</a>上传文件
        </div>
        <div class="row">
            <div id="uploaderbox">
                <!--用来存放文件信息-->
                <table class="table table-striped" id="thelist">
                    <tr><td>文件名</td><td>状态</td></tr>
                </table>
                <div class="row">
                    <a href="javascript:void(0);" id="picker">选择文件</a>
                    <a href="javascript:void(0);" id="uploadBtn" class="btn btn-default col-md-6">开始上传</a>
                </div>
                <div class="row" id="resultBox"></div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<script>
    var BASE_URL="${contextPath}";
    var UPLOAD_URL="${contextPath}/doupload";

    var uploader = WebUploader.create({
        // swf文件路径
        swf: BASE_URL + '/js/webuploader/Uploader.swf',
        // 文件接收服务端。
        server: UPLOAD_URL,
        // 选择文件的按钮。可选。
        // 内部根据当前运行是创建，可能是input元素，也可能是flash.
        pick: '#picker',
        // 不压缩image, 默认如果是jpeg，文件上传前会压缩一把再上传！
        resize: false,
        fileVal:'thumbFile',
        formData:{imageType:"aaaa"}
    });

    $(function () {
        initUploader();
        listenUploadBtn();
    });

    function initUploader(){
        // 当有文件被添加进队列的时候
        uploader.on( 'fileQueued', function( file ) {
            $('#thelist').append(' <tr id="'+file.id+'"><td>'+file.name+'</td><td><p class="state">等待上传...</p><p class="progress"><span class="progress-bar"></span></p></td></tr>');
        });

        // 文件上传过程中创建进度条实时显示。
        uploader.on( 'uploadProgress', function( file, percentage ) {
            var $li = $( '#'+file.id ),
                    $percent = $li.find('.progress .progress-bar');

            // 避免重复创建
            if ( !$percent.length ) {
                $percent = $('<div class="progress progress-striped active">' +
                        '<div class="progress-bar" role="progressbar" style="width: 0%">' +
                        '</div>' +
                        '</div>').appendTo( $li ).find('.progress-bar');
            }

            $li.find('p.state').text('上传中');

            $percent.css( 'width', percentage * 100 + '%' );
        });

        uploader.on( 'uploadSuccess', function( file,response ) {
            $( '#'+file.id ).find('p.state').text('已上传');
            showResult(response);
        });

        uploader.on( 'uploadError', function( file ) {
            $( '#'+file.id ).find('p.state').text('上传出错');
        });

        uploader.on( 'uploadComplete', function( file ) {
            $( '#'+file.id ).find('.progress').fadeOut();
        });
    }

    function listenUploadBtn(){
        $('#uploadBtn').bind("click",function(){
            uploader.upload();
        });
    }

    function showResult(resp){
        var img='<img src="http://'+resp.data.image+'" style="width:100px;height:100px;"/>';
        $('#resultBox').append(img);
    }
</script>
