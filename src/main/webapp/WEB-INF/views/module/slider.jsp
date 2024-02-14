<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page session="false" %>
<html>
<head>
	<meta charset="UTF-8">
	<title>유연주 slider</title>
	<link href="<c:url value='/css/slider.css'/>" rel="stylesheet" type="text/css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">

		window.onload = function() {		
			
			// 1.이미지 정보 세팅
			setImgInfo();
			
			// 2.이미지 슬라이드 세팅 
			setImgSlide();		
		}
		
		/* 
		function ID : setImgInfo
		description : 이미지 정보 세팅
		*/
		function setImgInfo(){
			// slider_button_div 의 width => (slider_div width) + 40px
			// slider_button > img : margin-top => ((slider_div height) / 2) - 10px
		}
	
		/*
		function ID : setImgSlide
		description : 이미지 슬라이드 세팅
		*/
		function setImgSlide(){
			
			// 1. 슬라이드 관련 변수 선언
			const slider = document.querySelector('.slider_ul');				// slider_ul
			const slider_li_original = slider.querySelectorAll('li');			// slider_ul > li list (clone img 삽입 전 원본)
			const moveButton = document.querySelector('.slider_button_div');	// slider_button_div
			
		    const cloneFirst = slider_li_original[0].cloneNode(true);								// slider 이미지 중 첫번째 이미지 clone
		    const cloneLast = slider_li_original[slider_li_original.length - 1].cloneNode(true);	// slider 이미지 중 마지막 이미지 clone
		    
			const speedTime = 500;	// 슬라이드 이동 속도
		    let currentIdx = 0;		// 슬라이드 현재 인덱스
			let translate = 0;		// 슬라이드 위치 (기본 위치를 기준으로 절대적 위치)

			// 2. 슬라이드 clone 이미지 양 끝에 추가 (첫번째 이미지를 slider_ul 마지막에 삽입. 마지막 이미지를 slider_ul 첫번째에 삽입)
		    slider.insertBefore(cloneLast, slider.firstChild);
		    slider.appendChild(cloneFirst);
			
			// 3. 양 끝에 clone 이미지 넣어줬으므로 slider_ul > li list 다시 구해줌
			const slider_li =  slider.querySelectorAll('li');			// slider_ul > li list
			const slider_li_width = slider_li[0].clientWidth;			// slider_ul > li width
			const slider_width = slider_li_width * slider_li.length;	// slider_ul width
			
			// 4. slider_ul width 세팅
			slider.style.width = `\${slider_width}px`;
			
			// 5. 맨 앞에 clone 이미지 삽입해줬으므로 currentIdx와 translate 다시 세팅 
			currentIdx = 1;					// 실제로 사용자가 지정한 맨 첫번째 이미지는 html 소스 상 2번째 이미지이므로 1로 세팅
			translate = -slider_li_width;	// 실제로 사용자가 지정한 맨 첫번째 이미지는 html 소스 상 2번째 이미지이므로 slider 왼쪽으로 이동
			slider.style.transform = `translateX(\${translate}px)`;	// slider 이동
			slider.style.transition = 'none';						// slider 이동 속도 세팅
			
			// 6. slider 이동 버튼 세팅
			moveButton.addEventListener('click', moveSlide);

			/*
			function ID : move
			description : slider 이동
			*/
			function move(D) {
			      currentIdx += (-1 * D); 			// 슬라이드 인덱스 세팅 : D = 1 or -1. 현재 이미지의 다음 이미지를 보여줄 경우 currentIdx += 1, 이전 이미지를 보여줄 경우 currentIdx -= 1
			      translate += slider_li_width * D; // 슬라이드 위치 세팅 : D = 1 or -1. 현재 이미지의 다음 이미지를 보여줄 경우 왼쪽으로 이동해야 하기 때문에 translate += (-slider_li_width), 이전 이미지를 보여줄 경우 translate += slider_li_width
			      slider.style.transform = `translateX(\${translate}px)`;	// slider 이동
			      slider.style.transition = `all \${speedTime}ms ease`;		// slider 이동 속도 세팅
			 }

			/*
			function ID : moveSlide
			description : slider 이동 및 양 끝 이미지에 도달했을 경우 div 이동
			*/
			function moveSlide(event) {
			    event.preventDefault();
			    
			    // 1. 현재 이미지의 다음 이미지를 보여줄 경우
			    if (event.target.className === 'slider_button_right') {
			    	
			    	// 1-1. 이미지 이동 
			    	move(-1);
			    	
			    	// 1-2. 이동한 이미지가 마지막 이미지일 경우 ul 맨 앞으로 이동해 부드럽게 이미지가 연결되도록 해준다.
			    	if (currentIdx === slider_li.length -1) // 이동한 이미지가 마지막 이미지일 경우 : 클론 제외 첫번째 이미지로 이동
			            setTimeout(() => {					// slider 이동속도에 맞춰 자연스럽게 세팅해주기 위해 setTimeOut 이용
			              slider.style.transition = 'none'; // 눈속임을 위해 transition none
			              currentIdx = 1;					// currentIdx = 1로 세팅. (맨뒤 이미지 = 클론 제외 첫번째 이미지)
			              translate = -slider_li_width; 	// 절대적인 위치이므로 currentIdx 에 맞게 slider_ul 이동
			              slider.style.transform = 'translateX(' + translate + 'px)';	// slider 이동       
			            }, speedTime);
			    
			    // 2. 현재 이미지의 이전 이미지를 보여줄 경우
			    } else if (event.target.className === 'slider_button_left') {
			    	
			    	// 2-1. 이미지 이동
			   		move(1);
			    	 
			   		// 2-2. 이동한 이미지가 첫번째 이미지일 경우 ul 맨 뒤로 이동해 부드럽게 이미지가 연결되도록 해준다.
		       		if (currentIdx === 0)					// 이동한 이미지가 첫번째 이미지일 경우 : 클론 제외 마지막 이미지로 이동
			            setTimeout(() => {					// slider 이동속도에 맞춰 자연스럽게 세팅해주기 위해 setTimeOut 이용
			              slider.style.transition = 'none';	// 눈속임을 위해 transition none
			              currentIdx = slider_li.length -2;	// currentIdx = slider_li.length-2 로 세팅. (맨앞 이미지 = 클론 제외 마지막 이미지)
			              translate = -(slider_li_width * currentIdx); // 절대적인 위치이므로 currentIdx 에 맞게 slider_ul 이동
			              slider.style.transform = 'translateX(' + translate + 'px)';	// slider 이동
			            }, speedTime);
		
				}
			}
		}	
	</script>
</head>

<body>

<!-- SLIDER START -->
<div id="content" class="scrollbar">
	<div class="slider_button_div">
		<img class="slider_button_left" src="images/slider/left_btn.png"/>
		<img class="slider_button_right" src="images/slider/right_btn.png"/>
	</div>
	<div class="slider_div">
		<ul class="slider_ul">
			<li><img src="images/slider/heungR1.png"/></li>
			<li><img src="images/slider/heungR2.png"/></li>
			<li><img src="images/slider/heungR3.png"/></li>
			<li><img src="images/slider/heungR4.png"/></li>
			<li><img src="images/slider/heungR5.png"/></li>
		</ul>
	</div>
</div>
<!-- SLIDER END -->

</body>
</html>
