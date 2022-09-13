<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	String id  = (String)session.getAttribute("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>프로젝트 개설</title>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<script src="/resources/js/jquery-3.6.0.js"></script>
<script>
$(function(){
//////////////////////////
/* 에디터 */
const Editor = toastui.Editor;
const editor = new Editor({
	  el: document.querySelector('#editor'),
	  height: '500px',
	  initialEditType: 'wysiwyg',
	  previewStyle: 'vertical'
	});
	
//////////////////////////
/* 예산항목 추가 */
var rspanVal = 0;
$("#addcon").on("click",function(){
	rspanVal = rspanVal+1;
	var crat1 = $("#codeRating0 option:selected").val();
	var crat2 = $("#codeRating1 option:selected").val();
	var source = "";
	source += "<div class='row'>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<select class='form-select mb-3' id='codeRating"+rspanVal+"'>";
	if(crat1 == "초급" || crat2 == "초급"){
		source += "<option disabled>초급</option>";
	}else {
		source += "<option>초급</option>";
	}
	if(crat1 == "중급" || crat2 == "중급"){
		source += "<option disabled>중급</option>";
	}else {
		source += "<option>중급</option>";
	}
	if(crat1 == "고급" || crat2 == "고급"){
		source += "<option disabled>고급</option>";
	}else {
		source += "<option>고급</option>";
	}
	source += "</select>";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<input type='text' class='form-control' id='countPerson"+rspanVal+"' placeholder='인원수'>";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<input type='text' class='form-control' id='ccost"+rspanVal+"' />";
	source += "</div>";
	source += "</div>";
	source += "<div class='col-lg-3'>";
	source += "<div class='mb-3'>";
	source += "<button type='button' id='divcon' class='btn btn-outline-danger'><i class='ri-subtract-line'></i></button>";
	source += "</div>";
	source += "</div>";
	source += "</div>";
	$(source).appendTo("#costVal");
	if(rspanVal==2){
		$("#addcon").hide();
	}
});

//////////////////////
/* 예산항목 제거 */
$(document).on("click","#divcon",function(){
	$(this).closest(".row").remove();
	rspanVal = rspanVal-1;
	if(rspanVal<2){
		$("#addcon").show();
	}
});

///////////////////////////
/* 이미지 파일 확장자, 파일 크기 확인 */
$("#projImg").on("change",function(){
	var fImage = $("#projImg")[0].files[0];
	var regex = new RegExp("(.*?)\.(png|jpg)$");
	var maxSize = 5242880;
	var fileName = fImage.name;
	var fileSize = fImage.size;
	if(fileSize >= maxSize) {
	    alert("파일 사이즈는 5MB를 초과할 수 없습니다");
	    $("#projImg").val("");
	}
	if(!regex.test(fileName)) {
	    alert("이미지 파일 확장자는 jpg, png만 가능합니다");
	    $("#projImg").val("");
	}
});

///////////////////////
/* 프로젝트 등록 */
var projId = 0;
$("#create").on("click",function(){
	var name = $("#projName").val();
	var fileImage = $("#projImg")[0].files[0];
	var explan = editor.getHTML();
	var start = $("#startProj").val();
	var end = $("#endProj").val();
	var joinVal = $("#joinValue option:selected").val();
	var paym = $("#payment").val();
	var projCost = [];
	var chkCount = 0;
	var pscnt = 0;
	for(i=0; i<=rspanVal; i++){
		var codeR = $("#codeRating"+i+" option:selected").val();
		var cntP = $("#countPerson"+i).val();
		var ccost = $("#ccost"+i).val();
		pscnt = pscnt+parseInt(cntP)
		if(cntP == "" || ccost == ""){
			chkCount = chkCount+1;
		}
		projCost.push({"codeR":codeR,"cntP":cntP,"ccost":ccost});		
	}
	console.log(projCost)
	console.log(pscnt)
	if(name == "" || start == "" || end == "" || joinVal == "" || paym == "" || chkCount > 0){
		alert("작성하지 않은 항목이 있습니다");
		return false;
	}
	if(parseInt(joinVal) < pscnt){
		alert("프로젝트 인원수 보다 등급인원이 더 많습니다 다시 설정해주세요");
		return false;
	}
	var sdt = {"name":name,"explan":explan,"start":start,"end":end,"paym":paym,"joinVal":joinVal};
	//프로젝트 등록
	$.ajax({
		url:"/project/createProject",
		type:"post",
		data:JSON.stringify(sdt),
		contentType:"application/json; charset=utf-8",
		success:function(res){
			projId = res;
			if(res>0){
				//프로젝트 사진 등록
				if(fileImage != null){
					var formData = new FormData();
					formData.append('file', fileImage);
					$.ajax({
				        type:"POST",
				        enctype:'multipart/form-data',
				        url:"/project/projImg?projId="+projId,
				        data:formData,
				        processData:false,
				        contentType:false,
				        success:function(res){
				        	if(res<1){
				        		alert("이미지 업로드 실패");
				        	}
				        }
					});
				}
				//인건비 등록
				$.ajax({
					url:"/cost/createCost?id="+projId,
					type:"post",
					data:JSON.stringify(projCost),
					contentType:"application/json; charset=utf-8",
					success:function(res){
						if(res>0){
							//프로젝트 생성시 관리자 등록
							var jdt = {"projId":projId,"memId":"<%= id %>"}
							$.ajax({
								url:"/promem/projAdmin",
								type:"post",
								data:JSON.stringify(jdt),
								contentType:"application/json; charset=utf-8",
								success:function(res){
									if(res>0){
										alert("프로젝트 등록 성공");
										location.href="/project/main/"+projId+"/전체";
									}else{
										alert("프로젝트 등록 실패");
									}
								}
							});
						}else{
							alert("프로젝트 등록 실패");
						}
					}
				});
			}else{
				alert("프로젝트 등록 실패");
			}
		}
	});
});
});
</script>
</head>
<body>
<div class="container-fluid">
	<div class="row">
	    <div class="col-lg-12">
	        <div class="card">
	            <div class="card-body">
	                <div class="mb-3">
	                    <label class="form-label" for="projName">프로젝트 이름</label>
	                    <input type="text" class="form-control" id="projName" placeholder="프로젝트 이름" />
	                </div>
	
	                <div class="mb-3">
	                    <label class="form-label" for="projImg">프로젝트 사진</label>
	                    <input class="form-control" id="projImg" type="file" />
	                </div>
	
	                <div class="mb-3">
	                    <label class="form-label">프로젝트 내용</label>
	                    <div id="editor"></div>
	                </div>
	
	                <div class="row">
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                            <label for="joinValue" class="form-label">프로젝트 인원 수</label>
	                            <select class="form-select mb-3" id="joinValue">
                                    <c:forEach var="i" begin="1" end="30" step="1">
										<option>${i}</option>
									</c:forEach>
                                </select>
	                        </div>
	                    </div>
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                            <label for="payment" class="form-label">프로젝트 예산</label>
	                            <input type="text" class="form-control" id="payment" placeholder="금액을 입력하세요" />
	                        </div>
	                    </div>
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                            <label for="startProj" class="form-label">프로젝트 시작일</label>
	                            <input type="date" class="form-control" id="startProj" />
	                        </div>
	                    </div>
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                            <label for="endProj" class="form-label">프로젝트 종료일</label>
	                            <input type="date" class="form-control" id="endProj" />
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <!-- end card body -->
	        </div>
	        <!-- end card -->
	        <div class="card">
	            <div class="card-body" id="costVal">
	                <div class="mb-3">
	                    <label class="form-label">등급 별 보수</label>
	                </div>
	                <div class="row">
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                        	<label for="codeRating0" class="form-label">등급</label>
	                        	<select class="form-select mb-3" id="codeRating0">
									<option>초급</option>
									<option>중급</option>
									<option>고급</option>
								</select>
	                        </div>
	                    </div>
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                            <label for="countPerson0" class="form-label">인원 수</label>
	                            <input type="text" class="form-control" id="countPerson0" placeholder="인원 수" />
	                        </div>
	                    </div>
	                    <div class="col-lg-3">
	                        <div class="mb-3">
	                            <label for="ccost0" class="form-label">금액</label>
	                            <input type="text" class="form-control" id="ccost0" />
	                        </div>
	                    </div>
	                    <div class="col-lg-3">
                        	<label class="form-label">항목 추가/제거</label>	
	                        <div class="mb-3">
	                        	<button type="button" id="addcon" class="btn btn-outline-primary"><i class="ri-add-line"></i></button>
	                        </div>
	                    </div>
	                </div>
	            </div>
	            <!-- end card body -->
	        </div>
	        <!-- end card -->
	        <div class="row g-4 mb-3">
		        <div class="col-sm">
		            <div class="d-flex justify-content-sm-center gap-2">
			        	<button type="button" id="create" class="btn btn-outline-success waves-effect waves-light">프로젝트 등록</button>
	           			<button type="button" id="cancel" class="btn btn-outline-danger waves-effect waves-light">취소</button>
		            </div>
		        </div>
		    </div>
	    </div>
	    <!-- end col -->
	</div>
	<!-- end row -->
</div>
</body>
</html>