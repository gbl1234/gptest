<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 알림 적용을 위한 스크립트 부분 시작 --><!-- 알림 적용을 위한 스크립트 부분 시작 --><!-- 알림 적용을 위한 스크립트 부분 시작 --><!-- 알림 적용을 위한 스크립트 부분 시작 -->
<!-- 웹소켓 cdn 삽입 -->
<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<!-- jquery cdn 삽입 -->
<script src="https://code.jquery.com/jquery-3.6.0.js" integrity="sha256-H+K7U5CnXl1h5ywQfKtSj8PCmoN9aaq30gDh27Xc0jk=" crossorigin="anonymous"></script>

<script type="text/javascript">
//소켓이 담길 전역변수
var socket = null;

$(document).ready(function(){
	//로그인한 세션이 있을경우 소켓 생성
	if(${sessionScope.sessionId.id != null}){
		//소켓 객체를 생성 후 전역변수에 담는다
		var soc = new SockJS("/alram");
		socket = soc;
		
		//소켓 연결 함수
		soc.onopen = function() {
			//소켓 연결시 메시지 전송
			//메시지 구성은 ','를 기준으로
			//1.전송할 메시지
			//2.전송 대상
			//으로 이루어져 있고 메시지 구현을 어떤순서로 하느냐에 따라 바뀔 수 있다
			var msg = "${sessionScope.sessionId.name}님이 접속했습니다,all";
			socket.send(msg);
		};
		
		//메시지 수신 함수
		//data의 구성요소
		/* 
		bubbles: false
		cancelable: false
		data: "상품개수 = 4"
		timeStamp: 1660373975643
		type: "message"
		*/
		soc.onmessage = function(data) {
			//현재 시간
			var ctime = new Date();
			//메시지를 받을 시 페이지 알림목록에 메시지 추가
			var apd = "";
			apd += "<a class='dropdown-item d-flex align-items-center mess' href='#'>";
		    apd += "<div class='mr-3'>";
			apd += "<div class='icon-circle bg-warning'>";
		    apd += "<i class='fas fa-exclamation-triangle text-white'></i></div></div><div>";
		    apd += "<div class='small text-gray-500'>"+ctime.toLocaleString()+"</div>";/* 시간이 들어가는 부분  */
		    apd += data.data;/* 메시지가 들어가는 부분 */
		    apd += "</div></a>";
		    //알림목록 앞부분에 추가
			$(".alerts").prepend(apd);
		};
		
		//로그아웃 클릭시 메시지 전송 후 소켓 연결 종료 
		$(".lout").on("click",function(){
			//메시지 구성은 ','를 기준으로
			//1.전송할 메시지
			//2.전송 대상
			//으로 이루어져 있고 메시지 구현을 어떤순서로 하느냐에 따라 바뀔 수 있다
			var msg = "${sessionScope.sessionId.name}님이 종료했습니다,all";
			socket.send(msg);
			//소켓 연결 종료 함수
			soc.onclose = function() {
			};
			socket = null;
		});
		
		//알림목록에서 메시지 클릭시 알림목록에서 제거
		$(".alerts").on("click",".mess",function(){
			$(this).remove();
		});
		
		//7초마다 상품테이블 조회한뒤 dbcount 값이 증가하면 메시지 전송
		var dbcount = 0;
		setInterval(function () {
			//db에서 상품 개수 조회
			$.ajax({
				url:"/product/count",
				type:"get",
				success:function(data){
					if(dbcount < data){
						//이전 상품개수와 현재 상품개수를 비교하여 메시지 전송
						//메시지 구성은 ','를 기준으로
						//1.전송할 메시지
						//2.전송 대상
						//으로 이루어져 있고 메시지 구현을 어떤순서로 하느냐에 따라 바뀔 수 있다
						var msg = "상품개수 = "+data+",me";
						socket.send(msg);
						dbcount = data;
					}else{
						var msg = "상품개수변동없음,me";
						socket.send(msg);
					}
				}
			});
		}, 7000);/* 시간을 설정하는 부분(1000 = 1초)*/
		
		//0.5초마다 알림의 개수 표기
		setInterval(function () {
			//알림목록에 표기된 메시지의 개수를 확인하여 badge에 개수를 표기
			var lecount = $(".mess").length;
			if(lecount==0){
				$(".badgent").text("");	
			}else{
				$(".badgent").text(lecount);
			}
		}, 500);/* 시간을 설정하는 부분(1000 = 1초)*/
	}	
});
</script>
<!-- 알림 적용을 위한 스크립트 부분 끝 --><!-- 알림 적용을 위한 스크립트 부분 끝 --><!-- 알림 적용을 위한 스크립트 부분 끝 --><!-- 알림 적용을 위한 스크립트 부분 끝 -->


