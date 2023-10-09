function openSidebar(row) {
    var panelA = document.getElementById("panelA");
    var userName = row.querySelector(".fs-6").textContent;
    var userEmail = row.querySelector(".email").textContent;
    var phone = row.querySelector(".phone").textContent;
    var userImageSrc = row.querySelector(".img-username").src;
    var businessId = row.querySelector(".businessid").textContent;
    var id = row.querySelector(".id").textContent;
    var aboutMe = row.querySelector(".aboutme").textContent;
    var address = row.querySelector(".address").textContent;
    var suspend = row.querySelector(".suspend").textContent;
    const suspendButton = document.querySelector(".suspend-btn");  
    
    if(suspend == "true"){
        suspendButton.classList.add("disabled");
    }
    else{
        suspendButton.classList.remove("disabled");
    }
    var iconElement = document.querySelector(".fa-map-marker");
    panelA.querySelector(".username").textContent = userName;
    panelA.querySelector(".email a").textContent = userEmail;
    panelA.querySelector(".phone").textContent = phone;
    panelA.querySelector(".businessid").textContent = businessId;
    panelA.querySelector(".id").textContent = id;
    panelA.querySelector(".aboutme").textContent = aboutMe;
    panelA.querySelector(".address").textContent = address;
   // panelA.querySelector(".suspend").textContent = suspend;
    panelA.querySelector(".user-profile-image").src = userImageSrc;
    panelA.style.display = "block";
}

function suspendUser(){
    var userId = document.getElementById("id").textContent;
    const suspendButton = document.querySelector(".suspend-btn");
    const confirmed = window.confirm("Are you sure, you want to suspend this user ? Once suspended, you cannot undo the action");

    if (confirmed) {
        const xhr = new XMLHttpRequest();
        xhr.open("POST", `/admin/users/${userId}/suspend`, true);
        xhr.setRequestHeader("Content-Type", "application/json");
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    const response = JSON.parse(xhr.responseText);
                    const message = response.message;
                    alert(message);
                    location.reload();
                } else {
                    alert("Something went wrong");
                }
            }
        };
        xhr.send();
    }
   
}











