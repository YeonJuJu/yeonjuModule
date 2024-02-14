<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
	<title>유연주 movableDiv</title>
	<link href="<c:url value='/css/movableDiv.css'/>" rel="stylesheet" type="text/css"/>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
	<script type="text/javascript">
	
		window.onload = function() {
			
			/*  checkpoint : 드래그 한 div 가 목록이나 장바구니 위에 있을 경우 (hover) modal 관련하여 추후 개발 예정
			 *	movableList_A : 목록		-> list A 에 있는 item을 list B에 추가할 수 있음 (더블클릭, 또는 드래그 앤 드롭)
			 *	movableList_B : 장바구니	-> list B 에 있는 item을 삭제하거나 순서를 변경할 수 있음. (더블클릭(or list A로 드래그 앤 드롭) : item 삭제, 드래그 앤 드롭 : 순서 변경)
			 */
			
			const movableList_A = document.querySelector("#movableList_A");
			const movableList_B = document.querySelector("#movableList_B");
			
			const movableItems_A = movableList_A.querySelectorAll(".movable_item");
			const movableItems_B = movableList_B.querySelectorAll(".movable_item");
			
			// 1. movableList_A Event Setting
			
			// 1-1. movableList_A > dragenter event : 드래그한 요소가 해당 영역에 들어왔을 때
			movableList_A.addEventListener("dragenter", (e) => {
				
				// checkpoint : 추후 개발
				// dragenter 이벤트에서는 itemId 접근 불가. 따라서 dragging 클래스를 가진 객체 검색 후 movableList_A 아이템이면 리턴, movableList_B 아이템이면 모달 on.
				/* const sortingList = document.querySelector("#movableList_B");
				const draggingItem = sortingList.querySelector(".dragging");
				
				if(draggingItem == null)
					return;
				
				$("#modal_A").fadeIn(); */
				
			});
			
			// 1-2. movableList_A > dragleave event : 드래그한 요소가 해당 영역에서 벗어났을 때
			movableList_A.addEventListener("dragleave", (e) => {
				
				// checkpoint : 추후 개발
				// 삭제 관련 modal off
				//$("#modal_A").fadeOut();
				
			});
			
			// 1-3. movableList_A > dragover event : 드래그한 요소가 해당 영역을 지나갈 때
			movableList_A.addEventListener("dragover", (e) => {
				
				// 드롭을 허용하기 위해 기본 동작 막기
				e.preventDefault();
				
			});
			
			// 1-4. movableList_A > drop event : 드래그한 요소를 해당 영역에 drop할 때
			movableList_A.addEventListener("drop", (e) => {
				
				const itemId = e.dataTransfer.getData("text/plain");
				
				// movableList_B 의 아이템이면 movableList_B 에서 해당 아이템 삭제
				if(itemId.includes("itemB")){
					const item = document.querySelector(`#\${itemId}`);
			        item.remove();
				}
				
			});
			
			// 2. movableList_B Event Setting
			
			// 2-1. movableList_B > dragenter event : 드래그한 요소가 해당 영역에 들어왔을 때
			movableList_B.addEventListener("dragenter", (e) => {

				// checkpoint : 추후 개발
				// movableList_A 의 아이템이면 삽입 관련 모달 on
				
			});
			
			// 2-2. movableList_B > dragleave event : 드래그한 요소가 해당 영역에서 벗어났을 때
			movableList_B.addEventListener("dragleave", (e) => {
				
				// checkpoint : 추후 개발
				// 삽입 관련 modal off
				
			});
			
			// 2-3. movableList_B > dragover event : 드래그한 요소가 해당 영역을 지나갈 때
			movableList_B.addEventListener("dragover", (e) => {
				
				// 드롭을 허용하기 위해 기본 동작 막기
				e.preventDefault();
				
				// dragover 이벤트에서는 itemId 접근 불가. 따라서 dragging 클래스를 가진 객체 검색 후 movableList_A 아이템이면 리턴, movableList_B 아이템이면 위치 변경.
				const sortingList = document.querySelector("#movableList_B");
				const draggingItem = sortingList.querySelector(".dragging");

				if(draggingItem == null)
					return;
				
				const siblings = [...sortingList.querySelectorAll(".movable_item:not(.dragging)")];
				const nextSibling = siblings.find(sibling => {	    	
			        return e.clientY <= sibling.offsetTop + sibling.offsetHeight / 2;
			    });
				
				sortingList.insertBefore(draggingItem, nextSibling);
				
			});
			
			// 2-4. movableList_B > drop event : 드래그한 요소를 해당 영역에 drop할 때
			movableList_B.addEventListener("drop", (e) => {
				
				const itemId = e.dataTransfer.getData("text/plain");
				
				// movableList_A 의 아이템이면 해당 아이템 추가
				if(itemId.includes("itemA")){
					
					const item = document.querySelector(`#\${itemId}`);
			        const itemClone = item.cloneNode(true);
			        const newItemId = "itemB" + itemId.substr(5);
			        
			        // 이미 해당 아이템이 movableList_B 에 존재하면 알림메시지 후 추가 X
			        const sameItem = document.querySelector(`#\${newItemId}`);
			        
			        if(sameItem != null)
			        	alert('중복된 항목입니다.');
			        else{
			        	itemClone.setAttribute("id", newItemId);
			        	itemClone.classList.remove("dragging");
			        	
			        	movableList_B.appendChild(itemClone);
			        	
			        	itemClone.addEventListener("dragstart", (e) => {
					    	e.dataTransfer.setData("text/plain", e.target.id);
					        setTimeout(() => itemClone.classList.add("dragging"), 0);
					    });
			        	
			        	itemClone.addEventListener("dragend", () => itemClone.classList.remove("dragging"));
			        }
				}
				
			});
			
			// 3. movableItems_A Event Setting
			
			movableItems_A.forEach(item => {
				
			    // 드래그가 시작되면 dragging 클래스 추가
			    item.addEventListener("dragstart", (e) => {
			    	e.dataTransfer.setData("text/plain", e.target.id);
			        setTimeout(() => item.classList.add("dragging"), 0);
			    });
			    
			    // 드래그가 끝난후 dragging 클래스 제거
			    item.addEventListener("dragend", () => item.classList.remove("dragging"));

			});
			
			// 4. movableItems_B Event Setting
			
			movableItems_B.forEach(item => {
				
			    // 드래그가 시작되면 dragging 클래스 추가
			    item.addEventListener("dragstart", (e) => {
			    	e.dataTransfer.setData("text/plain", e.target.id);
			        setTimeout(() => item.classList.add("dragging"), 0);
			    });
			    
			    // 드래그가 끝난후 dragging 클래스 제거
			    item.addEventListener("dragend", () => item.classList.remove("dragging"));

			});	
		
		}

	</script>
