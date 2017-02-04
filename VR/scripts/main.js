/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
var NAVBAR;
var HEADER_CLASS = "header";
var ACTIVE_ID = "active-link";
var NAVBAR_CLASS = "nav-bar";
var SUBDIRECTORY_EXTENSION = "../";
var Header = function (title, url, active) {
    this.title = title;
    this.directoryLevel = 0;
    
    if (typeof url === "undefined") {
        this.url = "/" + title;
    } else {
        this.url = url;
    }
    
    if (active === true) {
        this.active = active;
    } else {
        this.active = false;
    }
};

Header.prototype.getHTML = function () {
    var subdirectoryLevels="";
    for (var i = 0; i < this.directoryLevel; i++) {
        subdirectoryLevels += SUBDIRECTORY_EXTENSION;
    }
    
            
    var id = this.active?(" id = '" + ACTIVE_ID)+"'":"";
    return  "<a href =" + subdirectoryLevels + this.url + ">" +
            "<div class = '" + HEADER_CLASS + "'" + id  + ">"
            + this.title +  "</div>" + "</a>";
           
};

Header.prototype.setActive = function (active) {
    this.active = active;
};

Header.prototype.setDirectoryLevel = function (directoryLevel) {
    this.directoryLevel = directoryLevel;
};

var Navbar = function (headerNames, headerURLs) {
    this.activeHeaderIndex = -1;
    this.headers = this.generateHeaders(headerNames, headerURLs);
};

Navbar.prototype.generateHeaders = function (headerNames, headerURLs) {
    var headersAreURLs = (typeof headerURLs === 'undefined');
    var headers = [];
    for (var i = 0; i < headerNames.length; i++) {
        headers.push(headersAreURLs?new Header(headerNames[i]):
                new Header(headerNames[i], headerURLs[i], 
                    i === this.activeHeaderIndex));
    }
    
    return headers;
};


Navbar.prototype.getHTML = function () {
    var html = "<div class = '" + NAVBAR_CLASS + "'>";
 
    for (var i = 0; i < this.headers.length; i++) {
        html += this.headers[i].getHTML();
    }
    
    html += "</div>";
    
    return html;
};

Navbar.prototype.setDirectoryLevel = function (directoryLevel) {
    for (var i = 0; i < this.headers.length; i++) {
        this.headers[i].setDirectoryLevel(directoryLevel);
    }
};

Navbar.prototype.refreshHTML = function () {
    document.getElementsByClassName(NAVBAR_CLASS).innerHTML = this.getHTML();
};

Navbar.prototype.setActiveLinkIndex = function (activeLinkIndex) {
    for (var i = 0; i < this.headers.length; i++) {
        this.headers[i].setActive(activeLinkIndex === i);
    }
};

var initialize = function () {
    window.test = "Test";
    
    document.getElementById("header").innerHTML = NAVBAR.getHTML();
};

NAVBAR = new Navbar (["Home", "Videos", "Credits", "Design", "Concept Art", "Source Code"], 
                        ["", "videos", "credits", "design", "concepts", "source"]);
                        
window.onload = initialize;