/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

function initialize () {
    generateNavBar(PAGE_LEVEL);
} 

function generateNavBar(pageLevel) {
    var navBar = new HTMLGroup(
        "LinkButton",
        ["Resume", "SocialLinks", "AllProjects", "Coursework"],
        "Navbar"
    );
    
    navBar.addInnerContentToAll (
        "h1",
        ["Resume", "", "All Projects", "Coursework"]
    );
    
    var links = ["resume", "social", "projects", "coursework"];
    
    var formatter = new LinkFormatter();
    
    links = formatter.setDirectoryLevel(
            pageLevel,
            links);
            
    navBar.addLinkToAll(
        links
    );
    
    addSocialLinks(navBar, pageLevel);
    
    $('body').append(navBar.getHTML());
}

function addSocialLinks (navBar, pageLevel) {
    var socialImages = ["linkedin.png", "github.png", "twitter.png", "wordpress.png"];
    var links = [
        "https://www.linkedin.com/in/isaiahmann",
        "https://github.com/imann24/",
        "https://twitter.com/isaiah_the_mann",
        "http://isaiahmann.com/blog"
    ];
    
    var formatter = new LinkFormatter();
    

    
    socialImages = formatter.setDirectoryLevel(
            pageLevel,
            formatter.addDirectory(
                "images",
                formatter.addDirectory(
                    "social-icons",
                    socialImages)));
            
    
    var images = new ImageGroup(
        socialImages,
        "social-icon"
    );
    
    images.addLinkToAll(links);
    navBar.addInnerContentToElement(1, images);
    
}
window.onload = initialize;

/** * Apply a class to each child * Required for IE8- */
$('.circle-container').children().each(function() {  $(this).addClass('item'+($(this).index() + 1));});