</head>
<body>

<!-- MOVABLE DIV START -->
<div class="movable_container">
	
	<div class="movable_div_title">
		<h1>나의 메뉴 추가</h1>
	</div>
	
	<div class="movable_div">
		<ul id="movableList_A" class="movable_list scrollbar">
			<li id="itemA_1" class="movable_item" draggable="true">
				<div class="details">목록 리스트 1번입니다.</div>
			</li>
			<li id="itemA_2" class="movable_item" draggable="true">
				<div class="details">목록 리스트 2번입니다.</div>
			</li>
			<li id="itemA_3" class="movable_item" draggable="true">
				<div class="details">목록 리스트 3번입니다.</div>
			</li>
			<li id="itemA_4" class="movable_item" draggable="true">
				<div class="details">목록 리스트 4번입니다.</div>
			</li>
			<li id="itemA_5" class="movable_item" draggable="true">
				<div class="details">목록 리스트 5번입니다.</div>
			</li>
			<li id="itemA_6" class="movable_item" draggable="true">
				<div class="details">목록 리스트 6번입니다.</div>
			</li>
			<li id="itemA_7" class="movable_item" draggable="true">
				<div class="details">목록 리스트 7번입니다.</div>
			</li>
			<li id="itemA_8" class="movable_item" draggable="true">
				<div class="details">목록 리스트 8번입니다.</div>
			</li>
			<li id="itemA_9" class="movable_item" draggable="true">
				<div class="details">목록 리스트 9번입니다.</div>
			</li>
			<li id="itemA_10" class="movable_item" draggable="true">
				<div class="details">목록 리스트 10번입니다.</div>
			</li>
			<li id="itemA_11" class="movable_item" draggable="true">
				<div class="details">목록 리스트 11번입니다.</div>
			</li>
			<li id="itemA_12" class="movable_item" draggable="true">
				<div class="details">목록 리스트 12번입니다.</div>
			</li>
			<li id="itemA_13" class="movable_item" draggable="true">
				<div class="details">목록 리스트 13번입니다.</div>
			</li>
			<li id="itemA_14" class="movable_item" draggable="true">
				<div class="details">목록 리스트 14번입니다.</div>
			</li>
		</ul>
		<div id="modal_A" style='display:none; position:absolute; width:450px; height:720px; z-index:1; text-align:center;'>
			<div style="margin-left:45px; margin-top:70%;">
				<img src="<c:url value='/images/movableDiv/delete.png'/>"/>
			</div>
			<div id='modal_layer_A' style=' position:absolute; top:16px; left:25px; width:100%; height:100%; background:rgba(0,0,0,0.3); border-radius: 7px; z-index:-1;'></div>
		</div>
	</div>
	
	<div class="movable_div">
		<ul id="movableList_B" class="movable_list scrollbar">
			<li id="itemB_1" class="movable_item" draggable="true">
				<div class="details">나의 업무 리스트 1번입니다.</div>
				<input type="hidden" name="myMenuItems" value="11111"/>
			</li>
			<li id="itemB_2" class="movable_item" draggable="true">
				<div class="details">나의 업무 리스트 2번입니다.</div>
				<input type="hidden" name="myMenuItems" value="22222"/>
			</li>
			<li id="itemB_3" class="movable_item" draggable="true">
				<div class="details">나의 업무 리스트 3번입니다.</div>
				<input type="hidden" name="myMenuItems" value="33333"/>
			</li>
			<li id="itemB_4" class="movable_item" draggable="true">
				<div class="details">나의 업무 리스트 4번입니다.</div>
				<input type="hidden" name="myMenuItems" value="44444"/>
			</li>
			<li id="itemB_5" class="movable_item" draggable="true">
				<div class="details">나의 업무 리스트 5번입니다.</div>
				<input type="hidden" name="myMenuItems" value="55555"/>
			</li>
			<li id="itemB_6" class="movable_item" draggable="true">
				<div class="details">나의 업무 리스트 6번입니다.</div>
				<input type="hidden" name="myMenuItems" value="66666"/>
			</li>
		</ul>
		<div id="modal_B" style='display:none; position:absolute; width:450px; height:720px; z-index:1; text-align:center;'>
			<div style="margin-left:45px; margin-top:70%;">
				<img src="<c:url value='/images/movableDiv/add.png'/>"/>
			</div>
			<div id='modal_layer_B' style=' position:absolute; top:16px; left:25px; width:100%; height:100%; background:rgba(0,0,0,0.3); border-radius: 7px; z-index:-1;'></div>
		</div>
	</div>
</div>
<!-- MOVABLE DIV END -->

</body>
</html>
