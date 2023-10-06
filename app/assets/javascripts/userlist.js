function openSidebar(row) {
    var panelA = document.getElementById("panelA");

    console.log(panelA);

    var userName = row.querySelector(".fs-6").textContent;
    var userEmail = row.querySelector(".email").textContent;
    var phone = row.querySelector(".phone").textContent;
    var userImageSrc = row.querySelector(".img-username").src;
    var businessId = row.querySelector(".businessid").textContent;
    var aboutMe = row.querySelector(".aboutme").textContent;
    var address = row.querySelector(".address").textContent;


    panelA.querySelector(".username").textContent = userName;
    panelA.querySelector(".email a").textContent = userEmail;
    panelA.querySelector(".phone").textContent = phone;
    panelA.querySelector(".businessid").textContent = businessId;
    panelA.querySelector(".aboutme").textContent = aboutMe;
    // panelA.querySelector(".address").textContent = address;
    panelA.querySelector(".user-profile-image").src = userImageSrc;
    panelA.style.display = "block";
}



