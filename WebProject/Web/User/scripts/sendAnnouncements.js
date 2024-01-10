// Custom function to format date in following format
// dd-mm-yyyy
// dd/mm/yyyy
// dd.mm.yyyy
function dateFormater(date, separator) {
  var day = date.getDate();
  // add +1 to month because getMonth() returns month from 0 to 11
  var month = date.getMonth() + 1;
  var year = date.getFullYear();

  // show date and month in two digits
  // if month is less than 10, add a 0 before it
  if (day < 10) {
    day = "0" + day;
  }
  if (month < 10) {
    month = "0" + month;
  }

  // now we have day, month and year
  // use the separator to join them
  return day + separator + month + separator + year;
}

var now = new Date();
console.log(dateFormater(now, "/"));
let myLibrary = [];
var list = document.createElement("ul");
document.getElementById("renderContent").appendChild(list);
list.setAttribute("id", "list");
class announcement {
  constructor(picture, name, message, time, key) {
    (this.name = name),
      (this.picture = picture),
      (this.message = message),
      (this.time = time),
      (this.id = key);
    console.log("key " + key);
    this.removed = false;
  }
}
const remove = (key) => {
  var a = document.getElementById("list");
  var item = document.getElementById(key);
  item.classList.add("hidden");
  // item.removed = true;
  const indexOfObject = myLibrary.findIndex((object) => {
    return object.id === key;
  });
  myLibrary[indexOfObject].removed = true;
  // myLibrary.splice(indexOfObject, 1);
  // console.log(myLibrary);
};
function mapContent() {
  list.innerHTML = myLibrary
    .map((announcement, key) => {
      if (announcement.removed == false) {
        if (announcement.name == "Daniel") {
          console.log("name: " + announcement.name);
          return (
            "<li key=" +
            announcement.id +
            " id=" +
            announcement.id +
            " class ='messageCard'><div  class='messageCardinfo'><div class='messageCardleft'><img class='cardImage' src='../../../images/userProfilePicture.png'></div><div class='messageCardright'><h3>" +
            announcement.name +
            "</h3><p>" +
            announcement.time +
            "</p></div><div id='delete'><button onClick='remove(" +
            key +
            ")' id='deleteButton'><i class='fa-solid fa-x'></i></button></div></div><div class='messageCardmessage'>" +
            announcement.message +
            "</div></li>"
          );
        } else {
          return (
            "<li id=" +
            announcement.id +
            " class ='messageCard'><div  class='messageCardinfo'><div class='messageCardleft'><img class='cardImage' src='../../../images/userProfilePicture.png'></div><div class='messageCardright'><h3>" +
            announcement.name +
            "</h3><p>" +
            announcement.time +
            "</p></div></div><div class='messageCardmessage'>" +
            announcement.message +
            "</div></;>"
          );
        }
      } else return;
    })
    .reverse()
    .join("");
}

mapContent(); //first render
function createBook() {
  let messageValue = document.getElementById("messageInput").value;
  var time = new Date();
  if (messageValue != "") {
    let newAnnouncement = new announcement(
      "picutre",
      "Daniel",
      messageValue,
      dateFormater(time, "/"),
      (key = myLibrary.length)
    );
    myLibrary.push(newAnnouncement);
    mapContent();
    document.getElementById("messageInput").value = "";
    console.log(myLibrary);
  } else return;
}