<!-- Topbar -->
<nav class="navbar navbar-expand navbar-light bg-white topbar mb-4 static-top shadow">

    <!-- Sidebar Toggle (Topbar) -->
    <button id="sidebarToggleTop" class="btn btn-link d-md-none rounded-circle mr-3">
        <i class="fa fa-bars"></i>
    </button>

    <!-- Topbar Search -->
    <form
        class="d-none d-sm-inline-block form-inline mr-auto ml-md-3 my-2 my-md-0 mw-100 navbar-search">
        <div class="input-group">
            <input type="text" class="form-control bg-light border-0 small" placeholder="Search for..."
                aria-label="Search" aria-describedby="basic-addon2">
            <div class="input-group-append">
                <button class="btn btn-primary" type="button">
                    <i class="fas fa-search fa-sm"></i>
                </button>
            </div>
        </div>
    </form>

    <!-- Topbar Navbar -->
    <ul class="navbar-nav ml-auto">

        <!-- Nav Item - Search Dropdown (Visible Only XS) -->
        <li class="nav-item dropdown no-arrow d-sm-none">
            <a class="nav-link dropdown-toggle" href="#" id="searchDropdown" role="button"
                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-search fa-fw"></i>
            </a>
            <!-- Dropdown - Messages -->
            <div class="dropdown-menu dropdown-menu-right p-3 shadow animated--grow-in"
                aria-labelledby="searchDropdown">
                <form class="form-inline mr-auto w-100 navbar-search">
                    <div class="input-group">
                        <input type="text" class="form-control bg-light border-0 small"
                            placeholder="Search for..." aria-label="Search"
                            aria-describedby="basic-addon2">
                        <div class="input-group-append">
                            <button class="btn btn-primary" type="button">
                                <i class="fas fa-search fa-sm"></i>
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </li>
        

<!-- 알림 내용이 표시되는 태그 부분 시작 --><!-- 알림 내용이 표시되는 태그 부분 시작 --><!-- 알림 내용이 표시되는 태그 부분 시작 --><!-- 알림 내용이 표시되는 태그 부분 시작 -->
<!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- -->
        <!-- Nav Item - Alerts -->
        <li class="nav-item dropdown no-arrow mx-1">
            <a class="nav-link dropdown-toggle" href="#" id="alertsDropdown" role="button"
                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-bell fa-fw"></i>
                <!-- Counter - Alerts -->
                <span class="badge badge-danger badge-counter badgent"></span>
            </a>
            <!-- Dropdown - Alerts -->
            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                aria-labelledby="alertsDropdown">
                <h6 class="dropdown-header">
                    Alerts Center
                </h6>
            <div class="alerts">
<!-- 기존에 사용하던 기본값 부분 -->
<!--              <a class="dropdown-item d-flex align-items-center mess" href="#"> -->
<!--                  <div class="mr-3"> -->
<!--                      <div class="icon-circle bg-warning"> -->
<!--                          <i class="fas fa-exclamation-triangle text-white"></i> -->
<!--                      </div> -->
<!--                  </div> -->
<!--                  <div> -->
<!--                      <div class="small text-gray-500">December 2, 2019</div> -->
<!--                      Spending Alert: We've noticed unusually high spending for your account. -->
<!--                  </div> -->
<!--              </a>     -->
<!--                 <a class="dropdown-item d-flex align-items-center" href="#"> -->
<!--                     <div class="mr-3"> -->
<!--                         <div class="icon-circle bg-primary"> -->
<!--                             <i class="fas fa-file-alt text-white"></i> -->
<!--                         </div> -->
<!--                     </div> -->
<!--                     <div> -->
<!--                         <div class="small text-gray-500">December 12, 2019</div> -->
<!--                         <span class="font-weight-bold">A new monthly report is ready to download!</span> -->
<!--                     </div> -->
<!--                 </a> -->
<!--                 <a class="dropdown-item d-flex align-items-center" href="#"> -->
<!--                     <div class="mr-3"> -->
<!--                         <div class="icon-circle bg-success"> -->
<!--                             <i class="fas fa-donate text-white"></i> -->
<!--                         </div> -->
<!--                     </div> -->
<!--                     <div> -->
<!--                         <div class="small text-gray-500">December 7, 2019</div> -->
<!--                         $290.29 has been deposited into your account! -->
<!--                     </div> -->
<!--                 </a> -->
<!--                 <a class="dropdown-item d-flex align-items-center" href="#"> -->
<!--                     <div class="mr-3"> -->
<!--                         <div class="icon-circle bg-warning"> -->
<!--                             <i class="fas fa-exclamation-triangle text-white"></i> -->
<!--                         </div> -->
<!--                     </div> -->
<!--                     <div> -->
<!--                         <div class="small text-gray-500">December 2, 2019</div> -->
<!--                         Spending Alert: We've noticed unusually high spending for your account. -->
<!--                     </div> -->
<!--                 </a> -->
<!--                 <a class="dropdown-item text-center small text-gray-500" href="#">Show All Alerts</a> -->
            </div>
            </div>
        </li>
<!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- --><!-- -->
<!-- 알림 내용이 표시되는 태그 부분 종료 --><!-- 알림 내용이 표시되는 태그 부분 종료 --><!-- 알림 내용이 표시되는 태그 부분 종료 --><!-- 알림 내용이 표시되는 태그 부분 종료 -->


		<!-- Nav Item - Messages -->
        <li class="nav-item dropdown no-arrow mx-1">
            <a class="nav-link dropdown-toggle" href="#" id="messagesDropdown" role="button"
                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <i class="fas fa-envelope fa-fw"></i>
                <!-- Counter - Messages -->
                <span class="badge badge-danger badge-counter">7</span>
            </a>
            <!-- Dropdown - Messages -->
            <div class="dropdown-list dropdown-menu dropdown-menu-right shadow animated--grow-in"
                aria-labelledby="messagesDropdown">
                <h6 class="dropdown-header">
                    Message Center
                </h6>
                <a class="dropdown-item d-flex align-items-center" href="#">
                    <div class="dropdown-list-image mr-3">
                        <img class="rounded-circle" src="/resources/sbadmin2/img/undraw_profile_1.svg"
                            alt="...">
                        <div class="status-indicator bg-success"></div>
                    </div>
                    <div class="font-weight-bold">
                        <div class="text-truncate">Hi there! I am wondering if you can help me with a
                            problem I've been having.</div>
                        <div class="small text-gray-500">Emily Fowler · 58m</div>
                    </div>
                </a>
                <a class="dropdown-item d-flex align-items-center" href="#">
                    <div class="dropdown-list-image mr-3">
                        <img class="rounded-circle" src="/resources/sbadmin2/img/undraw_profile_2.svg"
                            alt="...">
                        <div class="status-indicator"></div>
                    </div>
                    <div>
                        <div class="text-truncate">I have the photos that you ordered last month, how
                            would you like them sent to you?</div>
                        <div class="small text-gray-500">Jae Chun · 1d</div>
                    </div>
                </a>
                <a class="dropdown-item d-flex align-items-center" href="#">
                    <div class="dropdown-list-image mr-3">
                        <img class="rounded-circle" src="/resources/sbadmin2/img/undraw_profile_3.svg"
                            alt="...">
                        <div class="status-indicator bg-warning"></div>
                    </div>
                    <div>
                        <div class="text-truncate">Last month's report looks great, I am very happy with
                            the progress so far, keep up the good work!</div>
                        <div class="small text-gray-500">Morgan Alvarez · 2d</div>
                    </div>
                </a>
                <a class="dropdown-item d-flex align-items-center" href="#">
                    <div class="dropdown-list-image mr-3">
                        <img class="rounded-circle" src="https://source.unsplash.com/Mv9hjnEUHR4/60x60"
                            alt="...">
                        <div class="status-indicator bg-success"></div>
                    </div>
                    <div>
                        <div class="text-truncate">Am I a good boy? The reason I ask is because someone
                            told me that people say this to all dogs, even if they aren't good...</div>
                        <div class="small text-gray-500">Chicken the Dog · 2w</div>
                    </div>
                </a>
                <a class="dropdown-item text-center small text-gray-500" href="#">Read More Messages</a>
            </div>
        </li>

        <div class="topbar-divider d-none d-sm-block"></div>
		<c:if test="${sessionScope.sessionId.id!=null}">
        <!-- Nav Item - User Information -->
        <li class="nav-item dropdown no-arrow">
            <a class="nav-link dropdown-toggle" href="#" id="userDropdown" role="button"
                data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                <span class="mr-2 d-none d-lg-inline text-gray-600 small">${sessionScope.sessionId.name}님</span>
                <img class="img-profile rounded-circle"
                    src="/resources/sbadmin2/img/undraw_profile.svg">
            </a>
            <!-- Dropdown - User Information -->
            <div class="dropdown-menu dropdown-menu-right shadow animated--grow-in"
                aria-labelledby="userDropdown">
                <a class="dropdown-item" href="/member/detailMember?id=${sessionScope.sessionId.id}">
                    <i class="fas fa-user fa-sm fa-fw mr-2 text-gray-400"></i>
                    Profile
                </a>
                <a class="dropdown-item" href="#">
                    <i class="fas fa-cogs fa-sm fa-fw mr-2 text-gray-400"></i>
                    Settings
                </a>
                <a class="dropdown-item" href="#">
                    <i class="fas fa-list fa-sm fa-fw mr-2 text-gray-400"></i>
                    Activity Log
                </a>
                <div class="dropdown-divider"></div>
                <a class="dropdown-item lout" href="#" data-toggle="modal" data-target="#logoutModal">
                    <i class="fas fa-sign-out-alt fa-sm fa-fw mr-2 text-gray-400"></i>
                    Logout
                </a>
            </div>
        </li>
        </c:if>

    </ul>

</nav>
<!-- End of Topbar -->